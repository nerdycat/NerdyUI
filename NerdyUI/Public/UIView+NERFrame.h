//
//  UIView+NERFrame.h
//  NerdyUI
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NERFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@property (nonatomic, assign) CGFloat cx;
@property (nonatomic, assign) CGFloat cy;

@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGPoint maxPoint;

//bounds center
@property (nonatomic, assign, readonly) CGPoint middle;

@end



#define Screen [UIScreen mainScreen]

@interface UIScreen (NERFrame)

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

@property (nonatomic, readonly) CGFloat onePixel;

@end
