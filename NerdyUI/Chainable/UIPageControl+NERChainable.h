//
//  UIPageControl+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/12/20.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"

#define PageControl     [UIPageControl new]

@interface UIPageControl (NERChainable)

/**
 * numberOfPages
 * Usages: .pages(5)
 */
NER_PC_PROP(Int)        pages;

/**
 * pageIndicatorTintColor
 * The tint color to be used for the page indicator.
 * color use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .color(@"red"), .color(@"#F00"), .color(@"255,0,0"), .color(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_PC_PROP(Object)     color;

/**
 * currentPageIndicatorTintColor
 * The tint color to be used for the current page indicator.
 * highColor use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .highColor(@"red"), .highColor(@"#F00"), .highColor(@"255,0,0"), .highColor(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_PC_PROP(Object)     highColor;

/**
 * Value did change callback.
 * Use UIControlEventValueChanged event internally.
 * It support two kind of arguments:
    1) a callback block
    2) a selector string
 
 * Usages: 
    .onChange(^{}), .onChange(^(NSInteger currentPage){}), .onChange(^(NSInteger currentPage, id pageControl){})
    .onChange(@"switchValueDidChange"), .onChange(@"switchValueDidChange:")
 */
NER_PC_PROP(Callback)   onChange;


//hidesForSinglePage
- (instancetype)hideForSingle;

@end
