//
//  UIPageControl+NERChainable.m
//  NerdyUI
//
//  Created by admin on 2016/12/20.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import "UIPageControl+NERChainable.h"
#import "NerdyUI.h"

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
    NER_CALLBACK_BLOCK(return [self ner_registerOnChangeHandlerWithBlock:block target:target action:action];);
}

- (instancetype)hideForSingle {
    self.hidesForSinglePage = YES;
    return self;
}

@end
