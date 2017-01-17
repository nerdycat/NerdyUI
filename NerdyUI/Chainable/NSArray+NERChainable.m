//
//  NSArray+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/5.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NSArray+NERChainable.h"
#import "NERBlockInfo.h"
#import "NERDefs.h"


@implementation NSArray (NERChainable)


- (id)ner_invokeBlock:(NERBlockInfo *)blockInfo withValue:(id)value atIndex:(NSInteger)index {
    id result = nil;
    
#define INVODE_WITH_RETURN_TYPE(x)  \
    [blockInfo isAcceptingIntAtIndex:0]?\
        ((x (^)(long long, NSInteger, id))blockInfo.block)([value longLongValue], index, self):\
        [blockInfo isAcceptingFloatAtIndex:0]?\
            ((x (^)(double, NSInteger, id))blockInfo.block)([value doubleValue], index, self):\
            ((x (^)(id, NSInteger, id))blockInfo.block)(value, index, self)
    
    if (blockInfo.isReturningInt) {
        result = @(INVODE_WITH_RETURN_TYPE(long long));
    } else if (blockInfo.isReturningFloat) {
        result = @(INVODE_WITH_RETURN_TYPE(double));
    } else {
        result = INVODE_WITH_RETURN_TYPE(id);
    }
    
    return result;
}

- (id)ner_invokeBlock:(NERBlockInfo *)blockInfo withAccumulator:(id)accumulator value:(id)value atIndex:(NSInteger)index {
    id result = nil;
    
#define INVODE_WITH_RETURN_TYPE2(x)  \
    [blockInfo isAcceptingIntAtIndex:0]?\
    ((x (^)(long long, long long, NSInteger, id))blockInfo.block)([accumulator longLongValue], [value longLongValue], index, self):\
    [blockInfo isAcceptingFloatAtIndex:0]?\
        ((x (^)(double, double, NSInteger, id))blockInfo.block)([accumulator longLongValue], [value doubleValue], index, self):\
        ((x (^)(id, id, NSInteger, id))blockInfo.block)(accumulator, value, index, self)
    
    if (blockInfo.isReturningInt) {
        result = @(INVODE_WITH_RETURN_TYPE2(long long));
    } else if (blockInfo.isReturningFloat) {
        result = @(INVODE_WITH_RETURN_TYPE2(double));
    } else {
        result = INVODE_WITH_RETURN_TYPE2(id);
    }
    
    return result;
}

- (NSArray *)ner_invokeBlockForEachElement:(id)block filterResult:(BOOL)filter {
    if (block) {
        NERBlockInfo *blockInfo = [[NERBlockInfo alloc] initWithBlock:block];
        
        if (blockInfo.argumentCount > 0) {
            NSMutableArray *targets = [NSMutableArray arrayWithCapacity:self.count];
            
            for (NSInteger i = 0; i < self.count; ++i) {
                id result = [self ner_invokeBlock:blockInfo withValue:self[i] atIndex:i];
                
                if (!filter) {
                    [targets addObject:result];
                } else if ([result boolValue]) {
                    [targets addObject:self[i]];
                }
            }
            
            return (NSArray *)[targets copy];
        }
    }
    
    return self;
}


- (NSArray *(^)(id))forEach {
    return ^(id object) {
        if ([object isKindOfClass:NSString.class]) {
            [self makeObjectsPerformSelector:NSSelectorFromString(object)];
            
        } else {
            NERBlockInfo *blockInfo = [[NERBlockInfo alloc] initWithBlock:object];
            if (blockInfo.argumentCount > 0) {
                for (NSInteger i = 0; i < self.count; ++i) {
                    [self ner_invokeBlock:blockInfo withValue:self[i] atIndex:i];
                }
            }
        }
        
        return self;
    };
}

- (NSArray *(^)(id))map {
    return ^(id block) {
        return [self ner_invokeBlockForEachElement:block filterResult:NO];
    };
}

- (NSArray *(^)(id))filter {
    return ^(id block) {
        return [self ner_invokeBlockForEachElement:block filterResult:YES];
    };
}

- (id (^)(id, ...))reduce {
    return ^(id blockOrInitialValue, ...) {
        id block = nil;
        id initialValue = nil;
    
        if (NER_IS_BLOCK(blockOrInitialValue)) {
            block = blockOrInitialValue;
        } else {
            initialValue = blockOrInitialValue;
            block = NER_FIRAT_VA_ARGS(blockOrInitialValue, id);
        }
        
        if (block) {
            NERBlockInfo *blockInfo = [[NERBlockInfo alloc] initWithBlock:block];
            
            if (blockInfo.argumentCount > 0) {
                id accumulator = self.firstObject;
                NSInteger beginIndex = 1;
                
                if (initialValue) {
                    accumulator = initialValue;
                    beginIndex = 0;
                }
                
                for (NSInteger i = beginIndex; i < self.count; ++i) {
                    accumulator = [self ner_invokeBlock:blockInfo withAccumulator:accumulator value:self[i] atIndex:i];
                }
                
                return accumulator;
            }
        }
        
        return initialValue;
    };
}

@end

