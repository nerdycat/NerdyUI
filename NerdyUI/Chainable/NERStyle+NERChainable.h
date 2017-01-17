//
//  NERStyle+NERChainable.h
//  NerdyUI
//
//  Created by CAI on 11/1/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStyle.h"
#import "NERDefs.h"


/**
 * Nearly all the chainable attributes In NerdyUI can be set in Style.
 * After creation, Styles can be apply to UIView or NSAttributedStirng.
 * Style can inhert from other styles too.
 
 * GlobalStyle can be referred globally using style name.
 * Local style allow you to create style on the fly.
 
 * Example:
    GlobalStyle(@"buttonBase").fixHeight(40).cr(20).insets(0, 15);
    GlobalStyle(@"actionButton").styles(@"buttonBase").bgImg(@"red").highBgImg(@"blue");
    id localButtonStyle = Style.styles(@"buttonBase").bd(1).color(@"black").highColor(@"lightGray");
 
    id button1 = Button.styles(@"actionButton").str(@"Button1");
    id button2 = Button.styles(localButtonStyle).str(@"Button2");
    HStack(button1, button2).embedIn(self.view, 20, 20, NERNull, NERNull);
 */
#define GlobalStyle(name)       [NERStyle createStyleWithKey:name]
#define Style                   [NERStyle createStyleWithKey:nil]


@interface NERStyle (NERChainable)

/**
 * Style can inherit from other styles too.
 * For multiply styles, use white space to separate them.
 * Usages: .styles(@"style1"), .styles(@"style1 style2 style3 style4"), .styles(localStyle)
 */
NER_STYLE_PROP(Object)          styles;


NER_STYLE_PROP(Int)             tg;
NER_STYLE_PROP(Float)           opacity;
NER_STYLE_PROP(Object)          bgColor;
NER_STYLE_PROP(Float)           cr;
NER_STYLE_PROP(FloatObjectList) bd;
NER_STYLE_PROP(FloatList)       sd;

NER_STYLE_PROP(Point)           xy;
NER_STYLE_PROP(Size)            wh;
NER_STYLE_PROP(Rect)            xywh;
NER_STYLE_PROP(Point)           cxy;
NER_STYLE_PROP(Point)           maxXY;

NER_STYLE_PROP(Float)           horHugging;
NER_STYLE_PROP(Float)           verHugging;
NER_STYLE_PROP(Float)           horResistance;
NER_STYLE_PROP(Float)           verResistance;
NER_STYLE_PROP(Float)           fixWidth;
NER_STYLE_PROP(Float)           fixHeight;
NER_STYLE_PROP(Size)            fixWH;

- (instancetype)clip;
- (instancetype)touchEnable;
- (instancetype)touchDisable;
- (instancetype)invisible;

- (instancetype)fitWidth;
- (instancetype)fitHeight;
- (instancetype)fitSize;

- (instancetype)flexibleLeft;
- (instancetype)flexibleRight;
- (instancetype)flexibleTop;
- (instancetype)flexibleBottom;
- (instancetype)flexibleLR;
- (instancetype)flexibleTB;
- (instancetype)flexibleLRTB;

- (instancetype)flexibleWidth;
- (instancetype)flexibleHeight;
- (instancetype)flexibleWH;

- (instancetype)lowHugging;
- (instancetype)highHugging;
- (instancetype)lowResistance;
- (instancetype)highResistance;




NER_STYLE_PROP(Object)          str;
NER_STYLE_PROP(Object)          fnt;
NER_STYLE_PROP(Object)          color;
NER_STYLE_PROP(Object)          highColor;

NER_STYLE_PROP(Int)             lines;
NER_STYLE_PROP(Float)           preferWidth;

- (instancetype)leftAlignment;
- (instancetype)centerAlignment;
- (instancetype)rightAlignment;
- (instancetype)justifiedAlignment;




NER_STYLE_PROP(Object)          img;
NER_STYLE_PROP(Object)          highImg;

- (instancetype)aspectFit;
- (instancetype)aspectFill;
- (instancetype)centerMode;




NER_STYLE_PROP(Object)          selectedImg;
NER_STYLE_PROP(Object)          disabledImg;
NER_STYLE_PROP(Object)          bgImg;
NER_STYLE_PROP(Object)          highBgImg;
NER_STYLE_PROP(Object)          selectedBgImg;
NER_STYLE_PROP(Object)          disabledBgImg;

NER_STYLE_PROP(Insets)          insets;




NER_STYLE_PROP(Object)          pstr;
NER_STYLE_PROP(Int)             maxLength;

- (instancetype)secure;               
- (instancetype)becomeFocus;         
- (instancetype)clearWhenFocus;     
- (instancetype)roundStyle;        

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

- (instancetype)doneReturnKey;
- (instancetype)goReturnKey;
- (instancetype)googleReturnKey;
- (instancetype)searchReturnKey;
- (instancetype)sendReturnKey;
- (instancetype)nextRetrunKey;
- (instancetype)joinReturnKey;
- (instancetype)routeReturnKey;

- (instancetype)showClearButton;
- (instancetype)showClearButtonWhileEditing;
- (instancetype)showClearButtonUnlessEditing;




NER_STYLE_PROP(Float)           gap;

- (instancetype)topAlignment;
- (instancetype)bottomAlignment;
- (instancetype)baselineAlignment;
- (instancetype)firstBaselineAlignment;




NER_STYLE_PROP(Object)          tint;
NER_STYLE_PROP(Object)          detailStr;
NER_STYLE_PROP(Object)          detailFnt;
NER_STYLE_PROP(Object)          detailColor;
NER_STYLE_PROP(Float)           cellHeight;
NER_STYLE_PROP(Float)           separatorInset;
NER_STYLE_PROP(Float)           groupGap;
NER_STYLE_PROP(Bool)            checked;

- (instancetype)subtitleStyle;
- (instancetype)value2Style;
- (instancetype)disclosure;




NER_STYLE_PROP(Object)          systemLink;
NER_STYLE_PROP(Object)          match;
NER_STYLE_PROP(Float)           kern;
NER_STYLE_PROP(Float)           stroke;
NER_STYLE_PROP(Float)           oblique;
NER_STYLE_PROP(Float)           expansion;
NER_STYLE_PROP(Float)           baselineOffset;
NER_STYLE_PROP(Float)           lineSpacing;

- (instancetype)matchURL;
- (instancetype)matchHashTag;
- (instancetype)matchNameTag;
- (instancetype)underline;
- (instancetype)strikeThrough;
- (instancetype)letterpress;
- (instancetype)linkForLabel;

@end







