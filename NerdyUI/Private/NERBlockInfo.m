//
//  NERBlockInfo.m
//  NerdyUI
//
//  Created by nerdycat on 2016/12/7.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERBlockInfo.h"
#import "NERDefs.h"

//struct NER_block_descriptor {
//    unsigned long int reserved;
//    unsigned long int size;
//    void (*copy)(void *dst, void *src);
//    void (*dispose)(void *);
//};

struct NER_block_layout {
    void *isa;
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    
    struct {
        unsigned long int reserved;
        unsigned long int size;
        void (*copy)(void *dst, void *src);
        void (*dispose)(void *);
    } *descriptor;
    
//    struct NER_block_descriptor *descriptor;
    /* Imported variables. */
};

typedef NS_OPTIONS(NSUInteger, NERBlockDescriptionFlags) {
    NERBlockDescriptionFlagsHasCopyDispose = (1 << 25),
    NERBlockDescriptionFlagsHasCtor = (1 << 26),
    NERBlockDescriptionFlagsIsGlobal = (1 << 28),
    NERBlockDescriptionFlagsHasStret = (1 << 29),
    NERBlockDescriptionFlagsHasSignature = (1 << 30)
};




@interface NERBlockInfo ()

@property (nonatomic, strong) id block;
@property (nonatomic, strong) NSMethodSignature *signature;

@end

@implementation NERBlockInfo


- (NSMethodSignature *)signature {
    if (!_signature) {
        _signature = [self getBlockSignature:self.block];
    }
    return _signature;
}

- (const char *)argumentTypeAtIndex:(NSInteger)index {
    return [self.signature getArgumentTypeAtIndex:index + 1];
}

- (const char *)returnType {
    return [self.signature methodReturnType];
}

- (NSInteger)argumentCount {
    return self.signature.numberOfArguments - 1;
}

- (BOOL)isReturningInt {
    return NER_CHECK_IS_INT(self.returnType[0]);
}

- (BOOL)isReturningFloat {
    return NER_CHECK_IS_FLOAT(self.returnType[0]);
}

- (BOOL)isReturningObject {
    return NER_CHECK_IS_OBJECT(self.returnType[0]);
}

- (BOOL)isAcceptingIntAtIndex:(NSInteger)index {
    return index < self.signature.numberOfArguments - 1? NER_CHECK_IS_INT([self argumentTypeAtIndex:index][0]): NO;
}

- (BOOL)isAcceptingFloatAtIndex:(NSInteger)index {
    return index < self.signature.numberOfArguments - 1? NER_CHECK_IS_FLOAT([self argumentTypeAtIndex:index][0]): NO;
}

- (BOOL)isAcceptingObjectAtIndex:(NSInteger)index {
    return index < self.signature.numberOfArguments - 1? NER_CHECK_IS_OBJECT([self argumentTypeAtIndex:index][0]): NO;
}


typedef struct _AspectBlock {
    __unused Class isa;
    int flags;
    __unused int reserved;
    void (__unused *invoke)(struct _AspectBlock *block, ...);
    struct {
        unsigned long int reserved;
        unsigned long int size;
        // requires AspectBlockFlagsHasCopyDisposeHelpers
        void (*copy)(void *dst, const void *src);
        void (*dispose)(const void *);
        // requires AspectBlockFlagsHasSignature
        const char *signature;
        const char *layout;
    } *descriptor;
    // imported variables
} *AspectBlockRef;


- (NSMethodSignature *)getBlockSignature:(id)block {
    struct NER_block_layout *layout = (__bridge struct NER_block_layout *)block;
    NERBlockDescriptionFlags flags = layout->flags;
    
    if (flags & NERBlockDescriptionFlagsHasSignature) {
        void *signatureLocation = layout->descriptor;
        signatureLocation += sizeof(unsigned long int);
        signatureLocation += sizeof(unsigned long int);
        
        if (flags & NERBlockDescriptionFlagsHasCopyDispose) {
            signatureLocation += sizeof(void(*)(void *dst, void *src));
            signatureLocation += sizeof(void (*)(void *src));
        }
        
        const char *signature = (*(const char **)signatureLocation);
        return [NSMethodSignature signatureWithObjCTypes:signature];
        
    } else {
        return nil;
    }
}

- (instancetype)initWithBlock:(id)block {
    self = [super init];
    self.block = block;
    return self;
}

@end
