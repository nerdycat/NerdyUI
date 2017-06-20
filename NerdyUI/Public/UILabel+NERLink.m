//
//  UILabel+NERLink.m
//  NerdyUI
//
//  Created by CAI on 10/13/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//


#import <UIkit/UIGestureRecognizerSubclass.h>
#import "UILabel+NERLink.h"
#import "NERDefs.h"
#import "NERPrivates.h"


@interface NERLinkInfo : NSObject

@property (nonatomic, copy)     NSString *text;
@property (nonatomic, assign)   NSRange range;
@property (nonatomic, strong)   NSArray *boundingRects;

@end

@implementation NERLinkInfo

- (BOOL)containsPoint:(CGPoint)point {
    for (NSValue *rectValue in self.boundingRects) {
        if (CGRectContainsPoint([rectValue CGRectValue], point)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldCancelTouchAtPoint:(CGPoint)point {
    BOOL isNearby = NO;
    
    for (NSValue *rectValue in self.boundingRects) {
        if (CGRectContainsPoint(CGRectInset([rectValue CGRectValue], -50, -50), point)) {
            isNearby = YES;
            break;
        }
    }
    
    return !isNearby;
}

@end



@interface NERLinkGestureRegcognizer : UIGestureRecognizer <UIGestureRecognizerDelegate>
@end

@implementation NERLinkGestureRegcognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return NO;
}

@end




@interface UILabel (NERLinkPrivate)

@property (nonatomic, assign) CGPoint nerTouchBeginPoint;
@property (nonatomic, strong) NERLinkInfo *nerSelectedLinkInfo;
@property (nonatomic, strong) NSMutableArray *nerSelectedLayers;

@end


@implementation UILabel (NERLink)

NER_SYNTHESIZE_FLOAT(nerLineGap, setNerLineGap, [self ner_updateAttributedString]);

NER_SYNTHESIZE(nerLinkSelectedColor, setNerLinkSelectedColor);
NER_SYNTHESIZE(nerSelectedLinkInfo, setNerSelectedLinkInfo);
NER_SYNTHESIZE(nerSelectedLayers, setNerSelectedLayers);

NER_SYNTHESIZE_FLOAT(nerLinkSelectedBorderRadius, setNerLinkSelectedBorderRadius);
NER_SYNTHESIZE_STRUCT(nerTouchBeginPoint, setNerTouchBeginPoint, CGPoint);
NER_SYNTHESIZE_BLOCK(nerLinkHandler, setNerLinkHandler, NERLinkHandler);

static char *nerPrivateTextStorageKey;
static UIColor *nerPrivateDefaultLinkSelectedBackgroundColor = nil;
static CGFloat nerPrivateDefaultLinkSelectedBorderRadius = 0;


+ (void)setDefaultLinkSelectedBackgroundColor:(UIColor *)color borderRadius:(CGFloat)borderRadius {
    nerPrivateDefaultLinkSelectedBackgroundColor = color;
    nerPrivateDefaultLinkSelectedBorderRadius = borderRadius;
}

+ (void)load {
    [self ner_swizzleMethod:@selector(setText:) withMethod:@selector(ner_setText:)];
    [self ner_swizzleMethod:@selector(setUserInteractionEnabled:) withMethod:@selector(ner_setUserInteractionEnabled:)];
    [self setDefaultLinkSelectedBackgroundColor:[UIColor darkGrayColor] borderRadius:4];
}

- (void)ner_updateAttributedString {
    if (self.attributedText.string.length) {
        NSMutableAttributedString *att = [self.attributedText mutableCopy];
        [att ner_setParagraphStyleValue:@(self.nerLineGap) forKey:@"lineSpacing"];
        self.attributedText = att;
    }
}

- (void)ner_setText:(NSString *)text {
    [self ner_setText:text];
    
    if (self.nerLineGap > 0) {
        [self ner_updateAttributedString];
    }
}

- (void)ner_setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [self ner_setUserInteractionEnabled:userInteractionEnabled];
    
    if (userInteractionEnabled && ![self ner_containLinkGesture]) {
        id reg = [[NERLinkGestureRegcognizer alloc] initWithTarget:self action:@selector(ner_handleLinkGesture:)];
        [self addGestureRecognizer:reg];
    }
}

- (NSLayoutManager *)nerLayoutManager {
    NSLayoutManager *layoutManager = objc_getAssociatedObject(self, _cmd);
    
    if (!layoutManager) {
        layoutManager = [[NSLayoutManager alloc] init];
        
        NSTextStorage *textStorage = [[NSTextStorage alloc] init];
        [textStorage addLayoutManager:layoutManager];
        layoutManager.textStorage = textStorage;
        
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
        textContainer.lineFragmentPadding = 0;
        textContainer.layoutManager = layoutManager;
        [layoutManager addTextContainer:textContainer];
        
        objc_setAssociatedObject(self, _cmd, layoutManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, nerPrivateTextStorageKey, textStorage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [att ner_addAttributeIfNotExist:NSFontAttributeName value:self.font range:[att.string ner_fullRange]];
    [att ner_setParagraphStyleValue:@(self.textAlignment) forKey:@"alignment" range:NSMakeRange(0, att.string.length)];
    
    if (self.numberOfLines != 1 && self.lineBreakMode != NSLineBreakByCharWrapping && self.lineBreakMode != NSLineBreakByWordWrapping) {
        [att ner_setParagraphStyleValue:@(NSLineBreakByWordWrapping) forKey:@"lineBreakMode" range:NSMakeRange(0, att.string.length)];
    }
    
    [layoutManager.textStorage setAttributedString:att];
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    
    textContainer.maximumNumberOfLines = self.numberOfLines;
    textContainer.lineBreakMode = self.lineBreakMode;
    textContainer.size = self.bounds.size;
    return layoutManager;
}

- (void)ner_addHighlightedLayersForLinkInfo:(NERLinkInfo *)info {
    if (!self.nerSelectedLayers) {
        self.nerSelectedLayers = [NSMutableArray array];
    }
    
    for (NSValue *rectValue in info.boundingRects) {
        CGRect rect = [rectValue CGRectValue];
        
        if (rect.size.width > 0 && rect.size.height > 0) {
            [self ner_addHighlightedLayerWithFrame:rect];
        }
    }
}

- (void)ner_addHighlightedLayerWithFrame:(CGRect)rect {
    CALayer *layer = [CALayer new];
    layer.frame = rect;
    
    UIColor *color = self.nerLinkSelectedColor?: nerPrivateDefaultLinkSelectedBackgroundColor;
    CGFloat borderRadius = nerPrivateDefaultLinkSelectedBorderRadius;
    
    if (objc_getAssociatedObject(self, @selector(nerLinkSelectedBorderRadius))) {
        borderRadius = self.nerLinkSelectedBorderRadius;
    }
    
    if (CGColorGetAlpha(color.CGColor) == 1) {
        color = [color colorWithAlphaComponent:0.4];
    }
    
    [self.layer addSublayer:layer];
        
    layer.cornerRadius = borderRadius;
    layer.backgroundColor = color.CGColor;
    [self.nerSelectedLayers addObject:layer];
}

- (void)removeHighlightedViews {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(ner_addHighlightedLayersForLinkInfo:)
                                               object:self.nerSelectedLinkInfo];
    
    for (CALayer *layer in self.nerSelectedLayers) {
        [layer removeFromSuperlayer];
    }
    
    [self.nerSelectedLayers removeAllObjects];
    self.nerSelectedLayers = nil;
    self.nerSelectedLinkInfo = nil;
}


- (NSArray *)boundingRectsForTextInRange:(NSRange)range yOffset:(CGFloat)yOffset {
    NSLayoutManager *layoutManager = self.nerLayoutManager;
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    CGRect textRect = [layoutManager usedRectForTextContainer:textContainer];
    
    NSMutableArray *boundingRects = [NSMutableArray array];
    NSRange glyphRange = [layoutManager glyphRangeForCharacterRange:range actualCharacterRange:NULL];
    
    [layoutManager enumerateEnclosingRectsForGlyphRange:glyphRange
                               withinSelectedGlyphRange:NSMakeRange(NSNotFound, 0)
                                        inTextContainer:textContainer
                                             usingBlock:^(CGRect rect, BOOL * _Nonnull stop) {
                                                 
                                                 CGRect lineRect = [layoutManager lineFragmentUsedRectForGlyphAtIndex:range.location
                                                                                                       effectiveRange:NULL];
                                                 
                                                 NSParagraphStyle *ps = [layoutManager.textStorage attribute:NSParagraphStyleAttributeName
                                                                                                     atIndex:range.location
                                                                                       longestEffectiveRange:NULL
                                                                                                     inRange:range];
                                                 
                                                 if (ps && ps.lineSpacing > 0 && ceilf(CGRectGetMaxY(rect)) != ceilf(CGRectGetMaxY(textRect))) {
                                                     rect.size.height = ceilf(rect.size.height - ps.lineSpacing);
                                                 }
                                                 
                                                 if (CGRectGetMaxX(rect) > CGRectGetMaxX(lineRect)) {
                                                     rect.size.width = CGRectGetMaxX(lineRect) - rect.origin.x;
                                                 }
                                                 
                                                 rect.origin.y += yOffset;
                                                 [boundingRects addObject:[NSValue valueWithCGRect:rect]];
                                             }];
    
    return boundingRects;
}

- (CGFloat)calculateTextYOffset {
    NSLayoutManager *layoutManager = self.nerLayoutManager;
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    
    NSRange textRange = [layoutManager glyphRangeForTextContainer:textContainer];
    CGRect textRect = [layoutManager boundingRectForGlyphRange:textRange inTextContainer:textContainer];
    
    if (self.bounds.size.height > textRect.size.height) {
        return (self.bounds.size.height - textRect.size.height) / 2;
    } else {
        return 0;
    }
}


- (BOOL)ner_containLinkGesture {
    for (id reg in self.gestureRecognizers) {
        if ([reg isKindOfClass:[NERLinkGestureRegcognizer class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)ner_handleLinkGesture:(UIPanGestureRecognizer *)reg {
    if (reg.state == UIGestureRecognizerStateBegan) {
        [self ner_handleTouchBegin:reg];
        
    } else if (reg.state == UIGestureRecognizerStateChanged) {
        if (!self.nerSelectedLinkInfo) return;
        
        CGPoint point = [reg locationInView:self];
        if ([self.nerSelectedLinkInfo shouldCancelTouchAtPoint:point]) {
            [self removeHighlightedViews];
        }
    } else if (reg.state == UIGestureRecognizerStateEnded || reg.state == UIGestureRecognizerStateCancelled) {
        if (self.nerSelectedLinkInfo) {
            NERLinkHandler handler = self.nerLinkHandler;
            if (handler) handler(self.nerSelectedLinkInfo.text, self.nerSelectedLinkInfo.range);
            [self removeHighlightedViews];
        }
    }
}

- (void)ner_handleTouchBegin:(UIGestureRecognizer *)reg {
    self.nerTouchBeginPoint = [reg locationInView:self];
    
    __block CGFloat textYOffset = -1;
    
    NSMutableArray *linkInfos = [NSMutableArray array];
    NSRange fullRange = NSMakeRange(0, self.attributedText.string.length);
    
    [self.attributedText enumerateAttribute:NERLinkAttributeName
                                    inRange:fullRange
                                    options:0
                                 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                                     if (value) {
                                         if (textYOffset == -1) {
                                             textYOffset = [self calculateTextYOffset];
                                         }
                                         
                                         NERLinkInfo *info = [NERLinkInfo new];
                                         info.range = range;
                                         info.text = [self.attributedText.string substringWithRange:range];
                                         info.boundingRects = [self boundingRectsForTextInRange:range yOffset:textYOffset];
                                         [linkInfos addObject:info];
                                     }
                                 }];
    
    for (NERLinkInfo *info in linkInfos) {
        if ([info containsPoint:self.nerTouchBeginPoint]) {
            self.nerSelectedLinkInfo = info;
            [self performSelector:@selector(ner_addHighlightedLayersForLinkInfo:) withObject:info afterDelay:0.05];
        }
    }
}

@end






