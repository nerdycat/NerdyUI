//
//  NERUtils.m
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERUtils.h"
#import "NERDefs.h"
#import "NERStyle.h"
#import "NERPrivates.h"


@implementation NERUtils

+ (UIColor *)colorWithColorObject:(id)object {
    if ([object isKindOfClass:[UIColor class]]) {
        return object;
        
    } else if ([object isKindOfClass:[NSString class]]) {
        CGFloat alpha = 1;
        NSArray *componnets = [object componentsSeparatedByString:@","];
        
        //whether the color object contains alpha
        if (componnets.count == 2 || componnets.count == 4) {
            NSRange range = [object rangeOfString:@"," options:NSBackwardsSearch];
            alpha = [[object substringFromIndex:range.location + range.length] floatValue];
            alpha = MIN(alpha, 1);
            object = [object substringToIndex:range.location];
        }
        
        //system color
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", object]);
        if ([UIColor respondsToSelector:sel]) {
            UIColor *color = [UIColor performSelector:sel withObject:nil];
            if (alpha != 1) color = [color colorWithAlphaComponent:alpha];
            return color;
        }
        
        int r = 0, g = 0, b = 0;
        BOOL isRGBColor = NO;
        
        //random
        if ([object isEqualToString:@"random"]) {
            r = arc4random_uniform(256);
            g = arc4random_uniform(256);
            b = arc4random_uniform(256);
            isRGBColor = YES;
            
        } else {
            BOOL isHex = NO;
            
            if ([object hasPrefix:@"#"]) {
                object = [object substringFromIndex:1];
                isHex = YES;
            }
            if ([object hasPrefix:@"0x"]) {
                object = [object substringFromIndex:2];
                isHex = YES;
            }
            
            if (isHex) {
                int result = sscanf([object UTF8String], "%2x%2x%2x", &r, &g, &b);     //#FFFFFF
                
                if (result != 3) {
                    result = sscanf([object UTF8String], "%1x%1x%1x", &r, &g, &b);     //#FFF
                    
                    //convert #FFF to #FFFFFF
                    if (result == 3) {
                        r *= 17; g *= 17; b *= 17;
                    }
                }
                isRGBColor = (result == 3);
                
            } else {
                int result = sscanf([object UTF8String], "%d,%d,%d", &r, &g, &b);       //rgb
                isRGBColor = (result == 3);
            }
        }
        
        if (isRGBColor) {
            return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:alpha];
        }
        
    } else if ([object isKindOfClass:[UIImage class]]) {
        return [UIColor colorWithPatternImage:object];
    }
    
    return nil;
}

+ (UIFont *)fontWithFontObject:(id)object {
    if ([object isKindOfClass:[UIFont class]]) {
        return object;
        
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [UIFont boldSystemFontOfSize:[object floatValue]];
        
    } else if ([object isKindOfClass:[NSString class]]) {
        static NSMutableDictionary *fontStyles = nil;
        
        if (!fontStyles) {
            fontStyles = [@{
                            @"headline": UIFontTextStyleHeadline,
                            @"subheadline": UIFontTextStyleSubheadline,
                            @"caption1": UIFontTextStyleCaption1,
                            @"caption2": UIFontTextStyleCaption2,
                            @"body": UIFontTextStyleBody,
                            @"footnote": UIFontTextStyleFootnote,
                            } mutableCopy];
            
            if (NER_SYSTEM_VERSION_HIGHER_EQUAL(9)) {
                [fontStyles setObject:UIFontTextStyleCallout forKey:@"callout"];
                [fontStyles setObject:UIFontTextStyleTitle1 forKey:@"title1"];
                [fontStyles setObject:UIFontTextStyleTitle2 forKey:@"title2"];
                [fontStyles setObject:UIFontTextStyleTitle3 forKey:@"title3"];
            }
        }
        
        NSString *fontString = [object lowercaseString];
        NSString *style = fontStyles[fontString];
        
        if (style) {
            return [UIFont preferredFontForTextStyle:style];
        }
        
        NSArray *elements = [object componentsSeparatedByString:@","];
        if (elements.count == 2) {
            NSString *fontName = elements[0];
            CGFloat fontSize = [elements[1] floatValue];
            return [UIFont fontWithName:fontName size:fontSize];
        }
        
        CGFloat fontSize = [fontString floatValue];
        if (fontSize > 0) {
            return [UIFont systemFontOfSize:fontSize];
        }
    }
    
    return nil;
}

+ (UIImage *)imageWithImageObject:(id)object {
    return [self imageWithImageObject:object allowColorImage:YES];
}


+ (UIImage *)imageWithImageObject:(id)object allowColorImage:(BOOL)allowColorImage {
    if ([object isKindOfClass:[UIImage class]]) {
        return object;
        
    } else if ([object isKindOfClass:[NSString class]]) {
        BOOL stretchImage = [object hasPrefix:@"#"];
        NSString *imageName = stretchImage? [object substringFromIndex:1]: object;
        UIImage *image = [UIImage imageNamed:imageName];
        
        if (stretchImage) {
            if (!image) {
                image = [UIImage imageNamed:object];     //fallback
                
            } else {
                return [image ner_stretchableImage];
            }
        }
        
        if (allowColorImage && !image) {
            image = [self onePointImageWithColor:[NERUtils colorWithColorObject:object]];
        }

        return image;
    }
    
    return nil;
}

+ (id)imageOrColorWithObject:(id)object {
    id result = [self imageWithImageObject:object allowColorImage:NO];
    if (!result) result = [self colorWithColorObject:object];
    return result;
}

+ (UIImage *)onePointImageWithColor:(UIColor *)color {
    if (!color) return nil;
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    BOOL hasAlpha = [self colorHasAlphaChannel:color];
    UIGraphicsBeginImageContextWithOptions(rect.size, !hasAlpha, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (BOOL)colorHasAlphaChannel:(UIColor *)color {
    return CGColorGetAlpha(color.CGColor) < 1;
}

+ (BOOL)imageHasAlphaChannel:(UIImage *)image {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (void)setTextWithStringObject:(id)stringObject forView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        
        if ([stringObject isKindOfClass:[NSAttributedString class]]) {
            [button setAttributedTitle:stringObject forState:UIControlStateNormal];
        } else {
            [button setTitle:[stringObject description] forState:UIControlStateNormal];
        }
        
    } else {
        if ([stringObject isKindOfClass:[NSAttributedString class]]) {
            if ([view respondsToSelector:@selector(setAttributedText:)]) {
                [view performSelector:@selector(setAttributedText:) withObject:stringObject];
            }
        } else {
            if ([view respondsToSelector:@selector(setText:)]) {
                [view performSelector:@selector(setText:) withObject:[stringObject description]];
            }
        }
    }
}

+ (void)setPlaceholderWithStringObject:(id)stringObject forView:(UIView *)view {
    if ([stringObject isKindOfClass:[NSAttributedString class]]) {
        if ([view respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            [view performSelector:@selector(setAttributedPlaceholder:) withObject:stringObject];
        }
    } else {
        if ([view respondsToSelector:@selector(setPlaceholder:)]) {
            [view performSelector:@selector(setPlaceholder:) withObject:[stringObject description]];
        }
    }
}


+ (void)updateViewSizeIfNeed:(UIView *)view withImage:(UIImage *)image {
    if (view.translatesAutoresizingMaskIntoConstraints &&
        CGSizeEqualToSize(view.frame.size, CGSizeZero) && image) {
        CGRect frame = view.frame;
        frame.size = image.size;
        view.frame = frame;
    }
}

+ (BOOL)limitTextInput:(id<UITextInput>)textInput withLength:(NSInteger)maxLength {
    UITextPosition *markPosition = [textInput markedTextRange].start;
    markPosition = [textInput positionFromPosition:markPosition offset:0];
    
    if (!markPosition) {
        NSString *text = [(id)textInput valueForKey:@"text"];
        
        if (maxLength > 0 && text.length > maxLength) {
            NSString *newText = nil;
            NSRange rangeIndex = [text rangeOfComposedCharacterSequenceAtIndex:maxLength];
            
            
            if (rangeIndex.length == 1) {
                newText = [text substringToIndex:maxLength];
            } else {
                NSRange rangeRange = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                newText = [text substringWithRange:rangeRange];
            }
            
            BOOL needResetCursorPosition = NO;
            UITextRange *selectedRange = [textInput selectedTextRange];
            
            if (selectedRange.isEmpty) {
                UITextPosition *cursorPosition = [textInput selectedTextRange].start;
                cursorPosition = [textInput positionFromPosition:cursorPosition offset:0];
                
                UITextPosition *maxPosition = [textInput positionFromPosition:[textInput beginningOfDocument] offset:maxLength];
                
                if ([textInput comparePosition:cursorPosition toPosition:maxPosition] == NSOrderedAscending) {
                    needResetCursorPosition = YES;
                }
            }
            
            [(id)textInput setValue:newText forKey:@"text"];
            
            if (needResetCursorPosition) {
                [textInput setSelectedTextRange:selectedRange];
            }
        }
        
        return NO;
        
    } else {
        return YES;
    }
}

+ (void)applyStyleObject:(id)value toItem:(id)item {
    if ([value isKindOfClass:NERStyle.class]) {
        [value applyToItem:item];
    
    } else if ([value isKindOfClass:NSArray.class]) {
        for (NERStyle *style in value) {
            [style applyToItem:item];
        }
        
    } else if ([value isKindOfClass:NSString.class]) {
        NSArray *styles = [value componentsSeparatedByString:@" "];
        for (id styleName in styles) {
            [[NERStyle styleWithKey:styleName] applyToItem:item];
        }
    }
}

+ (NSArray *)numberArrayFromFLoatList:(NERFloatList)value {
    id values = @[@(value.f1), @(value.f2), @(value.f3), @(value.f4), @(value.f5),
                  @(value.f6), @(value.f7), @(value.f8), @(value.f9), @(value.f10)];
    
    return [values subarrayWithRange:NSMakeRange(0, value.validCount)];
}

+ (UIViewController *)getVisibleViewController {
    UIWindow *window = [UIApplication sharedApplication ].delegate.window;
    UIViewController *rootViewController = window.rootViewController;
    return [self getVisibleViewController:rootViewController];
}

+ (UIViewController *)getVisibleViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [self getVisibleViewController:lastViewController];
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [self getVisibleViewController:selectedViewController];
    }
    
    if (rootViewController.presentedViewController != nil) {
        UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
        return [self getVisibleViewController:presentedViewController];
    }
    
    return rootViewController;
}

@end



