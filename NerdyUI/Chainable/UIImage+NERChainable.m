//
//  UIImage+NERChainable.m
//  NerdyUI
//
//  Created by admin on 2016/12/13.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import "UIImage+NERChainable.h"
#import "NerdyUI.h"

@implementation UIImage (NERChainable)

- (NERChainableUIImageSizeBlock)wh {
    NER_SIZE_BLOCK(
                   CGRect rect = CGRectMake(0, 0, value.value.width, value.value.height);
                   BOOL hasAlpha = [NERUtils imageHasAlphaChannel:self];
                   
                   UIGraphicsBeginImageContextWithOptions(rect.size, !hasAlpha, self.scale);
                   [self drawInRect:rect];
                   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                   UIGraphicsEndImageContext();
                   return newImage;
    );
}

- (NERChainableUIImageInsetsBlock)stretchInsets {
    NER_INSETS_BLOCK(return [self resizableImageWithCapInsets:value resizingMode:UIImageResizingModeStretch]);
}

- (NERChainableUIImageInsetsBlock)tileInsets {
    NER_INSETS_BLOCK(return [self resizableImageWithCapInsets:value resizingMode:UIImageResizingModeTile]);
}

- (NERChainableUIImageFloatBlock)blur {
    NER_FLOAT_BLOCK(return [self ner_blueWithRadius:value tintColor:nil saturationDeltaFactor:1 maskImage:nil]);
}

- (instancetype)stretchable {
    CGFloat halfWidth = floorf(self.size.width / 2);
    CGFloat halfHeight = floorf(self.size.height / 2);
    UIEdgeInsets insets = UIEdgeInsetsMake(halfHeight - 1, halfWidth - 1, halfHeight, halfWidth);
    return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

- (instancetype)template {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (instancetype)original {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
