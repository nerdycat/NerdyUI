//
//  UIButton+NERChainable.h
//  NerdyUI
//
//  Created by CAI on 10/14/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"
#import "NERPrivates.h"

#define Button  [UIButton ner_littleHigherHuggingAndResistanceButton]

@interface UIButton (NERChainable)

/**
 * Setting title or attributedTitle.
 * str use Str() internally, so it can take any kind of arguments that Str() supported.
 * Additionally it can take an NSAttributedString object.
 
 * Usages: 
    .str(100), .str(@3.14), .str(@"hello"), .str(@"%d+%d=%d", 1, 1, 1 + 1),
    .str(someAttributedString), .str(AttStr(@"hello").fnt(20).underline), etc.
 
 * See NSString+NERChainable.h and NSAttributedString+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     str;

/**
 * Setting title font.
 * fnt use Fnt() internally, so it can take any kind of arguments that Fnt() supported.
 * Usages: .fnt(15), .fnt(@15), .fnt(@"headline"), .fnt(@"Helvetica,15"), .fnt(fontObject), etc.
 * See UIFont+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     fnt;



/**
 * Setting normal title color.
 * color use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .color(@"red"), .color(@"#F00"), .color(@"255,0,0"), .color(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     color;

/**
 * Setting highlighted title color.
 * highColor use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .highColor(@"red"), .highColor(@"#F00"), .highColor(@"255,0,0"), .highColor(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     highColor;

/**
 * Setting selected title color.
 * selectedColor use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .selectedColor(@"red"), .selectedColor(@"#F00"), .selectedColor(@"255,0,0"), .selectedColor(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     selectedColor;

/**
 * Setting disabled title color.
 * disabledColor use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .disabledColor(@"red"), .disabledColor(@"#F00"), .disabledColor(@"255,0,0"), .disabledColor(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     disabledColor;



/**
 * Setting normal image. Will update button's size if haven't set yet.
 * img use Img() internally, so it can take any kind of arguments that Img() supported.
 * Usages: .img(@"imageName"), .img(@"#stretchableImageName"), .img(imageObject), etc.
 * See UIImage+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     img;

/**
 * Setting highlighted image.
 * highImg use Img() internally, so it can take any kind of arguments that Img() supported.
 * Usages: .highImg(@"imageName"), .highImg(@"#stretchableImageName"), .highImg(imageObject), etc.
 * See UIImage+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     highImg;

/**
 * Setting selected image.
 * selectedImg use Img() internally, so it can take any kind of arguments that Img() supported.
 * Usages: .selectedImg(@"imageName"), .selectedImg(@"#stretchableImageName"), .selectedImg(imageObject), etc.
 * See UIImage+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     selectedImg;

/**
 * Setting disabled image.
 * disabledImg use Img() internally, so it can take any kind of arguments that Img() supported.
 * Usages: .disabledImg(@"imageName"), .disabledImg(@"#stretchableImageName"), .disabledImg(imageObject), etc.
 * See UIImage+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     disabledImg;



/**
 * Setting normal background image. Will update button's size if haven't set yet.
 * bgImg use Img() internally, so it can take any kind of arguments that Img() supported.
 
 * .bgImg(@"red") is another way to set background color for Button. Useful for Button embedded in UITableViewCell.
 
 * Usages: .bgImg(@"imageName"), .bgImg(@"#stretchableImageName"), .bgImg(imageObject), .bgImg(@"red"), etc.
 * See UIImage+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     bgImg;

/**
 * Setting highlighted background image.
 * highBgImg use Img() internally, so it can take any kind of arguments that Img() supported.
 
 * .highBgImg(@"blue") is a very useful way to specify highlighted background color for Button.
 
 * Usages: .highBgImg(@"imageName"), .highBgImg(@"#stretchableImageName"), .highBgImg(@"blue"), etc.
 * See UIImage+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     highBgImg;

/**
 * Setting selected background image.
 * selectedBgImg use Img() internally, so it can take any kind of arguments that Img() supported.
 * Usages: .selectedBgImg(@"imageName"), .selectedBgImg(@"#stretchableImageName"), .selectedBgImg(@"blue"), etc.
 * See UIImage+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     selectedBgImg;

/**
 * Setting disabled background image.
 * disabledBgImg use Img() internally, so it can take any kind of arguments that Img() supported.
 * Usages: .disabledBgImg(@"imageName"), .disabledBgImg(@"#stretchableImageName"), .disabledBgImg(@"blue"), etc.
 * See UIImage+NERChainable.h for more information.
 */
NER_BUTTON_PROP(Object)     disabledBgImg;

/*
 Tips:
  bgImg, highBgImg, selectedBgImg and disabledBgImg can be use to create flat button by passing color value.
  highBgImg is very useful for setting highlighted background color.
 
 Examples:
  Button.wh(100, 40).cr(20).str(@"Tap Me").color(@"black").highColor(@"white").bgImg(@"red").highBgImg(@"blue");
  Button.wh(100, 40).bd(1).cr(20).str(@"hello").color(@"darkGray").highBgImg(@"black,0.2")
*/




/**
 * Spacing between image and title.
 * Usages: .gap(10)
 */
NER_BUTTON_PROP(Float)      gap;

/**
 * contentEdgeInsets
 * Usages:
    .insets(10)                     top/left/bottom/right = 10
    .insets(10, 20)                 top/bottom = 10, left/right = 20
    .insets(10, 20, 30),            top = 10, left/right = 20, bottom = 30
    .insets(10, 20, 30, 40)         top = 10, left = 20, bottom = 30, right = 40
 */
NER_BUTTON_PROP(Insets)     insets;


//Reverse image and title's position
- (instancetype)reversed;

//Enable multilines
- (instancetype)multiline;

//adjustsImageWhenHighlighted = NO
- (instancetype)adjustDisabled;

@end





