//
//  UIFont+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/12/14.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERUtils.h"


/**
 * Create a UIFont.
 * Fnt argument can be:
   1) UIFont object
   2) 15: systemFontOfSize 15
   3) @15: boldSystemFontOfSize 15
   4) @"headline", @"body", @"caption1", and any other UIFontTextStyle.
   5) @"Helvetica,15": fontName + fontSize, separated by comma.
 
 * Usages: Fnt([UIFont systemFontOfSize:15]),
           Fnt(15),
           Fnt(@15), 
           Fnt(@"body"), 
           Fnt(@"Helvetica,15")
 */
#define Fnt(x)  [NERUtils fontWithFontObject:NER_CONVERT_VALUE_TO_STRING(x)]


@interface UIFont (NERChainable)

@end
