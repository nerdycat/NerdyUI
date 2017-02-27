//
//  UIImage+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/13.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UIImage+NERChainable.h"
#import "NERPrivates.h"

@implementation UIImage (NERChainable)

- (NERChainableUIImageRectBlock)subImg {
    NER_RECT_BLOCK(
                   CGRect rect = value.value;
                   rect.origin.x *= self.scale;
                   rect.origin.y *= self.scale;
                   rect.size.width *= self.scale;
                   rect.size.height *= self.scale;
                   
                   CGImageRef ref = CGImageCreateWithImageInRect(self.CGImage, rect);
                   UIImage *image =  [UIImage imageWithCGImage:ref scale:self.scale orientation:self.imageOrientation];
                   CGImageRelease(ref);
                   return image;
                   );
}

- (NERChainableUIImageTwoFloatBlock)resize {
    NER_TWO_FLOAT_BLOCK(
                        CGRect rect = CGRectMake(0, 0, value1, value2);
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
    return [self ner_stretchableImage];
}

- (instancetype)templates {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (instancetype)original {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
