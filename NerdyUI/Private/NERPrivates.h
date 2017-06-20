//
//  NERPrivates.h
//  NerdyUI
//
//  Created by nerdycat on 10/3/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"

@interface NSObject (NERPrivate)

+ (BOOL)ner_swizzleMethod:(SEL)selector1 withMethod:(SEL)selector2;
+ (BOOL)ner_swizzleClassMethod:(SEL)selector1 withMethod:(SEL)selector2;

- (id)ner_associatedObjectForKey:(NSString *)key;
- (void)ner_setAssociatedObject:(id)object forKey:(NSString *)key;

- (id)ner_weakAssociatedObjectForKey:(NSString *)key;
- (void)ner_setWeakAssociatedObject:(id)object forKey:(NSString *)key;

- (NSArray *)ner_allPropertyNames;
- (NSArray *)ner_allIvarNames;
- (NSArray *)ner_allMethodNames;

@end


@interface NSString (NERPrivate)

- (NSRange)ner_fullRange;

- (NSString *)ner_md5;
- (NSString *)ner_base64;
- (NSString *)ner_urlEncode;
- (NSString *)ner_urlDecode;
- (NSString *)ner_trim;

@end



#define NERLinkAttributeName            @"NERLink"
#define NERLinkAttributeValue           @"NERLinkValue"

#define NERFixLineSpacingAttributeName  @"NERFixLineSpacingIssue"
#define NERFixLineSpacingAttributeValue @"Fix single line Label with lineSpacing issue"

@interface NSMutableAttributedString (NERPrivate)

@property (nonatomic, assign) BOOL nerAddAttributeIfNotExists;
@property (nonatomic, assign) BOOL nerIsJustSettingEffectedRanges;
@property (nonatomic, strong) NSMutableIndexSet *nerEffectedRanges;

+ (instancetype)ner_attributedStringWithSubstrings:(NSArray *)substrings;

- (void)ner_applyAttribute:(NSString *)name withValue:(id)value;
- (void)ner_addAttributeIfNotExist:(NSString *)name value:(id)value range:(NSRange)range;
- (void)ner_setParagraphStyleValue:(id)value forKey:(NSString *)key;
- (void)ner_setParagraphStyleValue:(id)value forKey:(NSString *)key range:(NSRange)range;

@end




@interface UIView (NERPriavte)

@property (nonatomic, assign) UIEdgeInsets nerTouchInsets;

- (CGSize)ner_fittingSize;
- (UIImage *)ner_snapShot;

- (void)ner_addChild:(id)value;
- (instancetype)ner_updateFrame:(NERRect)rect;

+ (instancetype)ner_littleHigherHuggingAndResistanceView;

@end



@interface UIImageView (NERPriavte)

@end



@interface UIButton (NERPriavte)

@property (nonatomic, assign) CGFloat nerGap;
@property (nonatomic, assign) UIEdgeInsets nerInsets;

+ (instancetype)ner_littleHigherHuggingAndResistanceButton;
- (instancetype)ner_reverseButton;

@end




@interface UITextField (NERPriavte)

@property (nonatomic, assign) NSInteger nerMaxLength;
@property (nonatomic, assign) UIEdgeInsets nerContentEdgeInsets;
@property (nonatomic, strong) NERObjectBlock nerTextChangeBlock;
@property (nonatomic, strong) NERObjectBlock nerEndOnExitBlock;


+ (instancetype)ner_autoEnableReturnKeyTextField;

@end



@interface UITextView (NERPriavte)

@property (nonatomic, assign) NSInteger nerMaxLength;
@property (nonatomic, strong) NERObjectBlock nerTextChangeBlock;

- (void)ner_setPlaceholderText:(id)stringObject;

@end



@interface UISlider (NERPrivate)

@property (nonatomic, strong) NSNumber *nerTrackHeight;
@property (nonatomic, assign) UIEdgeInsets nerThumbInsets;

@end



@interface UIPageControl (NERPriavte)

@end



@interface UISwitch (NERPriavte)

@end


@interface UIStepper (NERPriavte)

@end


@interface UIVisualEffectView (NERPriavte)

@property (nonatomic, strong) UIVisualEffectView *nerVibrancyEffectView;

- (void)ner_addVibrancyChild:(id)object;

@end


@interface UISegmentedControl (NERPriavte)

+ (instancetype)ner_segmentedControlWithItems:(NSArray *)items;

@end




@interface UIControl (NERPriavte)

- (instancetype)ner_registerOnChangeHandlerWithTarget:(id)target object:(id)object;

@end


@protocol UIControlPrivateProtocol <NSObject>

- (void)ner_control_onChangeHandler;

@end


@interface UIColor (NERPrivate)

- (UIColor *)ner_colorWithHueOffset:(CGFloat)ho saturationOffset:(CGFloat)so brightnessOffset:(CGFloat)bo;

@end


@interface UIImage (NERPrivate)

- (UIImage *)ner_stretchableImage;


//https://developer.apple.com/library/content/samplecode/UIImageEffects/Introduction/Intro.html#//apple_ref/doc/uid/DTS40013396

//| ----------------------------------------------------------------------------
//! Applies a blur, tint color, and saturation adjustment to @a inputImage,
//! optionally within the area specified by @a maskImage.
//!
//! @param  blurRadius
//!         The radius of the blur in points.
//! @param  tintColor
//!         An optional UIColor object that is uniformly blended with the
//!         result of the blur and saturation operations.  The alpha channel
//!         of this color determines how strong the tint is.
//! @param  saturationDeltaFactor
//!         A value of 1.0 produces no change in the resulting image.  Values
//!         less than 1.0 will desaturation the resulting image while values
//!         greater than 1.0 will have the opposite effect.
//! @param  maskImage
//!         If specified, @a inputImage is only modified in the area(s) defined
//!         by this mask.  This must be an image mask or it must meet the
//!         requirements of the mask parameter of CGContextClipToMask.

- (UIImage *)ner_blueWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end



