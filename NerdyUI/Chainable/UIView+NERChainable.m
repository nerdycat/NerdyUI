//
//  UIView+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UIView+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "NERConstraint+NERChainable.h"
#import "NERUtils.h"
#import "NERPrivates.h"


@implementation UIView (NERChainable)

- (NERChainableUIViewIntBlock)tg {
    NER_INT_BLOCK(self.tag = value);
}

- (NERChainableUIViewFloatBlock)opacity {
    NER_FLOAT_BLOCK(self.alpha = value);
}

- (NERChainableUIViewObjectBlock)tint {
    NER_OBJECT_BLOCK(self.tintColor = Color(value));
}

- (NERChainableUIViewObjectBlock)bgColor {
    NER_OBJECT_BLOCK(self.backgroundColor = Color(value));
}

- (NERChainableUIViewFloatBlock)borderRadius {
    NER_FLOAT_BLOCK(
                    self.layer.cornerRadius = value;
                    if (self.layer.shadowOpacity == 0) {
                        self.layer.masksToBounds = YES;
                    }
                    );
}

- (NERChainableUIViewFloatObjectListBlock)border {
    NER_FLOAT_OBJECT_LIST_BLOCK(
                                self.layer.borderWidth = value;
                                if (arguments.firstObject) {
                                    self.layer.borderColor = Color(arguments.firstObject).CGColor;
                                }
                                );
}

- (NERChainableUIViewFloatListBlock)shadow {
    NER_FLOAT_LIST_BLOCK(
                         self.layer.masksToBounds = NO;
                         self.layer.shadowOpacity = value.f1;
                         
                         if (CGSizeEqualToSize(self.layer.shadowOffset, CGSizeMake(0, -3))) {
                             self.layer.shadowOffset = CGSizeMake(0, 3);
                         }
                         
                         if (value.validCount >= 2) {
                             self.layer.shadowRadius = value.f2;
                         }
                         
                         CGSize offset = self.layer.shadowOffset;
                         
                         if (value.validCount >= 3) {
                             offset.width = value.f3;
                         }
                         if (value.validCount >= 4) {
                             offset.height = value.f4;
                         }
                         
                         self.layer.shadowOffset = offset;
    );
}

- (NERChainableUIViewObjectBlock)styles {
    NER_OBJECT_BLOCK([NERUtils applyStyleObject:value toItem:self];);
}

- (NERChainableUIViewInsetsBlock)touchInsets {
    NER_INSETS_BLOCK( self.nerTouchInsets = value );
}

- (NERChainableUIViewCallbackBlock)onClick {
    NER_CALLBACK_BLOCK(
                        if (NER_IS_BLOCK(object)) {
                            SEL action = @selector(ner_view_onClickHandler);
                            objc_setAssociatedObject(self, action, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                            [self ner_view_addClickHandler:self action:action];
                        } else {
                            SEL action = NSSelectorFromString(object);
                            [self ner_view_addClickHandler:target action:action];
                        }
    );
}

- (void)ner_view_addClickHandler:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        id reg = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:reg];
    }
}

- (void)ner_view_onClickHandler {
    id block = objc_getAssociatedObject(self, _cmd);
    if (block) ((NERObjectBlock)block)(self);
}

- (NERChainableUIViewObjectBlock)addTo {
    NER_OBJECT_BLOCK(
                     [value isKindOfClass:UIVisualEffectView.class]?
                     [((UIVisualEffectView *)value).contentView addSubview:self]:
                     [value addSubview:self];
                     );
}

- (NERChainableUIViewObjectBlock)addChild {
    NER_OBJECT_BLOCK([self ner_addChild:value]);
}

- (instancetype)clip {
    self.clipsToBounds = YES;
    return self;
}

- (instancetype)touchEnabled {
    self.userInteractionEnabled = YES;
    return self;
}

- (instancetype)touchDisabled {
    self.userInteractionEnabled = NO;
    return self;
}

- (instancetype)stateDisabled {
    if ([self respondsToSelector:@selector(setEnabled:)]) {
        [((id)self) setEnabled:NO];
    }
    return self;
}

- (instancetype)invisible {
    self.hidden = YES;
    return self;
}

- (void (^)())End {
    return ^{};
}

@end




@implementation UIView (NERChainable_Frame)

#define NER_SAFE_ASSIGN(a, b)   if (b != NERNull && b!= NSIntegerMin) a = b

- (NERChainableUIViewRectBlock)xywh {
    return ^(NERRect rect) {
        CGRect frame = rect.value;
        CGRect newFrame = self.frame;
        
        //setting x
        if (frame.size.width != NSIntegerMin) {
            NER_SAFE_ASSIGN(newFrame.origin.x, frame.origin.x);
            
        //setting maxX
        } else  if (frame.origin.x != NERNull) {
            newFrame.origin.x = frame.origin.x - newFrame.size.width;
        }
        
        //setting y
        if (frame.size.height != NSIntegerMin) {
            NER_SAFE_ASSIGN(newFrame.origin.y, frame.origin.y);
            
        //setting maxY
        } else if (frame.origin.y != NERNull) {
            newFrame.origin.y = frame.origin.y - newFrame.size.height;
        }
        
        NER_SAFE_ASSIGN(newFrame.size.width, frame.size.width);
        NER_SAFE_ASSIGN(newFrame.size.height, frame.size.height);
        
        self.frame = newFrame;
        return self;
    };
}

- (NERChainableUIViewPointBlock)cxy {
    return ^(NERPoint point) {
        CGPoint center = point.value;
        CGPoint newCenter = self.center;
        
        NER_SAFE_ASSIGN(newCenter.x, center.x);
        NER_SAFE_ASSIGN(newCenter.y, center.y);
        
        self.center = newCenter;
        return self;
    };
}

- (instancetype)fitWidth {
    return self.w([self sizeThatFits:CGSizeMake(MAXFLOAT, self.h)].width);
}

- (instancetype)fitHeight {
    return self.h([self sizeThatFits:CGSizeMake(self.w, MAXFLOAT)].height);
}

- (instancetype)fitSize {
    [self sizeToFit];
    return self;
}

- (instancetype)flexibleLeft {
    self.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
    return self;
}

- (instancetype)flexibleRight {
    self.autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
    return self;
}

- (instancetype)flexibleTop {
    self.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    return self;
}

- (instancetype)flexibleBottom {
    self.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
    return self;
}

- (instancetype)flexibleLR {
    return self.flexibleLeft.flexibleRight;
}

- (instancetype)flexibleTB {
    return self.flexibleTop.flexibleBottom;
}

- (instancetype)flexibleLRTB {
    return self.flexibleLeft.self.flexibleRight.self.flexibleTop.self.flexibleBottom;
}

- (instancetype)flexibleWidth {
    self.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
    return self;
}

- (instancetype)flexibleHeight {
    self.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
    return self;
}

- (instancetype)flexibleWH {
    return self.flexibleWidth.self.flexibleHeight;
}

@end





@implementation UIView (NERChainable_Autolayout)

- (NERChainableUIViewFloatBlock)horHugging {
    NER_FLOAT_BLOCK([self setContentHuggingPriority:value forAxis:UILayoutConstraintAxisHorizontal]);
}

- (NERChainableUIViewFloatBlock)verHugging {
    NER_FLOAT_BLOCK([self setContentHuggingPriority:value forAxis:UILayoutConstraintAxisVertical]);
}

- (NERChainableUIViewFloatBlock)horResistance {
    NER_FLOAT_BLOCK([self setContentCompressionResistancePriority:value forAxis:UILayoutConstraintAxisHorizontal]);
}

- (NERChainableUIViewFloatBlock)verResistance {
    NER_FLOAT_BLOCK([self setContentCompressionResistancePriority:value forAxis:UILayoutConstraintAxisVertical]);
}

- (NERChainableUIViewFloatBlock)fixWidth {
    NER_FLOAT_BLOCK(Constraint(self).width.constants(value).priority(950).update());
}

- (NERChainableUIViewFloatBlock)fixHeight {
    NER_FLOAT_BLOCK(Constraint(self).height.constants(value).priority(950).update());
}

- (NERChainableUIViewSizeBlock)fixWH {
    NER_SIZE_BLOCK(Constraint(self).size.constants(value.value.width, value.value.height).priority(950).update());
}

- (NERChainableUIViewEmbedBlock)embedIn {
    return ^(UIView *superview, UIEdgeInsets insets) {
        if ([superview isKindOfClass:UIVisualEffectView.class]) {
            superview = ((UIVisualEffectView *)superview).contentView;
        }
        
        [superview addSubview:self];
        
        if (insets.top != NERNull) {
            Constraint(self).top.constants(insets.top).priority(950).update();
        }
        
        if (insets.left != NERNull) {
            Constraint(self).left.constants(insets.left).priority(950).update();
        }
        
        if (insets.bottom != NERNull) {
            Constraint(self).bottom.constants(-insets.bottom).priority(950).update();
        }
        
        if (insets.right != NERNull) {
            Constraint(self).right.constants(-insets.right).priority(950).update();
        }
        
        return self;
    };
}

- (instancetype)lowHugging {
    return self.horHugging(100).verHugging(100);
}

- (instancetype)highHugging {
    return self.horHugging(900).verHugging(900);
}

- (instancetype)lowResistance {
    return self.horResistance(100).verResistance(100);
}

- (instancetype)highResistance {
    return self.horResistance(900).verResistance(900);
}


#define SYNTHESIZE_CONSTRIANTS_PROP(x, y) \
- (NERChainableUIViewObjectBlock)x {\
    NER_OBJECT_BLOCK(\
                     if (NER_IS_BLOCK(value)) {\
                         NERConstraintMaker *make = [[NERConstraintMaker alloc] initWithFirstItem:self];\
                         ((NERObjectBlock)value)(make);\
                         [make y:nil];\
                     }\
    );\
}

SYNTHESIZE_CONSTRIANTS_PROP(makeCons, makeConstraints);
SYNTHESIZE_CONSTRIANTS_PROP(remakeCons, remakeConstraints);
SYNTHESIZE_CONSTRIANTS_PROP(updateCons, updateConstraints);

@end




