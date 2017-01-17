//
//  UIVisualEffectView+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/30.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UIVisualEffectView+NERChainable.h"
#import "NERPrivates.h"

@implementation UIVisualEffectView (NERChainable)

- (instancetype)darkBlur {
    self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    return self;
}

- (instancetype)lightBlur {
    self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    return self;
}

- (instancetype)extraLightBlur {
    self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    return self;
}

- (NERChainableUIVisualEffectViewObjectBlock)addVibrancyChild {
    NER_OBJECT_BLOCK([self ner_addVibrancyChild:value]);
}

@end
