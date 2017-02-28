//
//  NERStyle+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 11/1/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStyle.h"
#import "NERDefs.h"


/**
 * Nearly all the chainable attributes In NerdyUI can be set in Style.
 * After creation, Styles can be apply to UIView or NSAttributedStirng.
 * Style can inherit from other styles too.
 * Style with name can be referred globally.
 
 * Example:
    Style(@"h1").color(@"#333333").fnt(17);
    Style(@"button").fixHeight(30).insets(0, 10).borderRadius(5);
    id actionStyle = Style().styles(@"button h1").bgImg(@"red").highBgImg(@"blue").highColor(@"white");
 
    id foo = Label.styles(@"h1").str(@"hello world");
    id bar = Button.styles(actionStyle).str(@"hello world");
 */
#define Style(...)                [NERStyle createStyleWithKeys:@[__VA_ARGS__]]


@interface NERStyle (NERChainable)

/**
 * Style can inherit from other styles too.
 * For multiply styles, use white space to separate them.
 * Usages: .styles(@"style1"), .styles(@"style1 style2 style3 style4"), .styles(localStyle)
 */
NER_STYLE_PROP(Object)          styles;


/**
 * UIView
 */
NER_STYLE_PROP(Int)             tg;
NER_STYLE_PROP(Float)           opacity;
NER_STYLE_PROP(Object)          tint;
NER_STYLE_PROP(Object)          bgColor;
NER_STYLE_PROP(Float)           borderRadius;
NER_STYLE_PROP(FloatObjectList) border;
NER_STYLE_PROP(FloatList)       shadow;
NER_STYLE_PROP(Rect)            xywh;
NER_STYLE_PROP(Point)           cxy;
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
- (instancetype)stateDisabled;
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



/**
 * UILabel
 */
NER_STYLE_PROP(Object)          str;
NER_STYLE_PROP(Object)          fnt;
NER_STYLE_PROP(Object)          color;
NER_STYLE_PROP(Object)          highColor;
NER_STYLE_PROP(Int)             lines;
NER_STYLE_PROP(Float)           lineGap;
NER_STYLE_PROP(Float)           preferWidth;

- (instancetype)multiline;
- (instancetype)leftAlignment;
- (instancetype)centerAlignment;
- (instancetype)rightAlignment;
- (instancetype)justifiedAlignment;



/**
 * UIImageView
 */
NER_STYLE_PROP(Object)          img;
NER_STYLE_PROP(Object)          highImg;

- (instancetype)aspectFit;
- (instancetype)aspectFill;
- (instancetype)centerMode;



/**
 * UIButton
 */
NER_STYLE_PROP(Object)          selectedColor;
NER_STYLE_PROP(Object)          disabledColor;
NER_STYLE_PROP(Object)          selectedImg;
NER_STYLE_PROP(Object)          disabledImg;
NER_STYLE_PROP(Object)          bgImg;
NER_STYLE_PROP(Object)          highBgImg;
NER_STYLE_PROP(Object)          selectedBgImg;
NER_STYLE_PROP(Object)          disabledBgImg;
NER_STYLE_PROP(Float)           gap;
NER_STYLE_PROP(Insets)          insets;

- (instancetype)reversed;
- (instancetype)adjustDisabled;



/**
 * UITextField
 */
NER_STYLE_PROP(Object)          hint;
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



/**
 * UISwitch
 */
NER_STYLE_PROP(Object)          onColor;
NER_STYLE_PROP(Object)          thumbColor;
NER_STYLE_PROP(Object)          outlineColor;



/**
 * UISlider
 */
NER_STYLE_PROP(Float)           val;
NER_STYLE_PROP(Float)           minVal;
NER_STYLE_PROP(Float)           maxVal;
NER_STYLE_PROP(Object)          minTrack;
NER_STYLE_PROP(Object)          maxTrack;
NER_STYLE_PROP(Object)          thumb;
NER_STYLE_PROP(Object)          highThumb;
NER_STYLE_PROP(Float)           trackHeight;
NER_STYLE_PROP(Insets)          thumbInsets;

- (instancetype)discrete;



/**
 * UIStepper
 */
NER_STYLE_PROP(Float)           stepVal;



/**
 * UIPageControl
 */
NER_STYLE_PROP(Int)             pages;

- (instancetype)hideForSingle;



/**
 * UIVisualEffectView
 */
- (instancetype)darkBlur;
- (instancetype)lightBlur;
- (instancetype)extraLightBlur;



/**
 * NERStack
 */
- (instancetype)topAlignment;
- (instancetype)bottomAlignment;
- (instancetype)baselineAlignment;
- (instancetype)firstBaselineAlignment;



/**
 * NERStaticRow
 */
NER_STYLE_PROP(Object)          detailStr;
NER_STYLE_PROP(Object)          detailFnt;
NER_STYLE_PROP(Object)          detailColor;
NER_STYLE_PROP(Object)          accessory;
NER_STYLE_PROP(Bool)            check;
NER_STYLE_PROP(Float)           cellHeight;
NER_STYLE_PROP(Float)           separatorLeftInset;

- (instancetype)cellHeightAuto;
- (instancetype)subtitleStyle;
- (instancetype)value2Style;
- (instancetype)disclosure;



/**
 * NERStaticSection
 */
NER_STYLE_PROP(Object)          header;
NER_STYLE_PROP(Object)          footer;

- (instancetype)singleCheck;
- (instancetype)multiCheck;



/**
 * NSMutableAttributedString
 */
NER_STYLE_PROP(Object)          systemLink;
NER_STYLE_PROP(Float)           kern;
NER_STYLE_PROP(Float)           stroke;
NER_STYLE_PROP(Float)           oblique;
NER_STYLE_PROP(Float)           expansion;
NER_STYLE_PROP(Float)           baselineOffset;
NER_STYLE_PROP(Float)           indent;
NER_STYLE_PROP(Object)          match;

- (instancetype)matchNumber;
- (instancetype)matchURL;
- (instancetype)matchHashTag;
- (instancetype)matchNameTag;
- (instancetype)underline;
- (instancetype)strikeThrough;
- (instancetype)letterpress;
- (instancetype)linkForLabel;
- (instancetype)ifNotExists;

@end







