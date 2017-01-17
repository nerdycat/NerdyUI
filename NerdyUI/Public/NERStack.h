//
//  NERStack.h
//  NerdyUI
//
//  Created by nerdycat on 2016/11/1.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NERStackAlignmentLeading,
    NERStackAlignmentTop = NERStackAlignmentLeading,
    NERStackAlignmentCenter,
    NERStackAlignmentTrailing,
    NERStackAlignmentBotttom = NERStackAlignmentTrailing,
    NERStackAlignmentBaseline,
    NERStackAlignmentFirstBaseline,
} NERStackAlignment;


@interface NERStack : UIView

@property (nonatomic, assign) UILayoutConstraintAxis axis;
@property (nonatomic, assign) NERStackAlignment alignment;
@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, readonly) NSMutableArray *arrangedSubviews;

+ (instancetype)verticalStackWithItems:(NSArray *)items;
+ (instancetype)horizontalStackWithItems:(NSArray *)items;

- (void)addArrangedSubview:(id)view;
- (void)insertArrangedSubview:(id)view atIndex:(NSUInteger)stackIndex;

- (void)removeArrangedSubview:(UIView *)view;
- (void)removeArrangedSubviewAtIndex:(NSInteger)index;

@end


@interface NERStackSpring : UIView

@end





