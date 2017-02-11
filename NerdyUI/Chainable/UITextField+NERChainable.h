//
//  UITextField+NERChainable.h
//  NerdyUI
//
//  Created by CAI on 10/16/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"

#define TextField   [UITextField ner_autoEnableReturnKeyTextField]

@interface UITextField (NERChainable)

/**
 * Setting text or attributedText value.
 * str use Str() internally, so it can take any kind of arguments that Str() supported.
 * Additionally it can take an NSAttributedString object.
 
 * Usages: 
    .str(100), .str(@3.14), .str(@"hello"), .str(@"%d+%d=%d", 1, 1, 1 + 1),
    .str(someAttributedString), .str(AttStr(@"hello").fnt(20).underline), etc.
 
 * See NSString+NERChainable.h and NSAttributedString+NERChainable.h for more information.
 */
NER_TF_PROP(Object)     str;

/**
 * Setting placeholder or attributedPlaceholder value.
 * Usages: .hint(@"Enter your name"), .hint(AttStr(@"Enter your name").fnt(20).underline)
 * See NSAttributedString+NERChainable.h for more information.
 */
NER_TF_PROP(Object)     hint;

/**
 * font
 * fnt use Fnt() internally, so it can take any kind of arguments that Fnt() supported.
 * Usages: .fnt(15), .fnt(@15), .fnt(@"headline"), .fnt(@"Helvetica,15"), .fnt(fontObject), etc.
 * See UIFont+NERChainable.h for more information.
 */
NER_TF_PROP(Object)     fnt;

/**
 * textColor
 * color use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .color(@"red"), .color(@"#F00"), .color(@"255,0,0"), .color(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_TF_PROP(Object)     color;

/**
 * Setting the max length that are allow to input.
 * Usages: .maxLength(20)
 */
NER_TF_PROP(Int)        maxLength;

/**
 * contentEdgeInsets for TextField.
 * Usages:
    .insets(10)                     top/left/bottom/right = 10
    .insets(10, 20)                 top/bottom = 10, left/right = 20
    .insets(10, 20, 30),            top = 10, left/right = 20, bottom = 30
    .insets(10, 20, 30, 40)         top = 10, left = 20, bottom = 30, right = 40
 */
NER_TF_PROP(Insets)     insets;

/**
 * Text did change callback.
 * Use UIControlEventEditingChanged event internally.
 * It support two kind of arguments:
    1) a callback block
    2) a selector string
 
 * Usages: 
    .onChange(^{}), .onChange(^(NSString *text){}), .onChange(^(NSString *text, UITextField *textField){})
    .onChange(@"textFieldValueDidChange"), onChange(@"textFieldValueDidChange:")
 */
NER_TF_PROP(Callback)   onChange;

/**
 * Did end entering text callback.
 * Use UIControlEventEditingDidEndOnExit event internally.
 * It support two kind of arguments:
    1) a callback block
    2) a selector string
 
 * Usages: 
    .onFinish(^{}), .onFinish(^(NSString *text){}), .onFinish(^(NSString *text, UITextField *textField){})
    .onFinish(@"textFieldDidFinishEnter"), .onFinish(@"textFieldDidFinishEnter:")
 */
NER_TF_PROP(Callback)   onFinish;


//secureTextEntry = YES
- (instancetype)secure;

//becomeFirstResponder
- (instancetype)becomeFocus;

//clearsOnBeginEditing = YES
- (instancetype)clearWhenFocus;

//UITextBorderStyleRoundedRect
- (instancetype)roundStyle;


//TextAlignment
- (instancetype)leftAlignment;
- (instancetype)centerAlignment;
- (instancetype)rightAlignment;
- (instancetype)justifiedAlignment;

//KeyboardType
- (instancetype)ASCIIKeyboard;
- (instancetype)URLKeyboard;
- (instancetype)numberKeyboard;
- (instancetype)phoneKeyboard;
- (instancetype)emailKeyboard;
- (instancetype)decimalKeyboard;
- (instancetype)twitterKeyboard;
- (instancetype)searchKeybaord;
- (instancetype)namePhoneKeyboard;
- (instancetype)numberPunctuationKeyboard;

//ReturnKeyType
- (instancetype)doneReturnKey;
- (instancetype)goReturnKey;
- (instancetype)googleReturnKey;
- (instancetype)searchReturnKey;
- (instancetype)sendReturnKey;
- (instancetype)nextRetrunKey;
- (instancetype)joinReturnKey;
- (instancetype)routeReturnKey;

//ClearButtonMode
- (instancetype)showClearButton;
- (instancetype)showClearButtonWhileEditing;
- (instancetype)showClearButtonUnlessEditing;

@end
