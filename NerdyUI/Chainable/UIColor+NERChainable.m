//
//  UIColor+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/14.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UIColor+NERChainable.h"
#import "NERPrivates.h"

@implementation UIColor (NERChainable)

- (NERChainableUIColorFloatBlock)opacity {
    NER_FLOAT_BLOCK(return [self colorWithAlphaComponent:value]);
}

- (NERChainableUIColorFloatBlock)hueOffset {
    NER_FLOAT_BLOCK(return [self ner_colorWithHueOffset:value saturationOffset:0 brightnessOffset:0]);
}

- (NERChainableUIColorFloatBlock)saturate {
    NER_FLOAT_BLOCK(return [self ner_colorWithHueOffset:0 saturationOffset:value brightnessOffset:0];);
}

- (NERChainableUIColorFloatBlock)desaturate {
    NER_FLOAT_BLOCK(return [self ner_colorWithHueOffset:0 saturationOffset:-value brightnessOffset:0]);
}

- (NERChainableUIColorFloatBlock)brighten {
    NER_FLOAT_BLOCK(return [self ner_colorWithHueOffset:0 saturationOffset:0 brightnessOffset:value]);
}

- (NERChainableUIColorFloatBlock)darken {
    NER_FLOAT_BLOCK(return [self ner_colorWithHueOffset:0 saturationOffset:0 brightnessOffset:-value]);
}

- (instancetype)complimentary {
    return self.hueOffset(0.5);
}

@end
