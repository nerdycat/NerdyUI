//
//  UIStepper+NERChainable.m
//  NerdyUI
//
//  Created by admin on 2016/12/30.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import "UIStepper+NERChainable.h"
#import "NerdyUI.h"

@implementation UIStepper (NERChainable)

- (NERChainableUIStepperFloatBlock)val {
    NER_FLOAT_BLOCK(self.value = value);
}

- (NERChainableUIStepperFloatBlock)minVal {
    NER_FLOAT_BLOCK(self.minimumValue = value);
}

- (NERChainableUIStepperFloatBlock)maxVal {
    NER_FLOAT_BLOCK(self.maximumValue = value);
}

- (NERChainableUIStepperFloatBlock)stepVal {
    NER_FLOAT_BLOCK(self.stepValue = value);
}

- (NERChainableUIStepperObjectBlock)tint {
    NER_OBJECT_BLOCK(self.tintColor = Color(value));
}

- (NERChainableUIStepperCallbackBlock)onChange {
    NER_CALLBACK_BLOCK(return [self ner_registerOnChangeHandlerWithBlock:block target:target action:action];);
}

@end
