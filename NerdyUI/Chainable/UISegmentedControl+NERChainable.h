//
//  UISegmentedControl+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/12/29.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"
#import "NERPrivates.h"

/**
 * Create UISegmentedControl with items.
 * Items can be NSStrings or UIImages.
 * Usages: Segmented(@"Item1", @"Item2", Img(@"cat"))
 */
#define Segmented(...)  [UISegmentedControl ner_segmentedControlWithItems:@[__VA_ARGS__]]

@interface UISegmentedControl (NERChainable)

/**
 * tintColor
 * tint use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .tint(@"red"), .tint(@"#F00"), .tint(255,0,0), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_SEGMENTED_PROP(Object)      tint;

/**
 * Value did change callback.
 * Use UIControlEventValueChanged event internally.
 * It support two kind of arguments:
    1) a callback block
    2) a selector string
 
 * Usages: 
    .onChange(^{}), .onChange(^(NSInteger selectedIndex){}), .onChange(^(NSInteger selectedIndex, id segmentedControl){})
    .onChange(@"segmentedControlValueDidChange"), .onChange(@"segmentedControlValueDidChange:")
 */
NER_SEGMENTED_PROP(Callback)    onChange;

@end
