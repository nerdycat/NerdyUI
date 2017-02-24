//
//  NERAlertMaker.m
//  NerdyUI
//
//  Created by nerdycat on 2016/10/31.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERAlertMaker.h"
#import "NERUtils.h"

@interface NERAlertMaker ()

@property (nonatomic, strong) id titleObject;
@property (nonatomic, strong) id messageObject;
@property (nonatomic, strong) id tintObject;

@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, assign) UIAlertControllerStyle style;

@end


@implementation NERAlertMaker

- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [NSMutableArray array];
    }
    return _actions;
}

- (void)addActionWithStyle:(UIAlertActionStyle)style
                     title:(id)titleObject
                   handler:(void (^ __nullable)(UIAlertAction *action))handler {
    
    NSString *title = nil;
    UIColor *titleColor = nil;
    
    if ([titleObject isKindOfClass:NSAttributedString.class]) {
        NSAttributedString *as = (NSAttributedString *)titleObject;
        title = as.string;
        titleColor = [as attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:NULL];
    } else {
        title = titleObject;
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    
    if (titleColor) {
        @try {
            [action setValue:titleColor forKey:@"titleTextColor"];
        } @catch(id e) {}
    }
    
    [self.actions addObject:action];
}

- (UIAlertController *)presentInTopViewController {
    BOOL isAttTitle = [self.titleObject isKindOfClass:[NSAttributedString class]];
    BOOL isAttMessage = [self.messageObject isKindOfClass:[NSAttributedString class]];
    
    id title = isAttTitle? nil: [self.titleObject description];
    id message = isAttMessage? nil: [self.messageObject description];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:self.style];
    
    if (isAttTitle) {
        NSAttributedString *as = (NSAttributedString *)self.titleObject;
        @try {
            [alert setValue:as forKey:@"attributedTitle"];
        } @catch (id e) {
            alert.title = as.string;
        }
    }
    
    if (isAttMessage) {
        NSAttributedString *as = (NSAttributedString *)self.messageObject;
        @try {
            [alert setValue:as forKey:@"attributedMessage"];
        } @catch (id e) {
            alert.message = as.string;
        }
    }
    
    for (id action in self.actions) {
        [alert addAction:action];
    }
    
    if (self.tintObject) {
        alert.view.tintColor = self.tintObject;
    }
    
    UIViewController *topVC = [NERUtils getVisibleViewController];
    [topVC presentViewController:alert animated:YES completion:nil];
    return alert;
}

- (instancetype)initWithStyle:(UIAlertControllerStyle)style {
    self = [super init];
    self.style = style;
    return self;
}

@end

