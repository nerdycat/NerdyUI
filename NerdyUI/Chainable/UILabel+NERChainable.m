//
//  UILabel+NERChainable.m
//  NerdyUI
//
//  Created by admin on 2016/10/11.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import "UILabel+NERChainable.h"
#import "UILabel+NERLink.h"
#import "UIFont+NERChainable.h"
#import "UIColor+NERChainable.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation UILabel (NERChainable)

- (NERChainableUILabelObjectBlock)str {
    NER_OBJECT_BLOCK([NERUtils setTextWithStringObject:value forView:self]);
}

- (NERChainableUILabelObjectBlock)fnt {
    NER_OBJECT_BLOCK(self.font = Fnt(value));
}

- (NERChainableUILabelObjectBlock)color {
    NER_OBJECT_BLOCK(self.textColor = Color(value));
}

- (NERChainableUILabelObjectBlock)highColor {
    NER_OBJECT_BLOCK(self.highlightedTextColor = Color(value));
}

- (NERChainableUILabelIntBlock)lines {
//    return ^(NSInteger n) {
//        __attribute__(enable_if(n > 0 && n < 120, "你丫火星人？"));
//        return self;
//    };
    NER_INT_BLOCK(self.numberOfLines = value);
}

- (NERChainableUILabelFloatBlock)lineGap {
    NER_FLOAT_BLOCK(self.nerLineGap = value);
}

- (NERChainableUILabelFloatBlock)preferWidth {
    NER_FLOAT_BLOCK(self.preferredMaxLayoutWidth = value);
}

- (NERChainableUILabelCallbackBlock)onLink {
    NER_CALLBACK_BLOCK(
                       self.userInteractionEnabled = YES;
                       
                       if (block) {
                           self.nerLinkHandler = block;
                           
                       } else if (target && action) {
                           self.nerLinkHandler = ^(id text, NSRange range) {
                               id rangeValue = [NSValue valueWithRange:range];
                               [target performSelector:action withObject:text withObject:rangeValue];
                           };
                       }
                       );
}

- (instancetype)leftAlignment {
    self.textAlignment = NSTextAlignmentLeft;
    return self;
}

- (instancetype)centerAlignment {
    self.textAlignment = NSTextAlignmentCenter;
    return self;
}

- (instancetype)rightAlignment {
    self.textAlignment = NSTextAlignmentRight;
    return self;
}

- (instancetype)justifiedAlignment {
    self.textAlignment = NSTextAlignmentJustified;
    return self;
}

@end

