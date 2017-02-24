//
//  NERConstraintMaker.h
//  NerdyUI
//
//  Created by nerdycat on 2016/10/10.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NERConstraint : NSObject

/*
 Use methods to prevent pulluting auto-completion.
 */

- (instancetype)initWithFirstItem:(UIView *)firstItem;
- (instancetype)saveConstraintsAndReset:(id)null;

- (UIView *)getFirstItem:(id)null;
- (void)addLayoutAttribute:(NSLayoutAttribute)attribute;

- (void)updateSecondItem:(UIView *)item;
- (void)updateRelation:(NSLayoutRelation)relation;
- (void)updateMultipliers:(NSArray *)multipliers;
- (void)updateConstants:(NSArray *)array;
- (void)updateIdentifier:(NSString *)identifier;
- (void)updatePriority:(CGFloat)priority;

- (NSArray *)makeConstraints:(id)null;
- (NSArray *)remakeConstraints:(id)null;
- (NSArray *)updateConstraints:(id)null;

@end




@interface NERConstraintMaker : NSObject

- (instancetype)initWithFirstItem:(UIView *)firstItem;

- (NERConstraint *)makeNERConstraintWithAttribute:(NSLayoutAttribute)attribute;

- (void)makeConstraints:(id)null;
- (void)remakeConstraints:(id)null;
- (void)updateConstraints:(id)null;

@end
