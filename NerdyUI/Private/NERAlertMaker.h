//
//  NERAlertMaker.h
//  NerdyUI
//
//  Created by nerdycat on 2016/10/31.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NERAlertMaker : NSObject

- (__nullable instancetype)initWithStyle:(UIAlertControllerStyle)style;

- (void)addActionWithStyle:(UIAlertActionStyle)style
                     title:(__nullable id)titleObject
                   handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

- (UIAlertController * _Nonnull )presentInTopViewController;

@end
