//
//  UITextView+NERChainable.m
//  NerdyUI
//
//  Created by CAI on 10/29/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UITextView+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "UIFont+NERChainable.h"
#import "NERPrivates.h"
#import "NERUtils.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation UITextView (NERChainable)

- (NERChainableUITextViewObjectBlock)str {
    NER_OBJECT_BLOCK([NERUtils setTextWithStringObject:value forView:self]);
}

- (NERChainableUITextViewObjectBlock)hint {
    NER_OBJECT_BLOCK([self ner_setPlaceholderText:value]);
}

- (NERChainableUITextViewObjectBlock)fnt {
    NER_OBJECT_BLOCK(self.font = Fnt(value));
}

- (NERChainableUITextViewObjectBlock)color {
    NER_OBJECT_BLOCK(self.textColor = Color(value));
}

- (NERChainableUITextViewInsetsBlock)insets {
    NER_INSETS_BLOCK(
                    self.textContainer.lineFragmentPadding = 0;
                    self.textContainerInset = value;
                     );
}

- (NERChainableUITextViewIntBlock)maxLength {
    NER_INT_BLOCK(self.nerMaxLength = value);
}

- (NERChainableUITextViewCallbackBlock)onChange {
    NER_CALLBACK_BLOCK(
                       if (NER_IS_BLOCK(object)) {
                           self.nerTextChangeBlock = object;
                       } else {
                           self.nerTextChangeBlock = ^(id text) {
                               SEL action = NSSelectorFromString(object);
                               [weakTarget performSelector:action withObject:weakSelf];
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

- (instancetype)becomeFocus {
    [self becomeFirstResponder];
    return self;
}

@end
