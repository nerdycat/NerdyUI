//
//  UISlider+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/21.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UISlider+NERChainable.h"
#import "NERUtils.h"
#import "NERPrivates.h"

@implementation UISlider (NERChainable)

- (NERChainableUISliderFloatBlock)val {
    NER_FLOAT_BLOCK(self.value = value);
}

- (NERChainableUISliderFloatBlock)minVal {
    NER_FLOAT_BLOCK(self.minimumValue = value);
}

- (NERChainableUISliderFloatBlock)maxVal {
    NER_FLOAT_BLOCK(self.maximumValue = value);
}

- (NERChainableUISliderObjectBlock)minTrack {
    NER_OBJECT_BLOCK(
                     id result = [NERUtils imageOrColorWithObject:value];
                     if ([result isKindOfClass:UIColor.class]) {
                         self.minimumTrackTintColor = result;
                     } else {
                         [self setMinimumTrackImage:result forState:UIControlStateNormal];
                     }
    );
}

- (NERChainableUISliderObjectBlock)maxTrack {
    NER_OBJECT_BLOCK(
                     id result = [NERUtils imageOrColorWithObject:value];
                     if ([result isKindOfClass:UIColor.class]) {
                         self.maximumTrackTintColor = result;
                     } else {
                         [self setMaximumTrackImage:result forState:UIControlStateNormal];
                     }
    );
}

- (NERChainableUISliderObjectBlock)thumb {
    NER_OBJECT_BLOCK(
                     id result = [NERUtils imageOrColorWithObject:value];
                     if ([result isKindOfClass:UIColor.class]) {
                         self.thumbTintColor = result;
                     } else {
                         [self setThumbImage:result forState:UIControlStateNormal];
                     }
                     );
}

- (NERChainableUISliderObjectBlock)highThumb {
    NER_OBJECT_BLOCK(
                     id result = [NERUtils imageOrColorWithObject:value];
                     if ([result isKindOfClass:UIImage.class]) {
                         [self setThumbImage:result forState:UIControlStateHighlighted];
                     }
                     );
}

- (NERChainableUISliderFloatBlock)trackHeight {
    NER_FLOAT_BLOCK(self.nerTrackHeight = @(value));
}

- (NERChainableUISliderInsetsBlock)thumbInsets {
    NER_INSETS_BLOCK(self.nerThumbInsets = value);
}

- (NERChainableUISliderCallbackBlock)onChange {
    NER_CALLBACK_BLOCK([self ner_registerOnChangeHandlerWithTarget:target object:object]);
}

- (instancetype)discrete {
    self.continuous = NO;
    return self;
}

@end
