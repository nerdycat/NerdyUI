//
//  UITextView+NERChainable.h
//  NerdyUI
//
//  Created by CAI on 10/29/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"

#define TextView    [UITextView new]

@interface UITextView (NERChainable)

/**
 * Setting text or attributedText value.
 * str use Str() internally, so it can take any kind of arguments that Str() supported.
 * Additionally it can take an NSAttributedString object.
 
 * Usages: 
    .str(100), .str(@3.14), .str(@"hello"), .str(@"%d+%d=%d", 1, 1, 1 + 1),
    .str(someAttributedString), .str(AttStr(@"hello").fnt(20).underline), etc.
 
 * See NSString+NERChainable.h and NSAttributedString+NERChainable.h for more information.
 */
NER_TV_PROP(Object)     str;

/**
 * Setting placeholder or attributedPlaceholder value.
 * Usages: .hint(@"Enter your name"), .hint(AttStr(@"Enter your name").fnt(20).underline)
 * See NSAttributedString+NERChainable.h for more information.
 */
NER_TV_PROP(Object)     hint;

/**
 * font
 * fnt use Fnt() internally, so it can take any kind of arguments that Fnt() supported.
 * Usages: .fnt(15), .fnt(@15), .fnt(@"headline"), .fnt(@"Helvetica,15"), .fnt(fontObject), etc.
 * See UIFont+NERChainable.h for more information.
 */
NER_TV_PROP(Object)     fnt;

/**
 * textColor
 * color use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .color(@"red"), .color(@"#F00"), .color(@"255,0,0"), .color(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_TV_PROP(Object)     color;

/**
 * Setting the max length that are allow to input.
 * Usages: .maxLength(20)
 */
NER_TV_PROP(Int)        maxLength;

/**
 * contentEdgeInsets for TextView.
 * Will change textContainerInset and textContainer.lineFragmentPadding internally.
 * Usages:
    .insets(10)                     top/left/bottom/right = 10
    .insets(10, 20)                 top/bottom = 10, left/right = 20
    .insets(10, 20, 30),            top = 10, left/right = 20, bottom = 30
    .insets(10, 20, 30, 40)         top = 10, left = 20, bottom = 30, right = 40
 */
NER_TV_PROP(Insets)     insets;

/**
 * Text did change callback.
 * Use UITextViewTextDidChangeNotification internally.
 * It support two kind of arguments:
 1) a callback block
 2) a target/action pair
 
 * Usages: 
    .onChange(^{}), .onChange(^(NSString *text){}), .onChange(^(NSString *text, id textView){})
    .onChange(@"textViewValueDidChange"), .onChange(@"textViewValueDidChange:")
 */
NER_TV_PROP(Callback)   onChange;


//becomeFirstResponder
- (instancetype)becomeFocus;            

//TextAlignment
- (instancetype)leftAlignment;
- (instancetype)centerAlignment;
- (instancetype)rightAlignment;
- (instancetype)justifiedAlignment;

@end
