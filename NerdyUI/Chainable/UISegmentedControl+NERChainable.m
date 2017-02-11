//
//  UISegmentedControl+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/29.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UISegmentedControl+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "NERUtils.h"

@implementation UISegmentedControl (NERChainable)

- (NERChainableUISegmentedControlCallbackBlock)onChange {
    NER_CALLBACK_BLOCK(return [self ner_registerOnChangeHandlerWithTarget:target object:object];;);
}

@end
