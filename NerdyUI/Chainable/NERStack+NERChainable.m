//
//  NERStack+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/11/4.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStack+NERChainable.h"

@implementation NERStack (NERChainable)


- (NERChainableNERStackFloatBlock)gap {
    NER_FLOAT_BLOCK(self.spacing = value);
}

- (instancetype)topAlignment {
    self.alignment = NERStackAlignmentTop;
    return self;
}

- (instancetype)leftAlignment {
    self.alignment = NERStackAlignmentLeading;
    return self;
}

- (instancetype)centerAlignment {
    self.alignment = NERStackAlignmentCenter;
    return self;
}

- (instancetype)bottomAlignment {
    self.alignment = NERStackAlignmentBotttom;
    return self;
}

- (instancetype)rightAlignment {
    self.alignment = NERStackAlignmentTrailing;
    return self;
}

- (instancetype)baselineAlignment {
    self.alignment = NERStackAlignmentBaseline;
    return self;
}

- (instancetype)firstBaselineAlignment {
    self.alignment = NERStackAlignmentFirstBaseline;
    return self;
}

@end
