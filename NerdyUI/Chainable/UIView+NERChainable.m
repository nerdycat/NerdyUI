//
//  UIView+NERChainable.m
//  NerdyUI
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import "UIView+NERChainable.h"
#import "NerdyUI.h"


@implementation UIView (NERChainable)

- (NERChainableUIViewIntBlock)tg {
    NER_INT_BLOCK(self.tag = value);
}

- (NERChainableUIViewFloatBlock)opacity {
    NER_FLOAT_BLOCK(self.alpha = value);
}

- (NERChainableUIViewObjectBlock)bgColor {
    NER_OBJECT_BLOCK(self.backgroundColor = Color(value));
}

- (NERChainableUIViewFloatBlock)cr {
    NER_FLOAT_BLOCK(
                    self.layer.cornerRadius = value;
                    if (self.layer.shadowOpacity == 0) {
                        self.layer.masksToBounds = YES;
                    }
                    );
}

- (NERChainableUIViewFloatObjectListBlock)bd {
    NER_FLOAT_OBJECT_LIST_BLOCK(
                                self.layer.borderWidth = value;
                                if (arguments.firstObject) {
                                    self.layer.borderColor = Color(arguments.firstObject).CGColor;
                                }
                                );
}

- (NERChainableUIViewFloatListBlock)sd {
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

- (NERChainableUIViewCallbackBlock)onClick {
    NER_CALLBACK_BLOCK(
                       if (block) {
                           SEL sel = @selector(ner_view_onClickHandler);
                           objc_setAssociatedObject(self, sel, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                           return self.onClick(self, sel);
                           
                       } else if (target && action) {
                           self.userInteractionEnabled = YES;
                           
                           if ([self isKindOfClass:[UIButton class]]) {
                               UIButton *button = (UIButton *)self;
                               [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
                               
                           } else {
                               id reg = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
                               [self addGestureRecognizer:reg];
                           }
                           
                           return self;
                       }
    );
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

@end




@implementation UIView (NERChainable_Frame)

#define NER_SAFE_ASSIGN(a, b)   if (b != NERNull) a = b

- (NERChainableUIViewPointBlock)xy {
    NER_POINT_BLOCK(
                    CGRect frame = self.frame;
                    NER_SAFE_ASSIGN(frame.origin.x, value.value.x);
                    NER_SAFE_ASSIGN(frame.origin.y, value.value.y);
                    self.frame = frame;
    );
}

- (NERChainableUIViewSizeBlock)wh {
    NER_SIZE_BLOCK(
                   CGRect frame = self.frame;
                   NER_SAFE_ASSIGN(frame.size.width, value.value.width);
                   NER_SAFE_ASSIGN(frame.size.height, value.value.height);
                   self.frame = frame;
    );
}

- (NERChainableUIViewRectBlock)xywh {
    NER_RECT_BLOCK(self.frame = value.value);
}

- (NERChainableUIViewPointBlock)cxy {
    NER_POINT_BLOCK(
                    CGPoint center = self.center;
                    NER_SAFE_ASSIGN(center.x, value.value.x);
                    NER_SAFE_ASSIGN(center.y, value.value.y);
                    self.center = center;
    );
}

- (NERChainableUIViewPointBlock)maxXY {
    NER_POINT_BLOCK(
                    CGRect frame = self.frame;
                    if (value.value.x != NERNull) frame.origin.x = value.value.x - frame.size.width;
                    if (value.value.y != NERNull) frame.origin.y = value.value.y - frame.size.height;
                    self.frame = frame;
    );
}

- (instancetype)fitWidth {
    return self.w([self sizeThatFits:CGSizeMake(MAXFLOAT, self.height)].width);
}

- (instancetype)fitHeight {
    return self.h([self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)].height);
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




