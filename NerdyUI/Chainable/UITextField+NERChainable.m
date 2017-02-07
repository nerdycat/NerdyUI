//
//  UITextField+NERChainable.m
//  NerdyUI
//
//  Created by CAI on 10/16/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "UITextField+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "UIFont+NERChainable.h"
#import "NERPrivates.h"
#import "NERUtils.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation UITextField (NERChainable)

- (NERChainableUITextFieldObjectBlock)str {
    NER_OBJECT_BLOCK([NERUtils setTextWithStringObject:value forView:self]);
}

- (NERChainableUITextFieldObjectBlock)hint {
    NER_OBJECT_BLOCK([NERUtils setPlaceholderWithStringObject:value forView:self]);
}

- (NERChainableUITextFieldObjectBlock)fnt {
    NER_OBJECT_BLOCK(self.font = Fnt(value));
}

- (NERChainableUITextFieldObjectBlock)color {
    NER_OBJECT_BLOCK(self.textColor = Color(value));
}

- (NERChainableUITextFieldIntBlock)maxLength {
    NER_INT_BLOCK(self.nerMaxLength = value);
}

- (NERChainableUITextFieldInsetsBlock)insets {
    NER_INSETS_BLOCK(self.nerContentEdgeInsets = value);
}

- (NERChainableUITextFieldCallbackBlock)onChange {
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

- (NERChainableUITextFieldCallbackBlock)onFinish {
    NER_CALLBACK_BLOCK(
                       if (NER_IS_BLOCK(object)) {
                           self.nerEndOnExitBlock = object;
                       } else {
                           self.nerEndOnExitBlock = ^(id text) {
                               SEL action = NSSelectorFromString(object);
                               [weakTarget performSelector:action withObject:weakSelf];
                           };
                       }
    );
}

- (instancetype)secure {
    self.secureTextEntry = YES;
    return self;
}

- (instancetype)becomeFocus {
    [self becomeFirstResponder];
    return self;
}

- (instancetype)clearWhenFocus {
    self.clearsOnBeginEditing = YES;
    return self;
}

- (instancetype)roundStyle {
    self.borderStyle = UITextBorderStyleRoundedRect;
    return self;
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

- (instancetype)ASCIIKeyboard {
    self.keyboardType = UIKeyboardTypeASCIICapable;
    return self;
}

- (instancetype)URLKeyboard {
    self.keyboardType = UIKeyboardTypeURL;
    return self;
}

- (instancetype)numberKeyboard {
    self.keyboardType = UIKeyboardTypeNumberPad;
    return self;
}

- (instancetype)phoneKeyboard {
    self.keyboardType = UIKeyboardTypePhonePad;
    return self;
}

- (instancetype)emailKeyboard {
    self.keyboardType = UIKeyboardTypeEmailAddress;
    return self;
}

- (instancetype)decimalKeyboard {
    self.keyboardType = UIKeyboardTypeDecimalPad;
    return self;
}

-(instancetype)twitterKeyboard {
    self.keyboardType = UIKeyboardTypeTwitter;
    return self;
}

- (instancetype)searchKeybaord {
    self.keyboardType = UIKeyboardTypeWebSearch;
    return self;
}

- (instancetype)namePhoneKeyboard {
    self.keyboardType = UIKeyboardTypeNamePhonePad;
    return self;
}

- (instancetype)numberPunctuationKeyboard {
    self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    return self;
}

- (instancetype)goReturnKey {
    self.returnKeyType = UIReturnKeyGo;
    return self;
}

- (instancetype)googleReturnKey {
    self.returnKeyType = UIReturnKeyGoogle;
    return self;
}

- (instancetype)searchReturnKey {
    self.returnKeyType = UIReturnKeySearch;
    return self;
}

- (instancetype)sendReturnKey {
    self.returnKeyType = UIReturnKeySend;
    return self;
}

- (instancetype)doneReturnKey {
    self.returnKeyType = UIReturnKeyDone;
    return self;
}

- (instancetype)nextRetrunKey {
    self.returnKeyType = UIReturnKeyNext;
    return self;
}

- (instancetype)joinReturnKey {
    self.returnKeyType = UIReturnKeyJoin;
    return self;
}

- (instancetype)routeReturnKey {
    self.returnKeyType = UIReturnKeyRoute;
    return self;
}

- (instancetype)showClearButton {
    self.clearButtonMode = UITextFieldViewModeAlways;
    return self;
}

- (instancetype)showClearButtonWhileEditing {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    return self;
}

- (instancetype)showClearButtonUnlessEditing {
    self.clearButtonMode = UITextFieldViewModeUnlessEditing;
    return self;
}

@end
