//
//  UISwitch+NERChainable.m
//  NerdyUI
//
//  Created by admin on 2016/12/20.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import "UISwitch+NERChainable.h"
#import "NerdyUI.h"
#import "NERPrivates.h"

@implementation UISwitch (NERChainable)

- (NERChainableUISwitchObjectBlock)onColor {
    NER_OBJECT_BLOCK(self.onTintColor = Color(value));
}

- (NERChainableUISwitchObjectBlock)thumbColor {
    NER_OBJECT_BLOCK(self.thumbTintColor = Color(value));
}

- (NERChainableUISwitchObjectBlock)outlineColor {
    NER_OBJECT_BLOCK(self.tintColor = Color(value));
}

- (NERChainableUISwitchCallbackBlock)onChange {
    NER_CALLBACK_BLOCK(return [self ner_registerOnChangeHandlerWithBlock:block target:target action:action];);
}

@end
