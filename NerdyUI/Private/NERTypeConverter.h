//
//  NERTypeConverter.h
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

@import ObjectiveC;
#import <UIKit/UIKit.h>
#import "NERDefs.h"

#define NER_INVODE(rt, ...)             ((rt (*)(id, SEL, ...))objc_msgSend)(__VA_ARGS__)
#define NER_CONVERTER_INVOKE(rt, ...)   NER_INVODE(rt, [NERTypeConverter class], __VA_ARGS__)
#define NER_CONVERT_INT_TO_STRING(x)    NER_CONVERTER_INVOKE(id, @selector(convertIntToStringIfNeed:isInt:), x, NER_IS_INT(x))
#define NER_CONVERT_INT_TO_NUMBER(x)    NER_CONVERTER_INVOKE(id, @selector(convertIntToNumberIfNeed:isInt:), x, NER_IS_INT(x))

#define NER_IS_STRING(x)                (NER_IS_OBJECT(x) && NER_CONVERTER_INVOKE(BOOL, @selector(isString:), x))
#define NER_CHECK_IS_STRING(x, ...)     NER_IS_STRING(x)

#define NER_IS_ATT_STRING(x)            (NER_IS_OBJECT(x) && NER_CONVERTER_INVOKE(BOOL, @selector(isAttributedString:), x))
#define NER_CHECK_IS_ATT_STRING(x, ...) NER_IS_ATT_STRING(x)

#define NER_RETURN_OBJECT(x, ...)       NER_CONVERTER_INVOKE(id, @selector(simplyReturnObject:), x)

#define NER_STRING_VALUE(x, ...)        ({typeof(x) _ix_ = (x); NERStringRepresentationOfValue(@encode(typeof(x)), &_ix_);})
#define NER_STRING_FORMAT(...)          ({NER_CONVERTER_INVOKE(NSString *, @selector(stringWithArgumentsCount:format:), \
                                        NER_NUMBER_OF_VA_ARGS(__VA_ARGS__), __VA_ARGS__);})

#define NER_LOG_PREFIX(x, ...)          ({char *_exp_ = #x; _exp_[strlen(_exp_) - 1] == '"'? @"": [NSString stringWithFormat:@"%s: ", _exp_];})

#define NER_NORMALIZE_INSETS(...)       [NERTypeConverter convertNEREdgeInsetsToUIEdgeInsets:(NEREdgeInsets){__VA_ARGS__} \
                                        numberOfValidElements:NER_NUMBER_OF_VA_ARGS(__VA_ARGS__)]

NSString *NERStringRepresentationOfValue(char *type, const void *value);

@interface NERTypeConverter : NSObject

+ (id)convertIntToStringIfNeed:(void *)p isInt:(BOOL)isInt;
+ (id)convertIntToNumberIfNeed:(void *)p isInt:(BOOL)isInt;

+ (BOOL)isString:(id)object;
+ (BOOL)isAttributedString:(id)object;

+ (id)simplyReturnObject:(id)object;

+ (NSString *)stringWithArgumentsCount:(NSInteger)count format:(NSString *)format, ...;

+ (UIEdgeInsets)convertNEREdgeInsetsToUIEdgeInsets:(NEREdgeInsets)insets numberOfValidElements:(NSInteger)number;

@end
