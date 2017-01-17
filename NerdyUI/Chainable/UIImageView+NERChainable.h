//
//  UIImageView+NERChainable.h
//  NerdyUI
//
//  Created by CAI on 10/14/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"
#import "NERPrivates.h"

#define ImageView   [UIImageView ner_littleHigherHuggingAndResistanceView]

@interface UIImageView (NERChainable)

/**
 * Setting image or animationImages value. Will update imageView's size if haven't set yet.
 * img use Img() internally, so it can take any kind of arguments that Img() supported.
 * Additionally it can take an NSArray of image.
 
 * Usages: 
    .img(@"imageName"), .img(@"#stretchableImageName"), .img(imageObject),
    .img(@[@"walk1", @"walk2", @"walk3"])
 
 * See UIImage+NERChainable.h for more information.
 */
NER_IV_PROP(Object)     img;

/**
 * Setting highlightedImage or highlightedAnimationImages.
 * highImg use Img() internally, so it can take any kind of arguments that Img() supported.
 
 * Usages: 
    .highImg(@"imageName"), .highImg(@"#stretchableImageName"), .highImg(imageObject),
    .highImg(@[@"walk1", @"walk2", @"walk3"])
 
 * See UIImage+NERChainable.h for more information.
 */
NER_IV_PROP(Object)     highImg;


/**
 * ContentMode
 * Usages: .aspectFit
 */

//UIViewContentModeScaleAspectFit
- (instancetype)aspectFit;

//UIViewContentModeScaleAspectFill
- (instancetype)aspectFill;

//UIViewContentModeCenter
- (instancetype)centerMode;

@end
