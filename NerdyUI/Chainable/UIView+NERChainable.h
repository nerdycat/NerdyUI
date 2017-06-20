//
//  UIView+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"
#import "UIView+NERFrame.h"
#import "NERStack.h"
#import "NERStaticTableView.h"

#define View    [UIView new]

#define NER_VIEW_PROPS(v)\
\
/**
 * tag
 * Usages: .tg(100)
 */\
NER_PROP(v, Int)                tg;\
\
/**
 * alpha
 * Usages: .opacity(0.8)
 */\
NER_PROP(v, Float)              opacity;\
\
/**
* tintColor
* tint use Color() internally, so it can take any kind of arguments that Color() supported.
* Usages: .tint(@"red"), .tint(@"#F00"), .tint(@"255,0,0"), .tint(colorObject), etc.
* See UIColor+NERChainable.h for more information.
*/\
NER_PROP(v, Object)             tint;\
\
/**
 * backgroundColor
 * bgColor use Color() internally, so it can take any kind of arguments that Color() supported.
 * Usages: .bgColor([UIColor redColor]), .bgColor(@"red"), .bgColor(@"#F00"), .bgColor(@"255,0,0,1"), etc.
 * See UIColor+NERChainable.h for more information.
 */\
NER_PROP(v, Object)             bgColor;\
\
/**
 * Setting layer.cornerRadius value.
 * Will set masksToBounds to YES if there are not shadows existed.
 * Usages: .borderRadius(10)
 */\
NER_PROP(v, Float)              borderRadius;\
\
/**
 * Setting layer.borderWidth and layer.borderColor(optional) at the same time.
 * bd use Color() for its second argument internally, so it can take any kind of arguments that Color() supported.
 * Usages: .border(1), .border(2, @"red"), border(2, @"#FF00FF,0.5")
 * See UIColor+NERChainable.h for more information.
 */\
NER_PROP(v, FloatObjectList)    border;\
\
/**
 * Setting layer.shadowOpacity, layer.shadowRadius(default: 3), layer.shadowOffset(default: 0, 3) at the same time.
 * Usages: .shadow(1), .shadow(0.8, 1), .shadow(1, 2, 2, 2);
 */\
NER_PROP(v, FloatList)          shadow;\
\
/**
 * Apply styles to the view.
 * It support two kind of arguments:
    1) Local styles: NERStyle instance or Array of NERStyle instances.
    2) Global styles: NSString contain a list of style names(separated by white space).

 * Usages: .styles(style), .styles(@[style1, style2, style3]),
           .styles(@"style1"), .styles(@"style1 style2 style3")
 * See NERStyle+NERChainable.h for more information.
 */\
NER_PROP(v, Object)             styles;\
\
/**
 * Add single tap handler. For UIButton, it use UIControlEventTouchUpInside event.
 * Will set userInteractionEnabled to YES as well.
 * It support two kind of arguments:
    1) a callback block
    2) a selector string

 * Usages: 
    .onClick(^{}), .onClick(^(id view) {}),
    .onClick(@"viewDidClick"), .onClick(@"viewDidClick:")
 */\
NER_PROP(v, Callback)           onClick;\
\
/**
 * Setting touch insets.
 * Very useful for extending touch area.

 * Usages:
    .touchInsets(10)                top/left/bottom/right = 10
    .touchInsets(10, 20)            top/bottom = 10, left/right = 20
    .touchInsets(10, 20, 30),       top = 10, left/right = 20, bottom = 30
    .touchInsets(10, 20, 30, 40)    top = 10, left = 20, bottom = 30, right = 40
 */\
NER_PROP(v, Insets)             touchInsets;\
\
/**
 * Add self to superview.
 * Usages: .addTo(superview)
 */\
NER_PROP(v, Object)             addTo;\
\
/**
 * Add Subviews.
 * It can take one or more arguments.
 * Usages: addChild(subview), addChild(subview1, subview2, subview3, ...)
 */\
NER_PROP(v, Object)             addChild;


#define border(...)             border(__VA_ARGS__, nil)
#define shadow(...)             shadow(NER_MAKE_FLOAT_LIST(__VA_ARGS__))
#define touchInsets(...)        touchInsets(NER_NORMALIZE_INSETS(__VA_ARGS__))
#define addChild(...)           addChild(@[__VA_ARGS__])





@interface UIView (NERChainable)

NER_VIEW_PROPS(UIView);

//clipsToBounds = YES
- (instancetype)clip;

//userInteractionEnabled = YES
- (instancetype)touchEnabled;

//userInteractionEnabled = NO
- (instancetype)touchDisabled;

//enabled = NO (if have one)
- (instancetype)stateDisabled;

//hidden = YES
- (instancetype)invisible;

//Usages: .clip.touchDisable.invisible


/*
 * Use to suppress getter side effects warning. Optional.
 * Usages: someButton.str(@"hello").fitSize.End();
 */
- (void(^)())End;

@end




/**
 * Setting view's position and size.
 * Usages: 
    .xywh(10, 10, 50, 50)
    .x(someView.x).y(someView.maxY + 10).wh(someView.wh)
    .cxy(someView.center).w(someView.w / 2).h(100)
 */
#define NER_VIEW_FRAME_PROPS(v) \
NER_PROP(v, Rect)               xywh;\
NER_PROP(v, Point)              cxy;

/**
 * Setting frame value.
 * It support many kind of arguments:
    1) a CGRect
    2) a CGPoint and a CGSize
    3) two CGFloat and a CGSize
    4) a CGPoint and two CGFloat
    5) four CGFloat
 
 * Usages: 
    .xywh(someView.frame), 
    .xywh(CGPointZero, someView.frame.size), 
    .xywh(CGPointZero, 50, 50),
    .xywh(10, 10, WH(50, 50),
    .xywh(10, 10, 50, 50)
 */
#define xywh(...)               xywh((NERRect){__VA_ARGS__})

/**
 * Setting frame.origin value.
 * It support two kind of arguments:
    1) a CGPoint
    2) two CGFloat
 * Usages: .xy(someView.xy), .xy(10, 10), .x(10).y(10)
 
 */
#define xy(...)                 xywh(((NERPoint){__VA_ARGS__}).value, NERNull, NERNull)
#define x(x)                    xywh(x, NERNull, NERNull, NERNull)
#define y(y)                    xywh(NERNull, y, NERNull, NERNull)

/**
 * Setting frame.size value.
 * It support two kind of arguments:
    1) a CGSize
    2) two CGFloat
 * Usages: .wh(someView.wh), .wh(50, 50), .w(50).h(50)
 */
#define wh(...)                 xywh(NERNull, NERNull, ((NERSize){__VA_ARGS__}).value)
#define w(w)                    xywh(NERNull, NERNull, w, NERNull)
#define h(h)                    xywh(NERNull, NERNull, NERNull, h)

/**
 * Setting center value.
 * It support two kind of arguments:
 1) a CGPoint
 2) two CGFloat
 * Usages: .cxy(someView.center), .cxy(50, 50), .cx(50).cy(50)
 */
#define cxy(...)                cxy((NERPoint){__VA_ARGS__})
#define cx(x)                   cxy(x, NERNull)
#define cy(y)                   cxy(NERNull, y)

/**
 * Setting frame by providing bottom-right point of the frame.
 * It support two kind of arguments:
 1) a CGPoint
 2) two CGFloat
 * Usages: .maxXY(someView.maxXY), .maxXY(200, 200), .maxX(200).maxY(200)
 */
#define maxXY(...)              xywh(((NERPoint){__VA_ARGS__}).value, NSIntegerMin, NSIntegerMin)
#define maxX(x)                 maxXY(x, NERNull)
#define maxY(y)                 maxXY(NERNull, y)





@interface UIView (NERChainable_Frame)

NER_VIEW_FRAME_PROPS(UIView);

/**
 * Change size according to content.
 * Usages: .fitWidth.fitHeight, .fitSize
 */

//width to fit, height remain unchanged.
- (instancetype)fitWidth;

//height to fit, width remain unchanged.
- (instancetype)fitHeight;

//sizeToFit
- (instancetype)fitSize;


/**
 * Setting autoresizingMask value.
 * Usages: .flexibleLeft.flexibleRight, .flexibleWH
 */

//UIViewAutoresizingFlexibleLeftMargin
- (instancetype)flexibleLeft;

//UIViewAutoresizingFlexibleRightMargin
- (instancetype)flexibleRight;

//UIViewAutoresizingFlexibleTopMargin
- (instancetype)flexibleTop;

//UIViewAutoresizingFlexibleBottomMargin
- (instancetype)flexibleBottom;

//flexibleLeft + flexibleRight
- (instancetype)flexibleLR;

//flexibleTop + flexibleBottom
- (instancetype)flexibleTB;

//flexibleLeft + flexibleRight + flexibleTop + flexibleBottom
- (instancetype)flexibleLRTB;

//UIViewAutoresizingFlexibleWidth
- (instancetype)flexibleWidth;

//UIViewAutoresizingFlexibleHeight
- (instancetype)flexibleHeight;

//flexibleWidth + flexibleHeight
- (instancetype)flexibleWH;                     

@end




#define NER_VIEW_AUTOLAYOUT_PROPS(v)\
\
/*
 * Setting horizontal contentHuggingPriority.
 * Usages: .horHugging(1000)
 */\
NER_PROP(v, Float)              horHugging;\
\
/**
 * Setting vertical contentHuggingPriority.
 * Usages: .verHugging(800)
 */\
NER_PROP(v, Float)              verHugging;\
\
/**
 * Setting horizontal contentCompressionResistancePriority.
 * Usages: .horResistance(1000)
 */\
NER_PROP(v, Float)              horResistance;\
\
/**
 * Setting vertical contentCompressionResistancePriority.
 * Usages: .verResistance(800)
 */\
NER_PROP(v, Float)              verResistance;\
\
/**
 * Adding a width constraint.
 * Usages: .fixWidth(50)
 */\
NER_PROP(v, Float)              fixWidth;\
\
/**
 * Adding a height constraint.
 * Usages: .fixHeight(50)
 */\
NER_PROP(v, Float)              fixHeight;\
\
/**
 * Adding width and height constraints.
 * Usages: fixWH(50, 50)
 */\
NER_PROP(v, Size)               fixWH;\
\
/**
 * Add self to superview with edge constraints.
 * It can take different number of arguments:
    1) embedIn(superview);                         top/left/bottom/right = 0
    2) embedIn(superview, 10);                     top/left/bottom/right = 10
    3) embedIn(superview, 10, 20);                 top/bottom = 10, left/right = 20
    4) embedIn(superview, 10, 20, 30);             top = 10, left/right = 20, bottom = 30
    5) embedIn(superview, 10, 20, 30, 40);         top = 10, left = 20, bottom = 30, right = 40
    6) embedIn(superview, 10, NERNull);            top/bottom = 10, NERNull means no constriant
 */\
NER_PROP(v, Embed)              embedIn;\
\
/**
 * Make/Remake/Update constraints with Masonry like syntax.
 * Usages:
    .makeCons(^{
        make.top.left.height.equal.constants(50, 50, 30);
        make.width.equal.view(someView).multiplier(0.5).priority(500);
    })
    .updateCons(^{
        make.width.equal.view(someView).height;
    })
 * You can use make object out of box without the need to declare it.
 * See NERConstraint+NERChainable.h for more information.
 */\
NER_PROP(v, Object)             makeCons;\
NER_PROP(v, Object)             remakeCons;\
NER_PROP(v, Object)             updateCons;


#define fixWH(...)              fixWH((NERSize){__VA_ARGS__})
#define embedIn(superview, ...) embedIn(superview, NER_NORMALIZE_INSETS(__VA_ARGS__))

#define makeCons(x)             makeCons(^(NERConstraintMaker *make) {(x)();})
#define remakeCons(x)           remakeCons(^(NERConstraintMaker *make) {(x)();})
#define updateCons(x)           updateCons(^(NERConstraintMaker *make) {(x)();})


@interface UIView (NERChainable_Autolayout)

NER_VIEW_AUTOLAYOUT_PROPS(UIView);


/**
 * Shorthand for setting contentHuggingPriority and contentCompressionResistancePriority.
 * Usages: .lowHugging.lowRegistance
 */

//.horHugging(100).verHugging(100)
- (instancetype)lowHugging;

//.horHugging(900).verHugging(900)
- (instancetype)highHugging;

//.horResistance(100).verResistance(100)
- (instancetype)lowResistance;

//.horResistance(900).verResistance(900)
- (instancetype)highResistance;                 

@end





#define NER_ALL_VIEW_PROPS(v) \
NER_VIEW_PROPS(v) \
NER_VIEW_FRAME_PROPS(v) \
NER_VIEW_AUTOLAYOUT_PROPS(v)

@interface UILabel (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UILabel)
@end

@interface UIImageView (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UIImageView)
@end

@interface UIButton (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UIButton)
@end

@interface UITextField (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UITextField)
@end

@interface UITextView (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UITextView)
@end

@interface UISwitch (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UISwitch)
@end

@interface UIPageControl (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UIPageControl)
@end

@interface UISlider (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UISlider)
@end

@interface UIStepper (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UISlider)
@end

@interface UISegmentedControl (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UISegmentedControl)
@end

@interface UIVisualEffectView (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(UIVisualEffectView)
@end

@interface NERStack (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(NERStack);
@end

@interface NERStaticTableView (UIView_NerdyUI)
NER_ALL_VIEW_PROPS(NERStaticTableView);
@end


#define fnt(x)          fnt(NER_CONVERT_VALUE_TO_STRING(x))
#define str(...)        str(NER_CHECK_IS_ATT_STRING(__VA_ARGS__)? NER_RETURN_OBJECT(__VA_ARGS__): Str(__VA_ARGS__))
#define insets(...)     insets(NER_NORMALIZE_INSETS(__VA_ARGS__))


#define onClick(x)      onClick(self, ({ id __self = self; __weak typeof(self) self = __self; __self = self; x; }) )
#define onLink(x)       onLink(self, ({ id __self = self; __weak typeof(self) self = __self; self; x; }) )
#define onChange(x)     onChange(self, ({ id __self = self; __weak typeof(self) self = __self; __self = self; x; }) )
#define onFinish(x)     onFinish(self, ({ id __self = self; __weak typeof(self) self = __self; self; x; }) )

