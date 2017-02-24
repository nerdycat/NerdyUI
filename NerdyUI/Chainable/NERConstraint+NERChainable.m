//
//  NERConstraint+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/10/10.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERConstraint+NERChainable.h"
#import "NERUtils.h"


#define SYNTHESIZE_CONSTRAINT_PROP(x, y)\
- (instancetype)x {\
    [self addLayoutAttribute:NSLayoutAttribute##y];\
    return self;\
}

@implementation NERConstraint (NERChainable)

SYNTHESIZE_CONSTRAINT_PROP(left, Left);
SYNTHESIZE_CONSTRAINT_PROP(right, Right);
SYNTHESIZE_CONSTRAINT_PROP(top, Top);
SYNTHESIZE_CONSTRAINT_PROP(bottom, Bottom);
SYNTHESIZE_CONSTRAINT_PROP(leading, Leading);
SYNTHESIZE_CONSTRAINT_PROP(trailing, Trailing);
SYNTHESIZE_CONSTRAINT_PROP(width, Width);
SYNTHESIZE_CONSTRAINT_PROP(height, Height);
SYNTHESIZE_CONSTRAINT_PROP(centerX, CenterX);
SYNTHESIZE_CONSTRAINT_PROP(centerY, CenterY);
SYNTHESIZE_CONSTRAINT_PROP(baseline, Baseline);
SYNTHESIZE_CONSTRAINT_PROP(firstBaseline, FirstBaseline);
SYNTHESIZE_CONSTRAINT_PROP(leftMargin, LeftMargin);
SYNTHESIZE_CONSTRAINT_PROP(rightMargin, RightMargin);
SYNTHESIZE_CONSTRAINT_PROP(topMargin, TopMargin);
SYNTHESIZE_CONSTRAINT_PROP(bottomMargin, BottomMargin);
SYNTHESIZE_CONSTRAINT_PROP(leadingMargin, LeadingMargin);
SYNTHESIZE_CONSTRAINT_PROP(trailingMargin, TrailingMargin);
SYNTHESIZE_CONSTRAINT_PROP(centerXWithinMargins, CenterXWithinMargins);
SYNTHESIZE_CONSTRAINT_PROP(centerYWithinMargins, CenterYWithinMargins);

- (instancetype)center {
    return self.centerX.centerY;
}

- (instancetype)size {
    return self.width.height;
}

- (instancetype)edge {
    return self.top.left.bottom.right;
}


- (NERChainableNERConstraintFloatListBlock)multipliers {
    NER_FLOAT_LIST_BLOCK([self updateMultipliers:[NERUtils numberArrayFromFLoatList:value]]);
}

- (NERChainableNERConstraintFloatListBlock)constants {
    NER_FLOAT_LIST_BLOCK([self updateConstants:[NERUtils numberArrayFromFLoatList:value]]);
}

- (NERChainableNERConstraintFloatBlock)priority {
    NER_FLOAT_BLOCK([self updatePriority:value]);
}

- (NERChainableNERConstraintObjectBlock)identifier {
    NER_OBJECT_BLOCK([self updateIdentifier:value]);
}

- (NERChainableNERConstraintObjectBlock)view {
    NER_OBJECT_BLOCK([self updateSecondItem:value]);
}

- (instancetype)self {
    [self updateSecondItem:[self getFirstItem:nil]];
    return self;
}

- (instancetype)superview {
    [self updateSecondItem:[self getFirstItem:nil].superview];
    return self;
}

- (instancetype)equal {
    [self updateRelation:NSLayoutRelationEqual];
    return self;
}

- (instancetype)lessEqual {
    [self updateRelation:NSLayoutRelationLessThanOrEqual];
    return self;
}

- (instancetype)greaterEqual {
    [self updateRelation:NSLayoutRelationGreaterThanOrEqual];
    return self;
}

- (instancetype)And {
    return [self saveConstraintsAndReset:nil];
}

- (void (^)())End {
    return ^{};
}

- (NSArray *(^)())make {
    return ^{
        return [self makeConstraints:nil];
    };
}

- (NSArray *(^)())remake {
    return ^{
        return [self remakeConstraints:nil];
    };
}

- (NSArray *(^)())update {
    return ^{
        return [self updateConstraints:nil];
    };
}

@end





#define SYNTHESIZE_MAKER_PROP(x, y)\
- (NERConstraint *)x {\
    return [self makeNERConstraintWithAttribute:NSLayoutAttribute##y];\
}

@implementation NERConstraintMaker (NERChainable)

SYNTHESIZE_MAKER_PROP(left, Left);
SYNTHESIZE_MAKER_PROP(right, Right);
SYNTHESIZE_MAKER_PROP(top, Top);
SYNTHESIZE_MAKER_PROP(bottom, Bottom);
SYNTHESIZE_MAKER_PROP(leading, Leading);
SYNTHESIZE_MAKER_PROP(trailing, Trailing);
SYNTHESIZE_MAKER_PROP(width, Width);
SYNTHESIZE_MAKER_PROP(height, Height);
SYNTHESIZE_MAKER_PROP(centerX, CenterX);
SYNTHESIZE_MAKER_PROP(centerY, CenterY);
SYNTHESIZE_MAKER_PROP(baseline, Baseline);
SYNTHESIZE_MAKER_PROP(firstBaseline, FirstBaseline);
SYNTHESIZE_MAKER_PROP(leftMargin, LeftMargin);
SYNTHESIZE_MAKER_PROP(rightMargin, RightMargin);
SYNTHESIZE_MAKER_PROP(topMargin, TopMargin);
SYNTHESIZE_MAKER_PROP(bottomMargin, BottomMargin);
SYNTHESIZE_MAKER_PROP(leadingMargin, LeadingMargin);
SYNTHESIZE_MAKER_PROP(trailingMargin, TrailingMargin);
SYNTHESIZE_MAKER_PROP(centerXWithinMargins, CenterXWithinMargins);
SYNTHESIZE_MAKER_PROP(centerYWithinMargins, CenterYWithinMargins);

- (NERConstraint *)center {
    return self.centerX.centerY;
}

- (NERConstraint *)size {
    return self.width.height;
}

- (NERConstraint *)edge {
    return self.top.left.bottom.right;
}

@end






