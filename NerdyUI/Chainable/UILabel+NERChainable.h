//
//  UILabel+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/10/11.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"

#define Label   [UILabel new]

@interface UILabel (NERChainable)

/**
 * Setting text or attributedText value.
 * str use Str() internally, so it can take any kind of arguments that Str() supported.
 * Additionally it can take an NSAttributedString object.
 
 * Usages: 
    .str(100), .str(@3.14), .str(@"hello"), .str(@"%d+%d=%d", 1, 1, 1 + 1),
    .str(someAttributedString), .str(AttStr(@"hello").fnt(20).underline), etc.
 
 * See NSString+NERChainable.h and NSAttributedString+NERChainable.h for more information.
 */
NER_LABEL_PROP(Object)      str;

/**
 * font
 * fnt use Fnt() internally, so it can take any kind of arguments that Fnt() supported.
 * Usages: .fnt(15), .fnt(@15), .fnt(@"headline"), .fnt(@"Helvetica,15"), .fnt(fontObject), etc.
 * See UIFont+NERChainable.h for more information.
 */
NER_LABEL_PROP(Object)      fnt;

/**
 * textColor
 * color use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .color(@"red"), .color(@"#F00"), .color(@"255,0,0"), .color(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_LABEL_PROP(Object)      color;

/**
 * highlightedTextColor
 * highColor use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .highColor(@"red"), .highColor(@"#F00"), .highColor(@"255,0,0"), .highColor(colorObject), etc.
 * See UIColor+NERChainable.h for more information.
 */
NER_LABEL_PROP(Object)      highColor;

/**
 * numberOfLines
 * Usages: .lines(0)
 */
NER_LABEL_PROP(Int)         lines;

/**
 * lineSpacing
 * Usages: .lineGap(5)
 */
NER_LABEL_PROP(Float)       lineGap;

/**
 * preferredMaxLayoutWidth
 * Usages: .preferWidth(300)
 */
NER_LABEL_PROP(Float)       preferWidth;

/**
 * Add Link selection handler.
 * It support two kind of arguments:
   1) a callback block
   2) a selector string
 
 * Usages:
    .onLink(^{});
    .onLink(^(id text) {});
    .onLink(^(id text, NSRange range) {});
    .onLink(@"onLink"), .onLink(@"onLink:"), .onLink(@"onLink:range:")
 
 * Link example:
    id att = AttStr(@"hello world").match(@"hello").linkForLabel;
    Label.str(att).embedIn(self.view).onLink(^(id text) {
        Log(text);
    });
 
 * See NSAttributedString+NERChainable.h for more information on how to create Link AttributedString for UILabel.
 */
NER_LABEL_PROP(Callback)    onLink;


/**
 * Enable multiline, same as .lines(0)
 * Usages: .multiline
 */
- (instancetype)multiline;

/**
 * TextAlignment
 * Usages: .centerAlignment
 */
- (instancetype)leftAlignment;
- (instancetype)centerAlignment;
- (instancetype)rightAlignment;
- (instancetype)justifiedAlignment;

@end
