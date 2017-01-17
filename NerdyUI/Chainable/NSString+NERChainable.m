//
//  NSString+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 10/2/16.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+NERChainable.h"
#import "NERPrivates.h"

@implementation NSString (NERChainable)

- (NERChainableNSStringObjectBlock)a {
    NER_OBJECT_BLOCK(return [self stringByAppendingString:value]);
}

- (NERChainableNSStringObjectBlock)ap {
    NER_OBJECT_BLOCK(return [self stringByAppendingPathComponent:value]);
}

- (NERChainableNSStringIntOrObjectBlock)subFrom {
    return ^(id value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [self substringFromIndex:[value integerValue]];
        } else {
            NSRange range = [self rangeOfString:[value description]];
            if (range.location != NSNotFound) {
                return [self substringFromIndex:range.location];
            } else {
                return @"";
            }
        }
    };
}

- (NERChainableNSStringIntOrObjectBlock)subTo {
    return ^(id value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [self substringToIndex:[value integerValue]];
        } else {
            NSRange range = [self rangeOfString:[value description]];
            if (range.location != NSNotFound) {
                return [self substringToIndex:range.location];
            } else {
                return @"";
            }
        }
    };
}

- (NERChainableNSStringObjectBlock)subMatch {
    return ^(id value) {
        NSRegularExpression *exp = nil;
        if ([value isKindOfClass:NSRegularExpression.class]) {
            exp = value;
        } else {
            exp = [[NSRegularExpression alloc] initWithPattern:value options:0 error:nil];
        }
        
        NSRange range = [exp rangeOfFirstMatchInString:self options:0 range:[self ner_fullRange]];
        
        if (range.location != NSNotFound) {
            return [self substringWithRange:range];
        } else {
            return @"";
        }
    };
}

- (NERChainableNSStringTwoObjectBlock)subReplace {
    return ^(id pattern, id template) {
        NSRegularExpression *exp = nil;
        if ([pattern isKindOfClass:NSRegularExpression.class]) {
            exp = pattern;
        } else {
            exp = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
        }
        
        return [exp stringByReplacingMatchesInString:self options:0 range:[self ner_fullRange] withTemplate:template];
    };
}


- (NSString *)inDocument {
    static NSString *documentPath = nil;
    if (!documentPath) {
        documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    return [documentPath stringByAppendingPathComponent:self];
}

- (NSString *)inCaches {
    static NSString *cachesPath = nil;
    if (!cachesPath) {
        cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    }
    return [cachesPath stringByAppendingPathComponent:self];
}

- (NSString *)inTmp {
    static NSString *tmpPath = nil;
    if (!tmpPath) {
        tmpPath = NSTemporaryDirectory();
    }
    return [tmpPath stringByAppendingPathComponent:self];
}

@end

