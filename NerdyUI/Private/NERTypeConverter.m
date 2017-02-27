//
//  NERTypeConverter.m
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERTypeConverter.h"


id NERConvertValueToString(const char *type, ...) {
    id result = nil;
    
    va_list argList;
    va_start(argList, type);
    
    if (NER_CHECK_IS_INT(type[0])) {
        NSInteger n = va_arg(argList, NSInteger);
        result = [@(n) description];
    } else if (NER_CHECK_IS_FLOAT(type[0])) {
        double n = va_arg(argList, double);
        result = [@(n) description];
    } else {
        result = va_arg(argList, id);
    }
    
    va_end(argList);
    return result;
}

id NERConvertValueToNumber(const char *type, ...) {
    id result = nil;
    
    va_list argList;
    va_start(argList, type);
    
    if (NER_CHECK_IS_INT(type[0])) {
        NSInteger n = va_arg(argList, NSInteger);
        result = @(n);
    } else if (NER_CHECK_IS_FLOAT(type[0])) {
        double n = va_arg(argList, double);
        result = @(n);
    } else {
        result = va_arg(argList, id);
    }
    
    va_end(argList);
    return result;
}

BOOL NERObjectIsKindOfClass(NSString *className, ...) {
    va_list argList;
    va_start(argList, className);
    id object = va_arg(argList, id);
    va_end(argList);
    return [object isKindOfClass:NSClassFromString(className)];
}

id NERObjectFromVariadicFunction(NSString *placeholder, ...) {
    va_list argList;
    va_start(argList, placeholder);
    id object = va_arg(argList, id);
    va_end(argList);
    return object;
}

NSString *NERFormatedStringWithArgumentsCount(NSInteger count, ...) {
    va_list argList;
    va_start(argList, count);
    
    NSString *result = nil;
    NSString *format = va_arg(argList, id);
    
    if (count <= 1) {
        result = format;
    } else {
        result = [[NSString alloc] initWithFormat:format arguments:argList];
    }
    
    va_end(argList);
    return result;
}

UIEdgeInsets NERConvertNEREdgeInsetsToUIEdgeInsets(NEREdgeInsets insets, NSInteger number) {
    UIEdgeInsets newInsets;
    CGFloat a = insets.value.top;
    CGFloat b = insets.value.left;
    CGFloat c = insets.value.bottom;
    CGFloat d = insets.value.right;
    
    if (number == 1) {
        newInsets = UIEdgeInsetsMake(a, a, a, a);
    } else if (number == 2) {
        newInsets = UIEdgeInsetsMake(a, b, a, b);
    } else if (number == 3) {
        newInsets = UIEdgeInsetsMake(a, b, c, b);
    } else {
        newInsets = UIEdgeInsetsMake(a, b, c, d);
    }
    
    return newInsets;
}

NSString *NERStringRepresentationOfValue(const char *type, const void *value) {
    #define VALUE_OF_TYPE(t)    (*(t *)value)
    
    //http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
    //https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    //http://nshipster.com/type-encodings/
    
    long length = strlen(type);
    
    if (length == 1) {
        switch (type[0]) {
            case '@': {
                id object = *(__strong id *)value;
                return [object description];
            }
                
    #define CHECK_PRIMITIVE(t1, t2) case t1: return [@(VALUE_OF_TYPE(t2)) stringValue]
                
            CHECK_PRIMITIVE('i', int);
            CHECK_PRIMITIVE('l', long);
                
            CHECK_PRIMITIVE('f', float);
            CHECK_PRIMITIVE('d', double);
                
            CHECK_PRIMITIVE('s', short);
            CHECK_PRIMITIVE('B', BOOL);
            CHECK_PRIMITIVE('q', long long);
            
            CHECK_PRIMITIVE('I', unsigned int);
            CHECK_PRIMITIVE('L', unsigned long);
            CHECK_PRIMITIVE('S', unsigned short);
            CHECK_PRIMITIVE('Q', unsigned long long);
                
            case 'c':   //char
            case 'C':   //unsigned char
                return [NSString stringWithCharacters:value length:1];
                
            case '*':   //char *
                return [NSString stringWithUTF8String:VALUE_OF_TYPE(char *)];
                
            case ':':
                return NSStringFromSelector(VALUE_OF_TYPE(SEL));
            case '#':
                return NSStringFromClass(VALUE_OF_TYPE(Class));
        }
    }
    
    //const char *
    if (NER_IS_TYPE_OF(const char *)) {
        return [NSString stringWithFormat:@"%s", VALUE_OF_TYPE(const char *)];
    }
    
    //C string literal
    if (length > 1 && type[0] == '[' && type[length - 1] == ']' && type[length - 2] == 'c') {
        return [NSString stringWithFormat:@"%s", (char *)value];
    }
    
    #define CHECK_IS_TYPE_OF(t1, t2)    if (NER_IS_TYPE_OF(t1)) return NSStringFrom##t2(VALUE_OF_TYPE(t1))
    #define CHECK_IS_TYPE_OF2(t1)       CHECK_IS_TYPE_OF(t1, t1)
    
    CHECK_IS_TYPE_OF2(CGRect);
    CHECK_IS_TYPE_OF2(CGPoint);
    CHECK_IS_TYPE_OF2(CGSize);
    
    CHECK_IS_TYPE_OF(NSRange, Range);
    CHECK_IS_TYPE_OF2(UIEdgeInsets);
    
    CHECK_IS_TYPE_OF2(CGVector);
    CHECK_IS_TYPE_OF2(CGAffineTransform);
    CHECK_IS_TYPE_OF2(UIOffset);
    
    return @"";
}



