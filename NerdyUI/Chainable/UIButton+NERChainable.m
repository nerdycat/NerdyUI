//
//  UIButton+NERChainable.m
//  NerdyUI
//
//  Created by CAI on 10/14/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UIButton+NERChainable.h"
#import "UIFont+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "UIImage+NERChainable.h"

@implementation UIButton (NERChainable)

- (NERChainableUIButtonObjectBlock)str {
    NER_OBJECT_BLOCK([NERUtils setTextWithStringObject:value forView:self]);
}

- (NERChainableUIButtonObjectBlock)fnt {
    NER_OBJECT_BLOCK(self.titleLabel.font = Fnt(value));
}

- (NERChainableUIButtonObjectBlock)color {
    NER_OBJECT_BLOCK([self setTitleColor:Color(value) forState:UIControlStateNormal]);
}

- (NERChainableUIButtonObjectBlock)highColor {
    NER_OBJECT_BLOCK([self setTitleColor:Color(value) forState:UIControlStateHighlighted]);
}

- (NERChainableUIButtonObjectBlock)selectedColor {
    NER_OBJECT_BLOCK([self setTitleColor:Color(value) forState:UIControlStateSelected]);
}

- (NERChainableUIButtonObjectBlock)disabledColor {
    NER_OBJECT_BLOCK([self setTitleColor:Color(value) forState:UIControlStateDisabled]);
}

- (NERChainableUIButtonObjectBlock)img {
    NER_OBJECT_BLOCK(
                     id image = Img(value);
                     [self setImage:image forState:UIControlStateNormal];
                     [NERUtils updateViewSizeIfNeed:self withImage:image];
                     );
}

- (NERChainableUIButtonObjectBlock)highImg {
    NER_OBJECT_BLOCK([self setImage:Img(value) forState:UIControlStateHighlighted]);
}

- (NERChainableUIButtonObjectBlock)selectedImg {
    NER_OBJECT_BLOCK([self setImage:Img(value) forState:UIControlStateSelected]);
}

- (NERChainableUIButtonObjectBlock)disabledImg {
    NER_OBJECT_BLOCK([self setImage:Img(value) forState:UIControlStateDisabled]);
}

- (NERChainableUIButtonObjectBlock)bgImg {
    NER_OBJECT_BLOCK(
                     id image = Img(value);
                     [self setBackgroundImage:image forState:UIControlStateNormal];
                     [NERUtils updateViewSizeIfNeed:self withImage:image];
                     );
}

- (NERChainableUIButtonObjectBlock)highBgImg {
    NER_OBJECT_BLOCK(
                     id image = Img(value);
                     [self setBackgroundImage:image forState:UIControlStateHighlighted];
                     );
}

- (NERChainableUIButtonObjectBlock)selectedBgImg {
    NER_OBJECT_BLOCK(
                     id image = Img(value);
                     [self setBackgroundImage:image forState:UIControlStateSelected];
                     );
}

- (NERChainableUIButtonObjectBlock)disabledBgImg {
    NER_OBJECT_BLOCK(
                     id image = Img(value);
                     [self setBackgroundImage:image forState:UIControlStateDisabled];
                     );
}

- (NERChainableUIButtonFloatBlock)gap {
    NER_FLOAT_BLOCK(
                    self.nerGap = value;
                    CGFloat halfGap = value / 2;
                    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, halfGap, 0, -halfGap)];
                    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -halfGap, 0, halfGap)];
                    
                    UIEdgeInsets insets = self.nerInsets;
                    insets.left += halfGap;
                    insets.right += halfGap;
                    self.contentEdgeInsets = insets;
                    );
}

- (NERChainableUIButtonInsetsBlock)insets {
    NER_INSETS_BLOCK(
                     CGFloat halfGap = self.nerGap / 2;
                     self.nerInsets = value;
                     
                     UIEdgeInsets insets = value;
                     insets.left += halfGap;
                     insets.right += halfGap;
                     self.contentEdgeInsets = insets;
                     );
}

- (instancetype)reversed {
    CATransform3D t = CATransform3DMakeScale(-1, 1, 1);
    self.layer.sublayerTransform = t;
    self.imageView.layer.transform = t;
    self.titleLabel.layer.transform = t;
    return self;
}

- (instancetype)multiline {
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    return self;
}

- (instancetype)adjustDisabled {
    self.adjustsImageWhenHighlighted = NO;
    return self;
}

@end
