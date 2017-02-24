//
//  NERUtils.h
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERTypeConverter.h"


@interface NERUtils : NSObject

+ (UIColor *)colorWithColorObject:(id)object;
+ (UIFont *)fontWithFontObject:(id)object;
+ (UIImage *)imageWithImageObject:(id)object;
+ (id)imageOrColorWithObject:(id)object;

+ (UIImage *)onePointImageWithColor:(UIColor *)color;
+ (BOOL)colorHasAlphaChannel:(UIColor *)color;
+ (BOOL)imageHasAlphaChannel:(UIImage *)image;

+ (void)setTextWithStringObject:(id)stringObject forView:(UIView *)view;
+ (void)setPlaceholderWithStringObject:(id)stringObject forView:(UIView *)view;

+ (void)updateViewSizeIfNeed:(UIView *)view withImage:(UIImage *)image;
+ (BOOL)limitTextInput:(id<UITextInput>)textInput withLength:(NSInteger)maxLength;

+ (void)applyStyleObject:(id)value toItem:(id)item;
+ (NSArray *)numberArrayFromFLoatList:(NERFloatList)value;

+ (UIViewController *)getVisibleViewController;

@end



