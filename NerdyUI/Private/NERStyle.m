//
//  NERStyle.m
//  NerdyUI
//
//  Created by CAI on 11/1/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStyle.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

static NSMutableDictionary *ner_styleDict = nil;

@interface NERStyle ()

@property (nonatomic, strong) NSMutableDictionary *objectProperties;
@property (nonatomic, strong) NSMutableArray *methods;

@end

@implementation NERStyle

- (NSMutableDictionary *)objectProperties {
    if (!_objectProperties) {
        _objectProperties = [NSMutableDictionary dictionary];
    }
    return _objectProperties;
}

- (NSMutableArray *)methods {
    if (!_methods) {
        _methods = [NSMutableArray array];
    }
    return _methods;
}

- (void)setObjectValue:(id)value forKey:(NSString *)key {
    if (value && key) {
        self.objectProperties[key] = value;
    }
}

- (void)setIntValue:(NSInteger)value forKey:(NSString *)key {
    [self setObjectValue:@(value) forKey:key];
}

- (void)setFloatValue:(CGFloat)value forKey:(NSString *)key {
    [self setObjectValue:@(value) forKey:key];
}

- (void)setPointValue:(CGPoint)value forKey:(NSString *)key {
    [self setObjectValue:[NSValue valueWithCGPoint:value] forKey:key];
}

- (void)setSizeValue:(CGSize)value forKey:(NSString *)key {
    [self setObjectValue:[NSValue valueWithCGSize:value] forKey:key];
}

- (void)setRectValue:(CGRect)value forKey:(NSString *)key {
    [self setObjectValue:[NSValue valueWithCGRect:value] forKey:key];
}

- (void)setFloatListValue:(NERFloatList)flostList forKey:(NSString *)key {
    id value = [NSValue valueWithBytes:&flostList objCType:@encode(NERFloatList)];
    [self setObjectValue:value forKey:key];
}

- (void)addMethodWithName:(NSString *)name {
    if (name) {
        [self.methods addObject:name];
    }
}

- (void)applyToItem:(id)item {
    for (NSString *key in self.objectProperties) {
        id object = self.objectProperties[key];
        SEL sel = NSSelectorFromString(key);
        
        if ([key isEqualToString:@"layer.borderWidth"]) {
            if ([item isKindOfClass:UIView.class]) {
                [item setValue:object forKeyPath:key];
            }
            continue;
            
        } else if ([key isEqualToString:@"layer.borderColor"]) {
            if ([item isKindOfClass:UIView.class]) {
                [item setValue:object forKeyPath:key];
            }
            continue;
        }
        
        if ([object isKindOfClass:NSNumber.class]) {
            CGFloat value = [object floatValue];
            
            if ([item respondsToSelector:sel]) {
                id block = [item performSelector:sel withObject:nil];
                if (NER_IS_BLOCK(block)) {
                    ((void (^)(CGFloat))block)(value);
                }
            }
            
        } else if ([object isKindOfClass:NSValue.class]) {
            const char *ocType = [object objCType];
            
#define CALL_METHOD_WITH_VALUE(type, value) \
            if ([item respondsToSelector:sel]) {\
                id block = [item performSelector:sel withObject:nil];\
                if (NER_IS_BLOCK(block)) {\
                    ((void (^)(type))block)(value);\
                }\
            }
            
#define CALL_STRUCT_METHOD(type)\
            type value = [object type##Value];\
            CALL_METHOD_WITH_VALUE(type, value);
            
            if (NER_IS_POINT(ocType)) {
                CALL_STRUCT_METHOD(CGPoint);
            } else if (NER_IS_SIZE(ocType)) {
                CALL_STRUCT_METHOD(CGSize);
            } else if(NER_IS_RECT(ocType)) {
                CALL_STRUCT_METHOD(CGRect);
            } else if (NER_IS_INSETS(ocType)) {
                CALL_STRUCT_METHOD(UIEdgeInsets);
            } else if (NER_IS_FLOAT_LIST(ocType)) {
                NERFloatList floatList;
                [object getValue:&floatList];
                CALL_METHOD_WITH_VALUE(NERFloatList, floatList);
            } else {
//                Log(ocType);
            }
            
        } else {
            if ([item respondsToSelector:sel]) {
                id block = [item performSelector:sel withObject:nil];
                if (NER_IS_BLOCK(block)) {
                    ((NERObjectBlock)block)(object);
                }
            }
        }
    }
    
    for (NSString *name in self.methods) {
        SEL sel = NSSelectorFromString(name);
        if ([item respondsToSelector:sel]) {
            [item performSelector:sel withObject:nil];
        }
    }
}

+ (instancetype)styleWithKey:(id <NSCopying>)key {
    return ner_styleDict[key];
}

+ (instancetype)createStyleWithKey:(id <NSCopying>)key {
    NERStyle *style = [NERStyle new];
    if (!ner_styleDict) ner_styleDict = [NSMutableDictionary dictionary];
    if (key) ner_styleDict[key] = style;
    return style;
}

+ (instancetype)createStyleWithKeys:(NSArray *)keys {
    return [self createStyleWithKey:keys.firstObject];
}

@end
