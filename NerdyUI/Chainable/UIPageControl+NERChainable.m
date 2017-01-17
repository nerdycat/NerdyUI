//
//  UIPageControl+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/20.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UIPageControl+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "NERPrivates.h"
#import "NERUtils.h"

@implementation UIPageControl (NERChainable)

- (NERChainableUIPageControlIntBlock)pages {
    NER_INT_BLOCK(
                  self.numberOfPages = value;
                  if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
                      [self sizeToFit];
                  }
                  );
}

- (NERChainableUIPageControlObjectBlock)color {
    NER_OBJECT_BLOCK(self.pageIndicatorTintColor = Color(value));
}

- (NERChainableUIPageControlObjectBlock)highColor {
    NER_OBJECT_BLOCK(self.currentPageIndicatorTintColor = Color(value));
}

- (NERChainableUIPageControlCallbackBlock)onChange {
    NER_CALLBACK_BLOCK(return [self ner_registerOnChangeHandlerWithTarget:target object:object];);
}

- (instancetype)hideForSingle {
    self.hidesForSinglePage = YES;
    return self;
}

@end
