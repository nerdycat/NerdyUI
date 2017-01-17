//
//  NERStyle.h
//  NerdyUI
//
//  Created by CAI on 11/1/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NERDefs.h"

@interface NERStyle : NSObject

+ (instancetype)styleWithKey:(id <NSCopying>)key;
+ (instancetype)createStyleWithKey:(id <NSCopying>)key;
+ (instancetype)createStyleWithKeys:(NSArray *)keys;

- (void)setObjectValue:(id)value forKey:(NSString *)Key;
- (void)setIntValue:(NSInteger)value forKey:(NSString *)key;
- (void)setFloatValue:(CGFloat)value forKey:(NSString *)key;
- (void)setPointValue:(CGPoint)value forKey:(NSString *)key;
- (void)setSizeValue:(CGSize)value forKey:(NSString *)key;
- (void)setRectValue:(CGRect)value forKey:(NSString *)key;
- (void)setFloatListValue:(NERFloatList)flostList forKey:(NSString *)key;

- (void)addMethodWithName:(NSString *)name;

- (void)applyToItem:(id)item;

@end
