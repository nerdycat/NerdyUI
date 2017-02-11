//
//  UIStepper+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/30.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UIStepper+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "NERUtils.h"
#import "NERPrivates.h"

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

- (NERChainableUIStepperCallbackBlock)onChange {
    NER_CALLBACK_BLOCK(return [self ner_registerOnChangeHandlerWithTarget:target object:object];);
}

@end
