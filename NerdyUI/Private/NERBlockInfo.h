//
//  NERBlockInfo.h
//  NerdyUI
//
//  Created by nerdycat on 2016/12/7.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NERBlockInfo : NSObject

@property (nonatomic, readonly) id block;
@property (nonatomic, readonly) NSMethodSignature *signature;

@property (nonatomic, readonly) NSInteger argumentCount;
@property (nonatomic, readonly) const char *returnType;

@property (nonatomic, readonly) BOOL isReturningInt;
@property (nonatomic, readonly) BOOL isReturningFloat;
@property (nonatomic, readonly) BOOL isReturningObject;

- (instancetype)initWithBlock:(id)block;

- (const char *)argumentTypeAtIndex:(NSInteger)index;

- (BOOL)isAcceptingIntAtIndex:(NSInteger)index;
- (BOOL)isAcceptingFloatAtIndex:(NSInteger)index;
- (BOOL)isAcceptingObjectAtIndex:(NSInteger)index;

@end
