//
//  UIStepper+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/12/30.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"

#define Stepper     [UIStepper new]

@interface UIStepper (NERChainable)

/**
 * value, this value will be pinned to min/max.
 * It's better to set minVal/maxVal before setting val.
 * Usages: .val(50)
 */
NER_STEPPER_PROP(Float)     val;

/**
 * minimumValue
 * Usages: .minVal(0)
 */
NER_STEPPER_PROP(Float)     minVal;

/**
 * maximumValue
 * Usages: .maxVal(100)
 */
NER_STEPPER_PROP(Float)     maxVal;

/**
 * stepValue
 * Usages: .stepVal(2)
 */
NER_STEPPER_PROP(Float)     stepVal;

/**
 * Value did change callback.
 * Use UIControlEventValueChanged event internally.
 * It support two kind of arguments:
 1) a callback block
 2) a selector string
 
 * Usages:
    .onChange(^{}), .onChange(^(NSInteger value){}), .onChange(^(NSInteger value, id stepper){})
    .onChange(@"stepperValueDidChange"), .onChange(@"stepperValueDidChange:")
 */
NER_STEPPER_PROP(Callback)  onChange;

@end
