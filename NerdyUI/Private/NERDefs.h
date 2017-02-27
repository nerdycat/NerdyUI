//
//  NERDefs.h
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <objc/objc.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

/*
 typedef
 */
typedef struct NERRect {
    CGRect value;
} NERRect;

typedef struct NERPoint {
    CGPoint value;
} NERPoint;

typedef struct NERSize {
    CGSize value;
} NERSize;

typedef struct NEREdgeInsets {
    UIEdgeInsets value;
} NEREdgeInsets;

typedef struct NERRange {
    NSRange value;
} NERRange;

//typedef struct NERCallback {
//    void *targetOrBlock;
//    SEL action;
//} NERCallback;

typedef struct NERFloatList {
    CGFloat f1, f2, f3, f4, f5, f6, f7, f8, f9, f10;
    CGFloat validCount;
} NERFloatList;

#define NER_MAKE_FLOAT_LIST(...)    ({NERFloatList floatList = (NERFloatList){__VA_ARGS__}; \
                                    floatList.validCount = MIN(10, NER_NUMBER_OF_VA_ARGS(__VA_ARGS__)); \
                                    floatList;})


typedef void (^NERSimpleBlock)();
typedef void (^NERObjectBlock)(id);


#define NERNull             NSIntegerMax

#define Exp(x)              ({x;})


@class NERConstraint;
@class NERAlertMaker;
@class NERStack;
@class NERStyle;
@class NERStaticRow;
@class NERStaticSection;
@class NERStaticTableView;

/*
 Chainable properties
 */

#define NER_READONLY                @property (nonatomic, readonly)

#define NER_PROP(x,y)               NER_READONLY NERChainable##x##y##Block
#define NER_CHAINABLE_TYPE(v, t)    typedef v *(^NERChainable##v##t##Block)

#define NER_LABEL_PROP(y)           NER_PROP(UILabel, y)
#define NER_BUTTON_PROP(y)          NER_PROP(UIButton, y)
#define NER_IV_PROP(y)              NER_PROP(UIImageView, y)
#define NER_TF_PROP(y)              NER_PROP(UITextField, y)
#define NER_TV_PROP(y)              NER_PROP(UITextView, y)
#define NER_SWITCH_PROP(y)          NER_PROP(UISwitch, y)
#define NER_PC_PROP(y)              NER_PROP(UIPageControl, y)
#define NER_SLIDER_PROP(y)          NER_PROP(UISlider, y)
#define NER_STEPPER_PROP(y)         NER_PROP(UIStepper, y)
#define NER_SEGMENTED_PROP(y)       NER_PROP(UISegmentedControl, y)
#define NER_EFFECT_PROP(y)          NER_PROP(UIVisualEffectView, y)
#define NER_IMG_PROP(y)             NER_PROP(UIImage, y)
#define NER_COLOR_PROP(y)           NER_PROP(UIColor, y)
#define NER_STRING_PROP(y)          NER_PROP(NSString, y)
#define NER_ATT_PROP(y)             NER_PROP(NSMutableAttributedString, y)
#define NER_CONSTRAINT_PROP(y)      NER_PROP(NERConstraint, y)
#define NER_ALERT_PROP(y)           NER_PROP(NERAlertMaker, y)
#define NER_STACK_PROP(y)           NER_PROP(NERStack, y)
#define NER_STYLE_PROP(y)           NER_PROP(NERStyle, y)
#define NER_STATIC_PROP(y)          NER_PROP(NERStaticTableView, y)
#define NER_SECTION_PROP(y)         NER_PROP(NERStaticSection, y)
#define NER_ROW_PROP(y)             NER_PROP(NERStaticRow, y)

/*
 Chainable types
 */

#define NER_GENERATE_CHAINABLE_TYPES(x) \
NER_CHAINABLE_TYPE(x, Empty)();\
NER_CHAINABLE_TYPE(x, Object)(id);\
NER_CHAINABLE_TYPE(x, TwoObject)(id, id);\
NER_CHAINABLE_TYPE(x, ObjectList)(id, ...);\
NER_CHAINABLE_TYPE(x, Bool)(NSInteger);\
NER_CHAINABLE_TYPE(x, Int)(NSInteger);\
NER_CHAINABLE_TYPE(x, TwoInt)(NSInteger, NSInteger);\
NER_CHAINABLE_TYPE(x, IntOrObject)(id);\
NER_CHAINABLE_TYPE(x, Float)(CGFloat);\
NER_CHAINABLE_TYPE(x, TwoFloat)(CGFloat, CGFloat);\
NER_CHAINABLE_TYPE(x, FourFloat)(CGFloat, CGFloat, CGFloat, CGFloat);\
NER_CHAINABLE_TYPE(x, FloatList)(NERFloatList);\
NER_CHAINABLE_TYPE(x, FloatObjectList)(CGFloat, ...);\
NER_CHAINABLE_TYPE(x, Rect)(NERRect);\
NER_CHAINABLE_TYPE(x, Size)(NERSize);\
NER_CHAINABLE_TYPE(x, Point)(NERPoint);\
NER_CHAINABLE_TYPE(x, Range)(NERRange);\
NER_CHAINABLE_TYPE(x, Insets)(UIEdgeInsets);\
NER_CHAINABLE_TYPE(x, Embed)(id, UIEdgeInsets);\
NER_CHAINABLE_TYPE(x, Callback)(id, id);\
NER_CHAINABLE_TYPE(x, Block)(id);

NER_GENERATE_CHAINABLE_TYPES(UIView);
NER_GENERATE_CHAINABLE_TYPES(UILabel);
NER_GENERATE_CHAINABLE_TYPES(UIImageView);
NER_GENERATE_CHAINABLE_TYPES(UIButton);
NER_GENERATE_CHAINABLE_TYPES(UITextField);
NER_GENERATE_CHAINABLE_TYPES(UITextView);
NER_GENERATE_CHAINABLE_TYPES(UISwitch);
NER_GENERATE_CHAINABLE_TYPES(UIPageControl);
NER_GENERATE_CHAINABLE_TYPES(UISlider);
NER_GENERATE_CHAINABLE_TYPES(UIStepper);
NER_GENERATE_CHAINABLE_TYPES(UISegmentedControl);
NER_GENERATE_CHAINABLE_TYPES(UIVisualEffectView);
NER_GENERATE_CHAINABLE_TYPES(UIImage);
NER_GENERATE_CHAINABLE_TYPES(UIColor);
NER_GENERATE_CHAINABLE_TYPES(NSString);
NER_GENERATE_CHAINABLE_TYPES(NSMutableAttributedString);
NER_GENERATE_CHAINABLE_TYPES(NERConstraint);
NER_GENERATE_CHAINABLE_TYPES(NERAlertMaker);
NER_GENERATE_CHAINABLE_TYPES(NERStack);
NER_GENERATE_CHAINABLE_TYPES(NERStyle);
NER_GENERATE_CHAINABLE_TYPES(NERStaticTableView);
NER_GENERATE_CHAINABLE_TYPES(NERStaticRow);
NER_GENERATE_CHAINABLE_TYPES(NERStaticSection);


#define NER_CHAINABLE_BLOCK(x, ...) return ^(x value) {__VA_ARGS__; return self;}
#define NER_EMPTY_BLOCK(...)        return ^{__VA_ARGS__; return self;}
#define NER_OBJECT_BLOCK(...)       NER_CHAINABLE_BLOCK(id, __VA_ARGS__)
#define NER_INT_BLOCK(...)          NER_CHAINABLE_BLOCK(NSInteger, __VA_ARGS__)
#define NER_FLOAT_BLOCK(...)        NER_CHAINABLE_BLOCK(CGFloat, __VA_ARGS__)
#define NER_RANGE_BLOCK(...)        NER_CHAINABLE_BLOCK(NERRange, __VA_ARGS__)
#define NER_POINT_BLOCK(...)        NER_CHAINABLE_BLOCK(NERPoint, __VA_ARGS__)
#define NER_SIZE_BLOCK(...)         NER_CHAINABLE_BLOCK(NERSize, __VA_ARGS__)
#define NER_RECT_BLOCK(...)         NER_CHAINABLE_BLOCK(NERRect, __VA_ARGS__)
#define NER_INSETS_BLOCK(...)       NER_CHAINABLE_BLOCK(UIEdgeInsets, __VA_ARGS__)
#define NER_FLOAT_LIST_BLOCK(...)   NER_CHAINABLE_BLOCK(NERFloatList, __VA_ARGS__)

#define NER_TWO_INT_BLOCK(...)              return ^(NSInteger value1, NSInteger value2) {__VA_ARGS__; return self;}
#define NER_TWO_FLOAT_BLOCK(...)            return ^(CGFloat value1, CGFloat value2) {__VA_ARGS__; return self;}
#define NER_FLOAT_OBJECT_LIST_BLOCK(...)    return ^(CGFloat value, ...) {NER_GET_VARIABLE_OBJECT_ARGUMENTS(value); __VA_ARGS__; return self;}

#define NER_CALLBACK_BLOCK(...)     return ^(id target, id object) {__weak id weakTarget = target; __weak id weakSelf = self; __VA_ARGS__; weakTarget = nil; weakSelf = nil; return self;}


/*
 Introspect
 */
#define NER_TYPE(x)                 @encode(typeof(x))
#define NER_TYPE_FIRST_LETTER(x)    (NER_TYPE(x)[0])
#define NER_IS_TYPE_OF(x)           (strcmp(type, @encode(x)) == 0)

#define NER_CHECK_IS_INT(x)         (strchr("liBLIcsqCSQ", x) != NULL)
#define NER_CHECK_IS_FLOAT(x)       (strchr("df", x) != NULL)
#define NER_CHECK_IS_PRIMITIVE(x)   (strchr("liBdfLIcsqCSQ", x) != NULL)
#define NER_CHECK_IS_STRUCT_OF(x,y) ([[NSString stringWithUTF8String:x] rangeOfString:@#y].location == 1)
#define NER_CHECK_IS_OBJECT(x)      (strchr("@#", x) != NULL)

#define NER_IS_OBJECT(x)            (strchr("@#", NER_TYPE_FIRST_LETTER(x)) != NULL)
#define NER_IS_INT(x)               NER_CHECK_IS_INT(NER_TYPE_FIRST_LETTER(x))
#define NER_IS_FLOAT(x)             NER_CHECK_IS_FLOAT(NER_TYPE_FIRST_LETTER(x))
#define NER_IS_PRIMITIVE(x)         NER_CHECK_IS_PRIMITIVE(NER_TYPE_FIRST_LETTER(x))

#define NER_IS_STRUCT(x)            (NER_TYPE_FIRST_LETTER(x) == '{')
#define NER_IS_POINT(x)             NER_CHECK_IS_STRUCT_OF(x, CGPoint)
#define NER_IS_SIZE(x)              NER_CHECK_IS_STRUCT_OF(x, CGSize)
#define NER_IS_RECT(x)              NER_CHECK_IS_STRUCT_OF(x, CGRect)
#define NER_IS_INSETS(x)            NER_CHECK_IS_STRUCT_OF(x, UIEdgeInsets)
#define NER_IS_FLOAT_LIST(x)        NER_CHECK_IS_STRUCT_OF(x, NERFloatList)
#define NER_IS_BLOCK(x)             (x && [NSStringFromClass([x class]) rangeOfString:@"__NS.+Block__" options:NSRegularExpressionSearch].location != NSNotFound)



#define NER_SYSTEM_VERSION_HIGHER_EQUAL(n)  ([[[UIDevice currentDevice] systemVersion] floatValue] >= n)


#define NER_FIRAT_VA_ARGS(start, type) \
Exp(\
va_list argList;\
va_start(argList, start);\
type value = va_arg(argList, type);\
va_end(argList);\
value\
)

//#define NER_GET_VARIABLE_FLOAT_ARGUMENTS(start) \
//NSMutableArray *arguments = [NSMutableArray arrayWithObject:@(start)];\
//va_list argList;\
//va_start(argList, start);\
//CGFloat argument;\
//while ((argument = va_arg(argList, CGFloat)) != NERNull) {\
//    [arguments addObject:@(argument)];\
//}\
//va_end(argList);

#define NER_GET_VARIABLE_OBJECT_ARGUMENTS(start) \
NSMutableArray *arguments = [NSMutableArray array];\
va_list argList;\
va_start(argList, start);\
id argument = 0;\
while ((argument = va_arg(argList, id))) {\
    [arguments addObject:argument];\
}\
va_end(argList);




//http://stackoverflow.com/questions/2124339/c-preprocessor-va-args-number-of-arguments

#define NER_NUMBER_OF_VA_ARGS(...)  NER_NUMBER_OF_VA_ARGS_(__VA_ARGS__, NER_RSEQ_N())
#define NER_NUMBER_OF_VA_ARGS_(...) NER_ARG_N(__VA_ARGS__)

#define NER_ARG_N( \
_1, _2, _3, _4, _5, _6, _7, _8, _9,_10, \
_11,_12,_13,_14,_15,_16,_17,_18,_19,_20, \
_21,_22,_23,_24,_25,_26,_27,_28,_29,_30, \
_31,_32,_33,_34,_35,_36,_37,_38,_39,_40, \
_41,_42,_43,_44,_45,_46,_47,_48,_49,_50, \
_51,_52,_53,_54,_55,_56,_57,_58,_59,_60, \
_61,_62,_63,N,...) N

#define NER_RSEQ_N() \
63,62,61,60,                   \
59,58,57,56,55,54,53,52,51,50, \
49,48,47,46,45,44,43,42,41,40, \
39,38,37,36,35,34,33,32,31,30, \
29,28,27,26,25,24,23,22,21,20, \
19,18,17,16,15,14,13,12,11,10, \
9,8,7,6,5,4,3,2,1,0


#define WeakifySelf()       __weak typeof(self) weakSelf = self; weakSelf;
#define StrongifySelf()     typeof(weakSelf) self = weakSelf; self;


#define NER_SYNTHESIZE(getter, setter, ...) \
- (id)getter {\
return objc_getAssociatedObject(self, _cmd);\
}\
- (void)setter:(id)getter {\
objc_setAssociatedObject(self, @selector(getter), getter, OBJC_ASSOCIATION_RETAIN);\
__VA_ARGS__;\
}

#define NER_SYNTHESIZE_BLOCK(getter, setter, type, ...) \
- (type)getter {\
return objc_getAssociatedObject(self, _cmd);\
}\
- (void)setter:(type)getter {\
objc_setAssociatedObject(self, @selector(getter), getter, OBJC_ASSOCIATION_RETAIN);\
__VA_ARGS__;\
}

#define NER_SYNTHESIZE_BOOL(getter, setter, ...) \
- (BOOL)getter {\
return [objc_getAssociatedObject(self, _cmd) boolValue];\
}\
- (void)setter:(BOOL)getter {\
objc_setAssociatedObject(self, @selector(getter), @(getter), OBJC_ASSOCIATION_RETAIN);\
__VA_ARGS__;\
}

#define NER_SYNTHESIZE_INT(getter, setter, ...) \
- (NSInteger)getter {\
return [objc_getAssociatedObject(self, _cmd) integerValue];\
}\
- (void)setter:(NSInteger)getter {\
objc_setAssociatedObject(self, @selector(getter), @(getter), OBJC_ASSOCIATION_RETAIN);\
__VA_ARGS__;\
}

#define NER_SYNTHESIZE_FLOAT(getter, setter, ...) \
- (CGFloat)getter {\
return [objc_getAssociatedObject(self, _cmd) floatValue];\
}\
- (void)setter:(CGFloat)getter {\
objc_setAssociatedObject(self, @selector(getter), @(getter), OBJC_ASSOCIATION_RETAIN);\
__VA_ARGS__;\
}

#define NER_SYNTHESIZE_RANGE(getter, setter, ...) \
- (NSRange)getter {\
return [objc_getAssociatedObject(self, _cmd) rangeValue];\
}\
- (void)setter:(NSRange)getter {\
objc_setAssociatedObject(self, @selector(getter), [NSValue valueWithRange:getter], OBJC_ASSOCIATION_RETAIN);\
__VA_ARGS__;\
}

#define NER_SYNTHESIZE_STRUCT(getter, setter, type, ...) \
- (type)getter {\
return [objc_getAssociatedObject(self, _cmd) type##Value];\
}\
- (void)setter:(type)getter {\
objc_setAssociatedObject(self, @selector(getter), [NSValue valueWith##type:getter], OBJC_ASSOCIATION_RETAIN);\
__VA_ARGS__;\
}



