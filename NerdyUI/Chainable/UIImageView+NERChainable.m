//
//  UIImageView+NERChainable.m
//  NerdyUI
//
//  Created by CAI on 10/14/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UIImageView+NERChainable.h"
#import "UIImage+NERChainable.h"
#import "NSArray+NERChainable.h"

@implementation UIImageView (NERChainable)

- (NERChainableUIImageViewObjectBlock)img {
    NER_OBJECT_BLOCK(
                     if ([value isKindOfClass:[NSArray class]]) {
                         self.animationImages = ((NSArray *)value).map(^(id imageObject) {
                             return Img(imageObject);
                         });
                         [NERUtils updateViewSizeIfNeed:self withImage:self.animationImages.firstObject];
                     } else {
                         self.image = Img(value);
                         [NERUtils updateViewSizeIfNeed:self withImage:self.image];
                     }
                     );
}

- (NERChainableUIImageViewObjectBlock)highImg {
    NER_OBJECT_BLOCK(
                     if ([value isKindOfClass:[NSArray class]]) {
                         self.highlightedAnimationImages = value;
                     } else {
                         self.highlightedImage = Img(value);
                     }
                     );
}

- (instancetype)aspectFit {
    self.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}

- (instancetype)aspectFill {
    self.contentMode = UIViewContentModeScaleAspectFill;
    return self;
}

- (instancetype)centerMode {
    self.contentMode = UIViewContentModeCenter;
    return self;
}

@end
