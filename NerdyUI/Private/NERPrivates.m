//
//  NERPrivates.m
//  NerdyUI
//
//  Created by nerdycat on 10/3/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

@import Accelerate;
#import <CommonCrypto/CommonDigest.h>
#import "NERPrivates.h"
#import "NERUtils.h"


@implementation NSObject (NERPrivate)

//https://mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
//https://github.com/rentzsch/jrswizzle
+ (BOOL)ner_swizzleMethod:(SEL)selector1 withMethod:(SEL)selector2 {
    Method m1 = class_getInstanceMethod(self, selector1);
    Method m2 = class_getInstanceMethod(self, selector2);
    
    if (!m1 || !m2) {
        return NO;
    }
    
    class_addMethod(self, selector1, method_getImplementation(m1), method_getTypeEncoding(m1));
    class_addMethod(self, selector2, method_getImplementation(m2), method_getTypeEncoding(m2));
    
    m1 = class_getInstanceMethod(self, selector1);
    m2 = class_getInstanceMethod(self, selector2);
    method_exchangeImplementations(m1, m2);
    
    return YES;
}

+ (BOOL)ner_swizzleClassMethod:(SEL)selector1 withMethod:(SEL)selector2 {
    return [object_getClass(self) ner_swizzleMethod:selector1 withMethod:selector2];
}

- (id)ner_associatedObjectForKey:(NSString *)key {
    NSMutableDictionary *objects = objc_getAssociatedObject(self, @selector(ner_setAssociatedObject:forKey:));
    return [objects objectForKey:key];
}

- (void)ner_setAssociatedObject:(id)object forKey:(NSString *)key {
    NSMutableDictionary *map = objc_getAssociatedObject(self, _cmd);
    if (!map) {
        map = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, _cmd, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (object) {
        [map setObject:object forKey:key];
    } else {
        [map removeObjectForKey:key];
    }
}

- (id)ner_weakAssociatedObjectForKey:(NSString *)key {
    NSMapTable *map = objc_getAssociatedObject(self, @selector(ner_setWeakAssociatedObject:forKey:));
    return [map objectForKey:key];
}

- (void)ner_setWeakAssociatedObject:(id)object forKey:(NSString *)key {
    NSMapTable *map = objc_getAssociatedObject(self, _cmd);
    if (!map) {
        map = [NSMapTable strongToWeakObjectsMapTable];
        objc_setAssociatedObject(self, _cmd, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (object) {
        [map setObject:object forKey:key];
    } else {
        [map removeObjectForKey:key];
    }
}

- (NSArray *)ner_allPropertyNames {
    unsigned count = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [array addObject:name];
    }
    
    free(properties);
    return array;
}

- (NSArray *)ner_allIvarNames {
    unsigned count;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < count; ++i) {
        Ivar ivar = ivars[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [array addObject:name];
    }
    
    free(ivars);
    return array;
}

- (NSArray *)ner_allMethodNames {
    unsigned count;
    Method *methods = class_copyMethodList(self.class, &count);
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < count; ++i) {
        Method method = methods[i];
        NSString *name = NSStringFromSelector(method_getName(method));
        [array addObject:name];
    }
    
    free(methods);
    return array;
}

@end




@implementation NSString (NERPrivate)

- (NSRange)ner_fullRange {
    return NSMakeRange(0, self.length);
}

- (NSString *)ner_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5 = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5 appendFormat:@"%02x", result[i]];
    }
    
    return [md5 lowercaseString];
}

- (NSString *)ner_base64 {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

- (NSString *)ner_urlEncode {
    CFStringRef newStringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                       (CFStringRef)self,
                                                                       NULL,
                                                                       CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                       kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)newStringRef;
}

- (NSString *)ner_urlDecode {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)ner_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end




@implementation NSMutableAttributedString (NERPrivate)

NER_SYNTHESIZE_BOOL(nerAddAttributeIfNotExists, setNerAddAttributeIfNotExists);
NER_SYNTHESIZE_BOOL(nerIsJustSettingEffectedRanges, setNerIsJustSettingEffectedRanges);
NER_SYNTHESIZE(nerEffectedRanges, setNerEffectedRanges);

- (NSArray *)ner_complementaryRangesWithRanges:(NSArray *)ranges inRange:(NSRange)inRange {
    NSMutableArray *targets = [NSMutableArray array];
    
    if (!ranges.count) {
        [targets addObject:[NSValue valueWithRange:inRange]];
        return targets;
    }
    
    for (int i = 0; i < ranges.count; ++i) {
        NSRange range = [ranges[i] rangeValue];
        NSInteger begin = inRange.location;
        NSInteger end = range.location;
        
        if (i != 0) {
            NSRange previousRange = [ranges[i - 1] rangeValue];
            begin = previousRange.location + previousRange.length;
        }
        
        if (end > begin) {
            [targets addObject:[NSValue valueWithRange:NSMakeRange(begin, end - begin)]];
        }
    }
    
    if (ranges.count) {
        NSRange lastRange = [ranges.lastObject rangeValue];
        NSInteger begin = lastRange.location + lastRange.length;
        NSInteger end = inRange.location + inRange.length;
        
        if (end > begin) {
            [targets addObject:[NSValue valueWithRange:NSMakeRange(begin, end - begin)]];
        }
    }
    
    return targets;
}

- (void)ner_addAttributeIfNotExist:(NSString *)name value:(id)value range:(NSRange)range {
    NSMutableArray *ranges = [NSMutableArray array];
    [self enumerateAttribute:name inRange:range options:0 usingBlock:^(id _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value) {
            [ranges addObject:[NSValue valueWithRange:range]];
        }
    }];
    
    NSArray *complementaryRanges = [self ner_complementaryRangesWithRanges:ranges inRange:range];
    for (NSValue *rangeValue in complementaryRanges) {
        [self addAttribute:name value:value range:[rangeValue rangeValue]];
    }
}

- (void)ner_setParagraphStyleValue:(id)value forKey:(NSString *)key {
    [self ner_setParagraphStyleValue:value forKey:key range:[self.string ner_fullRange]];
}

- (void)ner_setParagraphStyleValue:(id)value forKey:(NSString *)key range:(NSRange)range {
    NSParagraphStyle *style = nil;
    
    if (NSEqualRanges(range, [self.string ner_fullRange])) {
        style = [self attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
    } else {
        style = [self attribute:NSParagraphStyleAttributeName atIndex:range.location longestEffectiveRange:NULL inRange:range];
    }
    
    NSMutableParagraphStyle *mutableStyle = nil;
    if (style) {
        mutableStyle = [style mutableCopy];
    } else {
        mutableStyle = [NSMutableParagraphStyle new];
        mutableStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    [mutableStyle setValue:value forKey:key];
    [self addAttribute:NSParagraphStyleAttributeName value:mutableStyle range:range];
    
    if ([key isEqualToString:@"lineSpacing"]) {
        [self addAttribute:NERFixLineSpacingAttributeName value:NERFixLineSpacingAttributeValue range:range];
    }
}

- (void)ner_applyAttribute:(NSString *)name withValue:(id)value {
    self.nerIsJustSettingEffectedRanges = NO;
    
    [self.nerEffectedRanges enumerateRangesUsingBlock:^(NSRange range, BOOL * _Nonnull stop) {
        if ([name isEqualToString:NERLinkAttributeName]) {
            [self addAttribute:name value:value range:range];
            
//            if (![self attribute:NSForegroundColorAttributeName atIndex:range.location effectiveRange:NULL]) {
                static UIColor *defaultLinkColor = nil;
                if (!defaultLinkColor) defaultLinkColor = [UIColor colorWithRed:19/255. green:90/255. blue:1 alpha:1];
                [self addAttribute:NSForegroundColorAttributeName value:defaultLinkColor range:range];
//            }
            
        } else {
            if (self.nerAddAttributeIfNotExists) {
                [self ner_addAttributeIfNotExist:name value:value range:range];
            } else {
                [self addAttribute:name value:value range:range];
            }
        }
    }];
}

+ (instancetype)ner_attributedStringWithString:(NSString *)string {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
    att.nerEffectedRanges = [NSMutableIndexSet indexSetWithIndexesInRange:[string ner_fullRange]];
    return att;
}

+ (instancetype)ner_attributedStringWithSubstrings:(NSArray *)substrings {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] init];
    
    for (id sub in substrings) {
        id subAtt = nil;
        
        if ([sub isKindOfClass:NSAttributedString.class]) {
            subAtt = sub;
            
        } else if ([sub isKindOfClass:NSString.class]) {
            subAtt = [[NSAttributedString alloc] initWithString:sub];
            
        } else if ([sub isKindOfClass:UIImage.class]) {
            NSTextAttachment *attachment = [NSTextAttachment new];
            attachment.image = sub;
            subAtt = [NSAttributedString attributedStringWithAttachment:attachment];
            
        } else if ([sub isKindOfClass:NSData.class]) {
            id options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
            subAtt = [[NSAttributedString alloc] initWithData:sub options:options documentAttributes:nil error:nil];
        }
        
        if (subAtt) {
            [att appendAttributedString:subAtt];
        }
    }
    
    att.nerEffectedRanges = [NSMutableIndexSet indexSetWithIndexesInRange:[att.string ner_fullRange]];
    return att;
}

@end




@implementation UIView (NERPriavte)

NER_SYNTHESIZE_STRUCT(nerTouchInsets, setNerTouchInsets, UIEdgeInsets);

+ (void)load {
    [self ner_swizzleMethod:@selector(pointInside:withEvent:) withMethod:@selector(ner_pointInside:withEvent:)];
}

- (BOOL)ner_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchInsets = self.nerTouchInsets;
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, touchInsets);
    return CGRectContainsPoint(rect, point);
}

- (CGSize)ner_fittingSize {
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (void)ner_addChild:(id)value {
    UIView *parent = self;
    if ([parent isKindOfClass:UIVisualEffectView.class]) {
        parent = ((UIVisualEffectView *)parent).contentView;
    }
    
    if ([value isKindOfClass:[UIView class]]) {
        [parent addSubview:value];
        
    } else if ([value isKindOfClass:[NSArray class]]) {
        for (id view in value) {
            [parent addSubview:view];
        }
        
    } else {
        @throw @"Invalid child";
    }
}

- (UIImage *)ner_snapShot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (instancetype)ner_updateFrame:(NERRect)rect {
    CGRect frame = rect.value;
    CGRect newFrame = self.frame;
    
    if (frame.origin.x != NERNull) {
        newFrame.origin.x = frame.origin.x;
    }
    if (frame.origin.y != NERNull) {
        newFrame.origin.y = frame.origin.y;
    }
    if (frame.size.width != NERNull) {
        newFrame.size.width = frame.size.height;
    }
    if (frame.size.height != NERNull) {
        newFrame.size.height = frame.size.height;
    }
    
    self.frame = newFrame;
    return self;
}

+ (instancetype)ner_littleHigherHuggingAndResistanceView {
    UIView *view = [self.class new];
    [view setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [view setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    [view setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisVertical];
    return view;
}

@end




@implementation UIImageView (NERPriavte)


@end




@implementation UIButton (NERPriavte)

NER_SYNTHESIZE_FLOAT(nerGap, setNerGap);
NER_SYNTHESIZE_STRUCT(nerInsets, setNerInsets, UIEdgeInsets);

- (instancetype)ner_reverseButton {
    if (CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity)) {
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    } else {
        self.transform = CGAffineTransformIdentity;
        self.titleLabel.transform = CGAffineTransformIdentity;
        self.imageView.transform = CGAffineTransformIdentity;
    }
    return self;
}

+ (instancetype)ner_littleHigherHuggingAndResistanceButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [button setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisVertical];
    return button;
}

@end




@implementation UITextField (NERPriavte)

NER_SYNTHESIZE_INT(nerMaxLength, setNerMaxLength, if (nerMaxLength > 0) [self ner_watchTextChange]);
NER_SYNTHESIZE_STRUCT(nerContentEdgeInsets, setNerContentEdgeInsets, UIEdgeInsets, [self setNeedsDisplay]; [self invalidateIntrinsicContentSize]);
NER_SYNTHESIZE_BLOCK(nerTextChangeBlock, setNerTextChangeBlock, NERObjectBlock, if (nerTextChangeBlock) [self ner_watchTextChange]);
NER_SYNTHESIZE_BLOCK(nerEndOnExitBlock, setNerEndOnExitBlock, NERObjectBlock, if (nerEndOnExitBlock) [self ner_watchEndOnExit]);

+ (void)load {
    [self ner_swizzleMethod:@selector(textRectForBounds:) withMethod:@selector(ner_textRectForBounds:)];
    [self ner_swizzleMethod:@selector(editingRectForBounds:) withMethod:@selector(ner_editingRectForBounds:)];
}

- (CGRect)ner_textRectForBounds:(CGRect)bounds {
    CGRect rect = [self ner_textRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, [self nerContentEdgeInsets]);
}

- (CGRect)ner_editingRectForBounds:(CGRect)bounds {
    CGRect rect = [self ner_editingRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, [self nerContentEdgeInsets]);
}

- (void)ner_watchTextChange {
    [self removeTarget:self action:@selector(ner_textDidChange) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(ner_textDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)ner_watchEndOnExit {
    [self removeTarget:self action:@selector(ner_textDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self addTarget:self action:@selector(ner_textDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)ner_textDidEndOnExit {
    void (^callback)(id, id) = (id)self.nerEndOnExitBlock;
    if (callback) callback(self.text, self);
}

- (void)ner_textDidChange {
    BOOL hasMarked = [NERUtils limitTextInput:self withLength:self.nerMaxLength];
    if (!hasMarked) {
        void (^callback)(id, id) = (id)self.nerTextChangeBlock;
        if (callback) callback(self.text, self);
    }
}

+ (instancetype)ner_autoEnableReturnKeyTextField {
    UITextField *textField = [UITextField new];
    textField.enablesReturnKeyAutomatically = YES;
    return textField;
}

@end




@implementation UITextView (NERPriavte)

#define NER_PLACEHOLDER_TAG 98789
NER_SYNTHESIZE_INT(nerMaxLength, setNerMaxLength, if (nerMaxLength > 0) [self ner_watchTextChange]);
NER_SYNTHESIZE_BLOCK(nerTextChangeBlock, setNerTextChangeBlock, NERObjectBlock, if (nerTextChangeBlock) [self ner_watchTextChange]);

+ (void)load {
    [self ner_swizzleMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(ner_textViewDealloc)];
}

- (void)ner_textViewDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([self ner_placeholderLabel]) {
        for (NSString *key in [self ner_observingKeys]) {
            @try { [self removeObserver:self forKeyPath:key]; }
            @catch (NSException *exception) {}
        }
    }
    
    [self ner_textViewDealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    [self ner_updatePlaceholderLabel];
}


- (void)ner_watchTextChange {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ner_textDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (void)ner_textDidChange {
    BOOL hasMarked = [NERUtils limitTextInput:self withLength:self.nerMaxLength];
    [self ner_updatePlaceholderLabel];
    
    if (!hasMarked) {
        void (^callback)(id, id) = (id)self.nerTextChangeBlock;
        if (callback) callback(self.text, self);
    }
}

- (void)ner_setPlaceholderText:(id)stringObject {
    if (![self ner_placeholderLabel]) {
        [self ner_setupPlaceholderLabel];
    }
    
    [NERUtils setTextWithStringObject:stringObject forView:[self ner_placeholderLabel]];
    [self ner_updatePlaceholderLabel];
}

- (UILabel *)ner_placeholderLabel {
    return [self viewWithTag:NER_PLACEHOLDER_TAG];
}

- (void)ner_setupPlaceholderLabel {
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.tag = NER_PLACEHOLDER_TAG;
    label.textColor = [self ner_defaultPlaceholderColor];
    [self insertSubview:label atIndex:0];
    
    [self ner_watchTextChange];
    [self ner_updatePlaceholderLabel];
    
    for (NSString *key in [self ner_observingKeys]) {
        @try {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:NULL];
        } @catch (NSException *exception) {}
    }
}

- (UIColor *)ner_defaultPlaceholderColor {
    static UIColor *color = nil;
    
    if (!color) {
        UITextField *tf = [UITextField new];
        tf.placeholder = @" ";
        
        @try {
            color = [tf valueForKeyPath:@"_placeholderLabel.textColor"];
        } @catch (NSException *exception) {}
        
        if (!color) {
            color = [UIColor colorWithRed:199./255 green:199./255 blue:205./255 alpha:1];
        }
    }
    
    return color;
}

- (UIFont *)ner_getTextFont {
    UIFont *font = self.font;
    
    if (!font && !self.text) {
        self.text = @" ";
        font = self.font;
        self.text = nil;
    }
    
    if (!font) {
        font = [UIFont systemFontOfSize:12];
    }
    return font;
}

- (void)ner_updatePlaceholderLabel {
    UILabel *label = [self ner_placeholderLabel];
    label.hidden = !(self.text.length == 0 && self.attributedText.length == 0);
    
    if (label && !label.hidden) {
        label.font = [self ner_getTextFont];
        label.textAlignment = self.textAlignment;
        
        UIEdgeInsets insets = self.textContainerInset;
        CGFloat padding = self.textContainer.lineFragmentPadding;
        
        CGFloat x = insets.left + padding;
        CGFloat y = insets.top;
        CGFloat width = self.bounds.size.width - insets.right - padding - x;
        CGFloat height = [label sizeThatFits:CGSizeMake(width, 0)].height;
        
        label.frame = CGRectMake(x, y, width, height);
    }
}

- (NSArray *)ner_observingKeys {
    return @[
             @"bounds",
             @"frame",
             @"font",
             @"text",
             @"attributedText",
             @"textAlignment",
             @"textContainerInset",
             @"textContainer.lineFragmentPadding"
             ];
}


@end




@implementation UISlider (NERPriavte)

NER_SYNTHESIZE(nerTrackHeight, setNerTrackHeight);
NER_SYNTHESIZE_STRUCT(nerThumbInsets, setNerThumbInsets, UIEdgeInsets);

+ (void)load {
    [self ner_swizzleMethod:@selector(trackRectForBounds:) withMethod:@selector(ner_trackRectForBounds:)];
    [self ner_swizzleMethod:@selector(ner_thumbRectForBounds:trackRect:value:) withMethod:@selector(thumbRectForBounds:trackRect:value:)];
}

- (CGRect)ner_trackRectForBounds:(CGRect)bounds {
    CGRect rect = [self ner_trackRectForBounds:bounds];
    if (self.nerTrackHeight) {
        rect.size.height = [self.nerTrackHeight floatValue];
    }
    return rect;
}

- (CGRect)ner_thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    UIEdgeInsets insets = self.nerThumbInsets;
    rect.origin.x -= insets.left;
    rect.origin.y -= insets.top;
    rect.size.width += insets.left + insets.right;
    rect.size.height += insets.top + insets.bottom;
    
    CGRect thumbRect = [self ner_thumbRectForBounds:bounds trackRect:rect value:value];
    return UIEdgeInsetsInsetRect(thumbRect, insets);
}

- (void)ner_control_onChangeHandler {
    void (^callback)(CGFloat, id) = objc_getAssociatedObject(self, _cmd);
    if (callback) callback(self.value, self);
}

@end




@implementation UIPageControl (NERPriavte)

- (void)ner_control_onChangeHandler {
    void (^callback)(NSInteger, id) = objc_getAssociatedObject(self, _cmd);
    if (callback) callback(self.currentPage, self);
}

@end




@implementation UISwitch (NERPriavte)

- (void)ner_control_onChangeHandler {
    void (^callback)(BOOL, id) = objc_getAssociatedObject(self, _cmd);
    if (callback) callback(self.isOn, self);
}

@end



@implementation UIStepper (NERPriavte)

- (void)ner_control_onChangeHandler {
    void (^callback)(double, id) = objc_getAssociatedObject(self, _cmd);
    if (callback) callback(self.value, self);
}

@end


@implementation UIVisualEffectView (NERPriavte)

+ (void)load {
    [self ner_swizzleMethod:@selector(setEffect:) withMethod:@selector(ner_setEffect:)];
}

NER_SYNTHESIZE(nerVibrancyEffectView, setNerVibrancyEffectView);

- (void)ner_setEffect:(UIVisualEffect *)effect {
    [self ner_setEffect:effect];
    
    if ([effect isKindOfClass:UIBlurEffect.class]) {
        UIVisualEffectView *vibrancyView = self.nerVibrancyEffectView;
        
        if (vibrancyView) {
            vibrancyView.effect = [UIVibrancyEffect effectForBlurEffect:(id)effect];
        }
    }
}

- (void)ner_addVibrancyChild:(id)object {
    if ([self.effect isKindOfClass:UIBlurEffect.class]) {
        UIVisualEffectView *vibrancyView = self.nerVibrancyEffectView;
        
        if (!vibrancyView) {
            vibrancyView = [UIVisualEffectView new];
            vibrancyView.effect = [UIVibrancyEffect effectForBlurEffect:(id)self.effect];
            
            vibrancyView.frame  = self.contentView.bounds;
            vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.contentView insertSubview:vibrancyView atIndex:0];
            
            self.nerVibrancyEffectView = vibrancyView;
        }
        
        [vibrancyView ner_addChild:object];
        
    } else {
        [self ner_addChild:object];
    }
}

@end



@implementation UISegmentedControl (NERPriavte)

- (void)ner_control_onChangeHandler {
    void (^callback)(NSInteger, id) = objc_getAssociatedObject(self, _cmd);
    if (callback) callback(self.selectedSegmentIndex, self);
}

+ (instancetype)ner_segmentedControlWithItems:(NSArray *)items {
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:items];
    [sc sizeToFit];
    sc.selectedSegmentIndex = 0;
    return sc;
}

@end




@implementation UIControl (NERPriavte)

- (instancetype)ner_registerOnChangeHandlerWithTarget:(id)target object:(id)object {
    if (NER_IS_BLOCK(object)) {
        SEL action = @selector(ner_control_onChangeHandler);
        objc_setAssociatedObject(self, action, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return [self ner_registerOnChangeHandlerWithTarget:self object:@"ner_control_onChangeHandler"];
//        return [self ner_registerOnChangeHandlerWithBlock:nil target:self action:sel];
        
    } else {
        SEL action = NSSelectorFromString(object);
        [self addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

@end



@implementation UIColor (NERPrivate)

- (UIColor *)ner_colorWithHueOffset:(CGFloat)ho saturationOffset:(CGFloat)so brightnessOffset:(CGFloat)bo {
    CGFloat hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    hue += ho;
    if (hue > 1) hue = hue - floorf(hue);
    if (hue < 0) hue = 1 + (hue + floorf(fabs(hue)));
    
    saturation = MAX(MIN(saturation + so, 1), 0);
    brightness = MAX(MIN(brightness + bo, 1), 0);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

@end



@implementation UIImage (NERPrivate)

- (UIImage *)ner_stretchableImage {
    CGFloat halfWidth = floorf(self.size.width / 2);
    CGFloat halfHeight = floorf(self.size.height / 2);
    UIEdgeInsets insets = UIEdgeInsetsMake(halfHeight - 1, halfWidth - 1, halfHeight, halfWidth);
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)ner_blueWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
#define ENABLE_BLUR                     1
#define ENABLE_SATURATION_ADJUSTMENT    1
#define ENABLE_TINT                     1
    
    UIImage *inputImage = self;
    
    // Check pre-conditions.
    if (inputImage.size.width < 1 || inputImage.size.height < 1)
    {
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", inputImage.size.width, inputImage.size.height, inputImage);
        return nil;
    }
    if (!inputImage.CGImage)
    {
        NSLog(@"*** error: inputImage must be backed by a CGImage: %@", inputImage);
        return nil;
    }
    if (maskImage && !maskImage.CGImage)
    {
        NSLog(@"*** error: effectMaskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    
    CGImageRef inputCGImage = inputImage.CGImage;
    CGFloat inputImageScale = inputImage.scale;
    CGBitmapInfo inputImageBitmapInfo = CGImageGetBitmapInfo(inputCGImage);
    CGImageAlphaInfo inputImageAlphaInfo = (inputImageBitmapInfo & kCGBitmapAlphaInfoMask);
    
    CGSize outputImageSizeInPoints = inputImage.size;
    CGRect outputImageRectInPoints = { CGPointZero, outputImageSizeInPoints };
    
    // Set up output context.
    BOOL useOpaqueContext;
    if (inputImageAlphaInfo == kCGImageAlphaNone || inputImageAlphaInfo == kCGImageAlphaNoneSkipLast || inputImageAlphaInfo == kCGImageAlphaNoneSkipFirst)
        useOpaqueContext = YES;
    else
        useOpaqueContext = NO;
    UIGraphicsBeginImageContextWithOptions(outputImageRectInPoints.size, useOpaqueContext, inputImageScale);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -outputImageRectInPoints.size.height);
    
    if (hasBlur || hasSaturationChange)
    {
        vImage_Buffer effectInBuffer;
        vImage_Buffer scratchBuffer1;
        
        vImage_Buffer *inputBuffer;
        vImage_Buffer *outputBuffer;
        
        vImage_CGImageFormat format = {
            .bitsPerComponent = 8,
            .bitsPerPixel = 32,
            .colorSpace = NULL,
            // (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little)
            // requests a BGRA buffer.
            .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little,
            .version = 0,
            .decode = NULL,
            .renderingIntent = kCGRenderingIntentDefault
        };
        
        vImage_Error e = vImageBuffer_InitWithCGImage(&effectInBuffer, &format, NULL, inputImage.CGImage, kvImagePrintDiagnosticsToConsole);
        if (e != kvImageNoError)
        {
            NSLog(@"*** error: vImageBuffer_InitWithCGImage returned error code %zi for inputImage: %@", e, inputImage);
            UIGraphicsEndImageContext();
            return nil;
        }
        
        vImageBuffer_Init(&scratchBuffer1, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, kvImageNoFlags);
        inputBuffer = &effectInBuffer;
        outputBuffer = &scratchBuffer1;
        
#if ENABLE_BLUR
        if (hasBlur)
        {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * inputImageScale;
            if (inputRadius - 2. < __FLT_EPSILON__)
                inputRadius = 2.;
            uint32_t radius = floor((inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5) / 2);
            
            radius |= 1; // force radius to be odd so that the three box-blur methodology works.
            
            NSInteger tempBufferSize = vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
            void *tempBuffer = malloc(tempBufferSize);
            
            vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(outputBuffer, inputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            
            free(tempBuffer);
            
            vImage_Buffer *temp = inputBuffer;
            inputBuffer = outputBuffer;
            outputBuffer = temp;
        }
#endif
        
#if ENABLE_SATURATION_ADJUSTMENT
        if (hasSaturationChange)
        {
            CGFloat s = saturationDeltaFactor;
            // These values appear in the W3C Filter Effects spec:
            // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/index.html#grayscaleEquivalent
            //
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,                    1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            vImageMatrixMultiply_ARGB8888(inputBuffer, outputBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            
            vImage_Buffer *temp = inputBuffer;
            inputBuffer = outputBuffer;
            outputBuffer = temp;
        }
#endif
        
        CGImageRef effectCGImage;
        if ( (effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, &ner_cleanupBuffer, NULL, kvImageNoAllocate, NULL)) == NULL ) {
            effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, NULL, NULL, kvImageNoFlags, NULL);
            free(inputBuffer->data);
        }
        if (maskImage) {
            // Only need to draw the base image if the effect image will be masked.
            CGContextDrawImage(outputContext, outputImageRectInPoints, inputCGImage);
        }
        
        // draw effect image
        CGContextSaveGState(outputContext);
        if (maskImage)
            CGContextClipToMask(outputContext, outputImageRectInPoints, maskImage.CGImage);
        CGContextDrawImage(outputContext, outputImageRectInPoints, effectCGImage);
        CGContextRestoreGState(outputContext);
        
        // Cleanup
        CGImageRelease(effectCGImage);
        free(outputBuffer->data);
    }
    else
    {
        // draw base image
        CGContextDrawImage(outputContext, outputImageRectInPoints, inputCGImage);
    }
    
#if ENABLE_TINT
    // Add in color tint.
    if (tintColor)
    {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, outputImageRectInPoints);
        CGContextRestoreGState(outputContext);
    }
#endif
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
#undef ENABLE_BLUR
#undef ENABLE_SATURATION_ADJUSTMENT
#undef ENABLE_TINT
}

static void ner_cleanupBuffer(void *userData, void *buf_data)
{ free(buf_data); }

@end




