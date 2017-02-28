//
//  NERStyle+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 11/1/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStyle+NERChainable.h"
#import "NERUtils.h"
#import "UIColor+NERChainable.h"
#import "UIFont+NERChainable.h"

#define SYNTHSIZE_METHOD(name) \
- (instancetype)name {\
    [self addMethodWithName:@#name];\
    return self;\
}

#define SYNTHSIZE_PRIMITIVE_METHOD(type1, type2, name) \
- (NERChainableNERStyle##type1##Block)name {\
    NER_##type2##_BLOCK([self set##type1##Value:value forKey:@#name]);\
}

#define SYNTHSIZE_STRUCT_METHOD(type1, type2, name) \
- (NERChainableNERStyle##type1##Block)name {\
NER_##type2##_BLOCK([self set##type1##Value:value.value forKey:@#name]);\
}

#define SYNTHSIE_FLOAT_LIST_METHOD(name) \
- (NERChainableNERStyleFloatListBlock)name {\
    NER_FLOAT_LIST_BLOCK([self setFloatListValue:value forKey:@#name]);\
}

#define SYNTHSIZE_OBJECT_METHOD(name)       SYNTHSIZE_PRIMITIVE_METHOD(Object, OBJECT, name)
#define SYNTHSIZE_INT_METHOD(name)          SYNTHSIZE_PRIMITIVE_METHOD(Int, INT, name)
#define SYNTHSIZE_FLOAT_METHOD(name)        SYNTHSIZE_PRIMITIVE_METHOD(Float, FLOAT, name)
#define SYNTHSIZE_POINT_METHOD(name)        SYNTHSIZE_STRUCT_METHOD(Point, POINT, name)
#define SYNTHSIZE_SIZE_METHOD(name)         SYNTHSIZE_STRUCT_METHOD(Size, SIZE, name)
#define SYNTHSIZE_RECT_METHOD(name)         SYNTHSIZE_STRUCT_METHOD(Rect, RECT, name)


@implementation NERStyle (NERChainable)

- (NERChainableNERStyleObjectBlock)styles {
    NER_OBJECT_BLOCK([NERUtils applyStyleObject:value toItem:self];);
}

- (NERChainableNERStyleFloatObjectListBlock)border {
    NER_FLOAT_OBJECT_LIST_BLOCK(
                                [self setObjectValue:@(value) forKey:@"layer.borderWidth"];
                                if (arguments.firstObject) {
                                    [self setObjectValue:(id)Color(arguments.firstObject).CGColor forKey:@"layer.borderColor"];
                                }
                                );
}

- (NERChainableNERStyleObjectBlock)fnt {
    NER_OBJECT_BLOCK([self setObjectValue:Fnt(value) forKey:@"fnt"]);
}

- (NERChainableNERStyleObjectBlock)detailFnt {
    NER_OBJECT_BLOCK([self setObjectValue:Fnt(value) forKey:@"detailFnt"]);
}

- (NERChainableNERStyleInsetsBlock)insets {
    NER_INSETS_BLOCK([self setObjectValue:[NSValue valueWithUIEdgeInsets:value] forKey:@"insets"]);
}

- (NERChainableNERStyleInsetsBlock)thumbInsets {
    NER_INSETS_BLOCK([self setObjectValue:[NSValue valueWithUIEdgeInsets:value] forKey:@"thumbInsets"]);
}



SYNTHSIZE_INT_METHOD(tg);
SYNTHSIZE_FLOAT_METHOD(opacity);
SYNTHSIZE_FLOAT_METHOD(borderRadius);
SYNTHSIE_FLOAT_LIST_METHOD(shadow);
SYNTHSIZE_OBJECT_METHOD(tint);
SYNTHSIZE_OBJECT_METHOD(bgColor);
SYNTHSIZE_POINT_METHOD(xy);
SYNTHSIZE_SIZE_METHOD(wh);
SYNTHSIZE_RECT_METHOD(xywh);
SYNTHSIZE_POINT_METHOD(cxy);
SYNTHSIZE_POINT_METHOD(maxXY);
SYNTHSIZE_FLOAT_METHOD(horHugging);
SYNTHSIZE_FLOAT_METHOD(verHugging);
SYNTHSIZE_FLOAT_METHOD(horResistance);
SYNTHSIZE_FLOAT_METHOD(verResistance);
SYNTHSIZE_FLOAT_METHOD(fixWidth);
SYNTHSIZE_FLOAT_METHOD(fixHeight);
SYNTHSIZE_SIZE_METHOD(fixWH);
SYNTHSIZE_METHOD(clip);
SYNTHSIZE_METHOD(touchEnable);
SYNTHSIZE_METHOD(touchDisable);
SYNTHSIZE_METHOD(stateDisabled);
SYNTHSIZE_METHOD(invisible);
SYNTHSIZE_METHOD(fitWidth);
SYNTHSIZE_METHOD(fitHeight);
SYNTHSIZE_METHOD(fitSize);
SYNTHSIZE_METHOD(flexibleLeft);
SYNTHSIZE_METHOD(flexibleRight);
SYNTHSIZE_METHOD(flexibleTop);
SYNTHSIZE_METHOD(flexibleBottom);
SYNTHSIZE_METHOD(flexibleLR);
SYNTHSIZE_METHOD(flexibleTB);
SYNTHSIZE_METHOD(flexibleLRTB);
SYNTHSIZE_METHOD(flexibleWidth);
SYNTHSIZE_METHOD(flexibleHeight);
SYNTHSIZE_METHOD(flexibleWH);
SYNTHSIZE_METHOD(lowHugging);
SYNTHSIZE_METHOD(highHugging);
SYNTHSIZE_METHOD(lowResistance);
SYNTHSIZE_METHOD(highResistance);



/**
 UILabel
 */
SYNTHSIZE_OBJECT_METHOD(str);
SYNTHSIZE_OBJECT_METHOD(color);
SYNTHSIZE_OBJECT_METHOD(highColor);
SYNTHSIZE_INT_METHOD(lines);
SYNTHSIZE_FLOAT_METHOD(lineGap);
SYNTHSIZE_FLOAT_METHOD(preferWidth);
SYNTHSIZE_METHOD(multiline);
SYNTHSIZE_METHOD(leftAlignment);
SYNTHSIZE_METHOD(centerAlignment);
SYNTHSIZE_METHOD(rightAlignment);
SYNTHSIZE_METHOD(justifiedAlignment);



/**
 * UIImageView
 */
SYNTHSIZE_OBJECT_METHOD(img);
SYNTHSIZE_OBJECT_METHOD(highImg);
SYNTHSIZE_METHOD(aspectFit);
SYNTHSIZE_METHOD(aspectFill);
SYNTHSIZE_METHOD(centerMode);



/**
 * UIButton
 */
SYNTHSIZE_OBJECT_METHOD(selectedColor);
SYNTHSIZE_OBJECT_METHOD(disabledColor);
SYNTHSIZE_OBJECT_METHOD(selectedImg);
SYNTHSIZE_OBJECT_METHOD(disabledImg);
SYNTHSIZE_OBJECT_METHOD(bgImg);
SYNTHSIZE_OBJECT_METHOD(highBgImg);
SYNTHSIZE_OBJECT_METHOD(selectedBgImg);
SYNTHSIZE_OBJECT_METHOD(disabledBgImg);
SYNTHSIZE_FLOAT_METHOD(gap);
SYNTHSIZE_METHOD(reversed);
SYNTHSIZE_METHOD(adjustDisabled);


/**
 * UITextField
 */
SYNTHSIZE_OBJECT_METHOD(hint);
SYNTHSIZE_INT_METHOD(maxLength);
SYNTHSIZE_METHOD(secure);
SYNTHSIZE_METHOD(becomeFocus);
SYNTHSIZE_METHOD(clearWhenFocus);
SYNTHSIZE_METHOD(roundStyle);
SYNTHSIZE_METHOD(ASCIIKeyboard);
SYNTHSIZE_METHOD(URLKeyboard);
SYNTHSIZE_METHOD(numberKeyboard);
SYNTHSIZE_METHOD(phoneKeyboard);
SYNTHSIZE_METHOD(emailKeyboard);
SYNTHSIZE_METHOD(decimalKeyboard);
SYNTHSIZE_METHOD(twitterKeyboard);
SYNTHSIZE_METHOD(searchKeybaord);
SYNTHSIZE_METHOD(namePhoneKeyboard);
SYNTHSIZE_METHOD(numberPunctuationKeyboard);
SYNTHSIZE_METHOD(doneReturnKey);
SYNTHSIZE_METHOD(goReturnKey);
SYNTHSIZE_METHOD(googleReturnKey);
SYNTHSIZE_METHOD(searchReturnKey);
SYNTHSIZE_METHOD(sendReturnKey);
SYNTHSIZE_METHOD(nextRetrunKey);
SYNTHSIZE_METHOD(joinReturnKey);
SYNTHSIZE_METHOD(routeReturnKey);
SYNTHSIZE_METHOD(showClearButton);
SYNTHSIZE_METHOD(showClearButtonWhileEditing);
SYNTHSIZE_METHOD(showClearButtonUnlessEditing);
SYNTHSIZE_METHOD(topAlignment);
SYNTHSIZE_METHOD(bottomAlignment);
SYNTHSIZE_METHOD(baselineAlignment);
SYNTHSIZE_METHOD(firstBaselineAlignment);



/**
 * UISwitch
 */
SYNTHSIZE_OBJECT_METHOD(onColor);
SYNTHSIZE_OBJECT_METHOD(thumbColor);
SYNTHSIZE_OBJECT_METHOD(outlineColor);



/**
 * UISlider
 */
SYNTHSIZE_FLOAT_METHOD(val);
SYNTHSIZE_FLOAT_METHOD(minVal);
SYNTHSIZE_FLOAT_METHOD(maxVal);
SYNTHSIZE_OBJECT_METHOD(minTrack);
SYNTHSIZE_OBJECT_METHOD(maxTrack);
SYNTHSIZE_OBJECT_METHOD(thumb);
SYNTHSIZE_OBJECT_METHOD(highThumb);
SYNTHSIZE_FLOAT_METHOD(trackHeight);
SYNTHSIZE_METHOD(discrete);



/**
 * UIStepper
 */
SYNTHSIZE_FLOAT_METHOD(stepVal);



/**
 * UIPageControl
 */
SYNTHSIZE_INT_METHOD(pages);
SYNTHSIZE_METHOD(hideForSingle);



/**
 * UIVisualEffectView
 */
SYNTHSIZE_METHOD(darkBlur);
SYNTHSIZE_METHOD(lightBlur);
SYNTHSIZE_METHOD(extraLightBlur);



/**
 * NERStaticRow
 */
SYNTHSIZE_OBJECT_METHOD(detailStr);
SYNTHSIZE_OBJECT_METHOD(detailColor);
SYNTHSIZE_OBJECT_METHOD(accessory);
SYNTHSIZE_INT_METHOD(check);
SYNTHSIZE_FLOAT_METHOD(cellHeight);
SYNTHSIZE_FLOAT_METHOD(separatorLeftInset);
SYNTHSIZE_FLOAT_METHOD(groupGap);
SYNTHSIZE_INT_METHOD(checked);

SYNTHSIZE_METHOD(cellHeightAuto);
SYNTHSIZE_METHOD(subtitleStyle);
SYNTHSIZE_METHOD(value2Style);
SYNTHSIZE_METHOD(disclosure);



/**
 * NERStaticSection
 */
SYNTHSIZE_OBJECT_METHOD(header);
SYNTHSIZE_OBJECT_METHOD(footer);
SYNTHSIZE_METHOD(singleCheck);
SYNTHSIZE_METHOD(multiCheck);



/**
 * NSMutableAttributedString
 */
SYNTHSIZE_OBJECT_METHOD(systemLink);
SYNTHSIZE_FLOAT_METHOD(kern);
SYNTHSIZE_FLOAT_METHOD(stroke);
SYNTHSIZE_FLOAT_METHOD(oblique);
SYNTHSIZE_FLOAT_METHOD(expansion);
SYNTHSIZE_FLOAT_METHOD(baselineOffset);
SYNTHSIZE_FLOAT_METHOD(indent);
SYNTHSIZE_OBJECT_METHOD(match);

SYNTHSIZE_METHOD(matchNumber);
SYNTHSIZE_METHOD(matchURL);
SYNTHSIZE_METHOD(matchHashTag);
SYNTHSIZE_METHOD(matchNameTag);
SYNTHSIZE_METHOD(underline);
SYNTHSIZE_METHOD(strikeThrough);
SYNTHSIZE_METHOD(letterpress);
SYNTHSIZE_METHOD(linkForLabel);
SYNTHSIZE_METHOD(ifNotExists);

@end



