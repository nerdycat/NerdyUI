//
//  UIView+NERFrame.h
//  NerdyUI
//
//  Created by nerdycat on 16/9/28.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XY(x, y)                CGPointMake(x, y)
#define WH(w, h)                CGSizeMake(w, h)
#define XYWH(x, y, w, h)        CGRectMake(x, y, w, h)
#define Range(s, l)             NSMakeRange(s, l)
#define Insets(...)             NER_NORMALIZE_INSETS(__VA_ARGS__)

/**
 * Easy access and update frame property.
 */
@interface UIView (NERFrame)

@property (nonatomic, assign) CGFloat x;        //frame.origin.x
@property (nonatomic, assign) CGFloat y;        //frame.origin.y
@property (nonatomic, assign) CGPoint xy;       //frame.origin

@property (nonatomic, assign) CGFloat w;        //frame.size.width
@property (nonatomic, assign) CGFloat h;        //frame.size.height
@property (nonatomic, assign) CGSize  wh;       //frame.size

@property (nonatomic, assign) CGFloat cx;       //center.x
@property (nonatomic, assign) CGFloat cy;       //center.y

@property (nonatomic, assign) CGFloat maxX;     //right of the view
@property (nonatomic, assign) CGFloat maxY;     //bottom of the view
@property (nonatomic, assign) CGPoint maxXY;    //right-bottom point if the view

@property (nonatomic, readonly) CGPoint midPoint;   //bounds center

@end



#define Screen  [UIScreen mainScreen]

@interface UIScreen (NERFrame)

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

//one pixel width, equals to 1 point / screen scale.
@property (nonatomic, readonly) CGFloat onePixel;

@end
