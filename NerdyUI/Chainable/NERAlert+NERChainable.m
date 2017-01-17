//
//  NERAlert+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/10/31.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERAlert+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "NERUtils.h"

@implementation NERAlertMaker (NERChainable)

- (NERChainableNERAlertMakerObjectBlock)title {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"titleObject"]);
}

- (NERChainableNERAlertMakerObjectBlock)message {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"messageObject"]);
}

- (NERChainableNERAlertMakerObjectBlock)tint {
    NER_OBJECT_BLOCK([self setValue:Color(value) forKey:@"tintObject"]);
}

- (NERChainableNERAlertMakerActionBlock)action {
    return ^(id titleObject, NERSimpleBlock block) {
        [self addActionWithStyle:UIAlertActionStyleDefault title:titleObject handler:block];
        return self;
    };
}

- (NERChainableNERAlertMakerObjectListBlock)cancelAction {
    return ^(id titleObject, ...) {
        NER_GET_VARIABLE_OBJECT_ARGUMENTS(titleObject);
        [self addActionWithStyle:UIAlertActionStyleCancel title:titleObject handler:arguments.firstObject];
        return self;
    };
}

- (NERChainableNERAlertMakerActionBlock)destructiveAction {
    return ^(id titleObject, NERSimpleBlock block) {
        [self addActionWithStyle:UIAlertActionStyleDestructive title:titleObject handler:block];
        return self;
    };
}

- (NERAlertShowBlock)show {
    return ^ {
        return [self presentInTopViewController];
    };
}

@end
