//
//  NERTypeConverter.h
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <objc/objc.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "NERDefs.h"


#define NER_CONVERT_VALUE_TO_STRING(x)  NERConvertValueToString(NER_TYPE(x), x)
#define NER_CONVERT_VALUE_TO_NUMBER(x)  NERConvertValueToNumber(NER_TYPE(x), x)

#define NER_IS_STRING(x)                (NER_IS_OBJECT(x) && NERObjectIsKindOfClass(@"NSString", x))
#define NER_CHECK_IS_STRING(x, ...)     NER_IS_STRING(x)

#define NER_IS_ATT_STRING(x)            (NER_IS_OBJECT(x) && NERObjectIsKindOfClass(@"NSAttributedString", x))
#define NER_CHECK_IS_ATT_STRING(x, ...) NER_IS_ATT_STRING(x)

#define NER_RETURN_OBJECT(x, ...)       NERObjectFromVariadicFunction(@"placeholder", x)

#define NER_STRING_VALUE(x, ...)        ({ typeof(x) _ix_ = (x); NERStringRepresentationOfValue(@encode(typeof(x)), &_ix_); })
#define NER_STRING_FORMAT(...)          ({ NERFormatedStringWithArgumentsCount(NER_NUMBER_OF_VA_ARGS(__VA_ARGS__), __VA_ARGS__); })

#define NER_LOG_PREFIX(x, ...)          ({ const char *_exp_ = #x; _exp_[strlen(_exp_) - 1] == '"'? @"": [NSString stringWithFormat:@"%s: ", _exp_]; })

#define NER_NORMALIZE_INSETS(...)       NERConvertNEREdgeInsetsToUIEdgeInsets((NEREdgeInsets){__VA_ARGS__}, NER_NUMBER_OF_VA_ARGS(__VA_ARGS__))


id      NERConvertValueToString(const char *type, ...);
id      NERConvertValueToNumber(const char *type, ...);
id      NERObjectFromVariadicFunction(NSString *placeholder, ...);
BOOL    NERObjectIsKindOfClass(NSString *className, ...);

NSString *      NERFormatedStringWithArgumentsCount(NSInteger count, ...);
UIEdgeInsets    NERConvertNEREdgeInsetsToUIEdgeInsets(NEREdgeInsets insets, NSInteger number);
NSString *      NERStringRepresentationOfValue(const char *type, const void *value);


