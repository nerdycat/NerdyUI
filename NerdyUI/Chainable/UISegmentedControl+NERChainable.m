//
//  UISegmentedControl+NERChainable.m
//  NerdyUI
//
//  Created by admin on 2016/12/29.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import "UISegmentedControl+NERChainable.h"
#import "NerdyUI.h"

@implementation UISegmentedControl (NERChainable)

- (NERChainableUISegmentedControlObjectBlock)tint {
    NER_OBJECT_BLOCK(self.tintColor = Color(value));
}

- (NERChainableUISegmentedControlCallbackBlock)onChange {
    NER_CALLBACK_BLOCK(return [self ner_registerOnChangeHandlerWithBlock:block target:target action:action];);
}

@end
