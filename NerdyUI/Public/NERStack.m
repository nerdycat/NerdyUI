//
//  NERStack.m
//  NerdyUI
//
//  Created by nerdycat on 2016/11/1.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStack.h"
#import "NERDefs.h"
#import "NERPrivates.h"


#define SAFE_ADD(a, o)                  ({  id obj = o; \
                                        if (obj) [obj isKindOfClass:NSArray.class]? \
                                        [a addObjectsFromArray:obj]: \
                                        [a addObject:obj]; a;  })

#define ITEM_AT_INDEX(index)            (index < 0 || index >= (NSInteger)self.arrangedSubviews.count? \
                                        self:\
                                        self.arrangedSubviews[index])

#define MAKE_CON(i1, a1, r, i2, a2, p)  [self makeConstraint:i1 :NSLayoutAttribute##a1 \
                                        :NSLayoutRelation##r :i2 :NSLayoutAttribute##a2 :1 :0 :p]



@interface UIView (NERStack)

@property (nonatomic, strong) NSNumber *nerAttachSpace;

@end

@implementation UIView (NERStack)

NER_SYNTHESIZE(nerAttachSpace, setNerAttachSpace);

@end



@interface NERTransformLayer : CATransformLayer

@end

@implementation NERTransformLayer

- (void)setOpaque:(BOOL)opaque { }

@end



@interface NERStackSpring ()

@property (nonatomic, assign) UILayoutConstraintAxis axis;

@end



@interface NERStack ()

@property (nonatomic, strong) NSMutableArray *arrangedSubviews;

@property (nonatomic, strong) NSMutableArray *alignmentConstraints;
@property (nonatomic, strong) NSMutableArray *spacingConstraints;
@property (nonatomic, strong) NSMutableArray *enclosureConstraints;
@property (nonatomic, strong) NSMutableArray *springConstraints;

@property (nonatomic, strong) NSNumber *headAttachSpace;

@end


@implementation NERStack


#pragma mark- Override

- (void)setBackgroundColor:(UIColor *)backgroundColor { }
- (void)setOpaque:(BOOL)opaque { }
- (void)setClipsToBounds:(BOOL)clipsToBounds { }



#pragma mark- Accessors

- (void)setAlignment:(NERStackAlignment)alignment {
    if (_alignment != alignment) {
        _alignment = alignment;
        [self alignmentDidChange];
    }
}

- (void)setSpacing:(CGFloat)spacing {
    if (_spacing != spacing) {
        _spacing = spacing;
        [self spacingDidChange];
    }
}

- (void)setAxis:(UILayoutConstraintAxis)axis {
    if (_axis != axis) {
        _axis = axis;
        [self axisDidChange];
    }
}




#pragma mark- Public methods

- (void)addArrangedSubview:(id)view {
    [self insertArrangedSubview:view atIndex:self.arrangedSubviews.count];
}

- (void)insertArrangedSubview:(id)view atIndex:(NSUInteger)index {
    NSAssert(index <= self.arrangedSubviews.count, @"index out of bounds");
    
    if ([view isKindOfClass:NSNumber.class]) {
        CGFloat spacing = [view floatValue];
        
        if (index == 0) {
            self.headAttachSpace = @(spacing);
            [self attachSpaceDidChangeForViewAtIndex:-1];
        } else {
            UIView *previousView = self.arrangedSubviews[index - 1];
            previousView.nerAttachSpace = @(spacing);
            [self attachSpaceDidChangeForViewAtIndex:index - 1];
        }
        
    } else if ([view isKindOfClass:UIView.class]) {
        [self insertSubview:view atIndex:index];
        [self.arrangedSubviews insertObject:view atIndex:index];
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [view addObserver:self
               forKeyPath:@"hidden"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
        
        if (![view isHidden]) {
            [self addAndActivateConstraintsForViewAtIndex:index];
        }
    }
}

- (void)removeArrangedSubview:(UIView *)view {
    [view removeFromSuperview];
}

- (void)removeArrangedSubviewAtIndex:(NSInteger)index {
    UIView *item = ITEM_AT_INDEX(index);
    if (item != self) [item removeFromSuperview];
}





- (void)willRemoveSubview:(UIView *)subview {
    NSInteger index = [self.arrangedSubviews indexOfObject:subview];
    
    if (index != NSNotFound) {
        [self removeAndDeactivateConstraintsForViewAtIndex:index];
        [self.arrangedSubviews removeObjectAtIndex:index];
        [subview removeObserver:self forKeyPath:@"hidden" context:NULL];
        subview.nerAttachSpace = nil;
    }
    
    [super willRemoveSubview:subview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"hidden"]) {
        BOOL oldValue = [change[NSKeyValueChangeOldKey] boolValue];
        BOOL newValue = [change[NSKeyValueChangeNewKey] boolValue];
        
        if (oldValue != newValue) {
            NSInteger index = [self.arrangedSubviews indexOfObject:object];
            
            if (index != NSNotFound) {
                if (object.hidden) {
                    [self removeAndDeactivateConstraintsForViewAtIndex:index];
                } else {
                    [self addAndActivateConstraintsForViewAtIndex:index];
                }
            }
        }
    }
}



#pragma mark- Utils

- (void)alignmentDidChange {
    [self removeAndDeactivateAllAlignmentConstraints];
    [self addAndActivateAlignmentConstraintsForAll];
}

- (void)spacingDidChange {
    for (NSLayoutConstraint *c in self.spacingConstraints) {
        if (c.firstItem != self && c.secondItem != self) {
            if ([c.firstItem nerAttachSpace]) {
                c.constant = -[[c.firstItem nerAttachSpace] floatValue];
            } else {
                c.constant = -self.spacing;
            }
        }
    }
}

- (void)axisDidChange {
    [self removeAndDeactivateAllConstraints];
    [self addAndActivateConstraintsForAll];
}

- (NSInteger)previousVisibleViewIndexForIndex:(NSInteger)index {
    for (NSInteger i = index - 1; i >= 0; --i) {
        UIView *item = ITEM_AT_INDEX(i);
        if (!item.hidden) return i;
    }
    
    return -1;
}

- (NSInteger)nextVisibleViewIndexForIndex:(NSInteger)index {
    for (NSInteger i = index + 1; i < (NSInteger)self.arrangedSubviews.count; ++i) {
        UIView *item = ITEM_AT_INDEX(i);
        if (!item.hidden) return i;
    }
    
    return self.arrangedSubviews.count;
}




#pragma mark- Constriants

- (NSLayoutConstraint *)makeConstraint:(NSInteger)index1
                                      :(NSLayoutAttribute)att1
                                      :(NSLayoutRelation)relation
                                      :(NSInteger)index2
                                      :(NSLayoutAttribute)att2
                                      :(CGFloat)multiplier
                                      :(CGFloat)constant
                                      :(CGFloat)priority {
    
    UIView *item1 = ITEM_AT_INDEX(index1);
    UIView *item2 = ITEM_AT_INDEX(index2);
    
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:item1
                                                         attribute:att1
                                                         relatedBy:relation
                                                            toItem:item2
                                                         attribute:att2
                                                        multiplier:multiplier
                                                          constant:constant];
    c.priority = priority;
    
    return c;
}

- (void)addAndActivateConstraintsForAll {
    [self addAndActivateAlignmentConstraintsForAll];
    [self addAndActivateSpacingConstraintsForAll];
    [self addAndActivateEnclosureConstraintsForAll];
    
    for (int i = 0; i < self.arrangedSubviews.count; ++i) {
        id item = self.arrangedSubviews[i];
        if ([item isKindOfClass:[NERStackSpring class]]) {
            NERStackSpring *spring = (NERStackSpring *)item;
            spring.axis = self.axis;
            [self addAndActivateSpringConstraintsForSpringAtIndex:i];
        }
    }
}

- (void)addAndActivateConstraintsForViewAtIndex:(NSInteger)index {
    if ([ITEM_AT_INDEX(index) isHidden]) {
        return;
    }
    
    NSMutableArray *oldConstriants = [NSMutableArray array];
    NSMutableArray *newConstraints = [NSMutableArray array];
    
    NSInteger previousIndex = [self previousVisibleViewIndexForIndex:index];
    NSInteger nextIndex = [self nextVisibleViewIndexForIndex:index];
    
    SAFE_ADD(newConstraints, [self addAlignmentConstraintForIndex:index]);
    SAFE_ADD(newConstraints, [self addEnclosureConstraintsForIndex:index]);
    
    SAFE_ADD(oldConstriants, [self removeSpacingConstraintBetweenIndex1:previousIndex index2:nextIndex]);
    SAFE_ADD(newConstraints, [self addSpacingConstraintBetweenIndex1:previousIndex index2:index]);
    SAFE_ADD(newConstraints, [self addSpacingConstraintBetweenIndex1:index index2:nextIndex]);
    
    [NSLayoutConstraint deactivateConstraints:oldConstriants];
    [NSLayoutConstraint activateConstraints:newConstraints];
    
    UIView *item = ITEM_AT_INDEX(index);
    if ([item isKindOfClass:NERStackSpring.class]) {
        ((NERStackSpring *)item).axis = self.axis;
        [self addAndActivateSpringConstraintsForSpringAtIndex:index];
    }
}

- (void)removeAndDeactivateAllConstraints {
    [self removeAndDeactivateAllAlignmentConstraints];
    [self removeAndDeactivateAllEnclosureConstraints];
    [self removeAndDeactivateAllSpacingConstraints];
    [self removeAndDeactivateAllSpringsConstriants];
}

- (void)removeAndDeactivateConstraintsForViewAtIndex:(NSInteger)index {
    NSMutableArray *oldConstraints = [NSMutableArray array];
    SAFE_ADD(oldConstraints, [self removeAlignmentConstriantForIndex:index]);
    SAFE_ADD(oldConstraints, [self removeEnclosureConstriantsForIndex:index]);
    [NSLayoutConstraint deactivateConstraints:oldConstraints];
    
    [self removeAndRebuildSpacingConstriantsForIndex:index];
    [self removeAndDeactivateSpringConstriantsForSpringAtIndex:index];
}




#pragma mark- Alignment

- (void)addAndActivateAlignmentConstraintsForAll {
    for (int i = 0; i < self.arrangedSubviews.count; ++i) {
        if (![self.arrangedSubviews[i] isHidden]) {
            [self addAlignmentConstraintForIndex:i];
        }
    }
    
    [NSLayoutConstraint activateConstraints:self.alignmentConstraints];
}

- (NSLayoutConstraint *)addAlignmentConstraintForIndex:(NSInteger)index {
    NSLayoutAttribute att = 0;
    
    if (self.axis == UILayoutConstraintAxisVertical) {
        if (self.alignment == NERStackAlignmentLeading) att = NSLayoutAttributeLeading;
        if (self.alignment == NERStackAlignmentTrailing) att = NSLayoutAttributeTrailing;
        if (self.alignment == NERStackAlignmentCenter) att = NSLayoutAttributeCenterX;
    } else {
        if (self.alignment == NERStackAlignmentTop) att = NSLayoutAttributeTop;
        if (self.alignment == NERStackAlignmentBotttom) att = NSLayoutAttributeBottom;
        if (self.alignment == NERStackAlignmentCenter) att = NSLayoutAttributeCenterY;
        if (self.alignment == NERStackAlignmentFirstBaseline) att = NSLayoutAttributeFirstBaseline;
        if (self.alignment == NERStackAlignmentBaseline) att = NSLayoutAttributeLastBaseline;
    }
    
    id c = [self makeConstraint:index :att :NSLayoutRelationEqual :-1 :att :1 :0 :1000];
    [self.alignmentConstraints addObject:c];
    return c;
}

- (void)removeAndDeactivateAllAlignmentConstraints {
    [NSLayoutConstraint deactivateConstraints:self.alignmentConstraints];
    [self.alignmentConstraints removeAllObjects];
}

- (NSLayoutConstraint *)removeAlignmentConstriantForIndex:(NSInteger)index {
    id item = ITEM_AT_INDEX(index);
    
    if (item != self) {
        for (NSLayoutConstraint *c in self.alignmentConstraints) {
            if (c.firstItem == item || c.secondItem == item) {
                [self.alignmentConstraints removeObject:c];
                return c;
            }
        }
    }
    
    return nil;
}




#pragma mark- Enclosure

- (void)addAndActivateEnclosureConstraintsForAll {
    for (int i = 0; i < self.arrangedSubviews.count; ++i) {
        if (![self.arrangedSubviews[i] isHidden]) {
            [self addEnclosureConstraintsForIndex:i];
        }
    }
    
    [NSLayoutConstraint activateConstraints:self.enclosureConstraints];
}

- (NSArray *)addEnclosureConstraintsForIndex:(NSInteger)index {
    NSMutableArray *newConstraints = [NSMutableArray array];
    
    if (self.axis == UILayoutConstraintAxisVertical) {
        SAFE_ADD(newConstraints, MAKE_CON(index, Leading, Equal, -1, Leading, 200));
        SAFE_ADD(newConstraints, MAKE_CON(index, Leading, GreaterThanOrEqual, -1, Leading, 1000));
        SAFE_ADD(newConstraints, MAKE_CON(index, Trailing, Equal, -1, Trailing, 200));
        SAFE_ADD(newConstraints, MAKE_CON(index, Trailing, LessThanOrEqual, -1, Trailing, 1000));
    } else {
        SAFE_ADD(newConstraints, MAKE_CON(index, Top, Equal, -1, Top, 200));
        SAFE_ADD(newConstraints, MAKE_CON(index, Top, GreaterThanOrEqual, -1, Top, 1000));
        SAFE_ADD(newConstraints, MAKE_CON(index, Bottom, Equal, -1, Bottom, 200));
        SAFE_ADD(newConstraints, MAKE_CON(index, Bottom, LessThanOrEqual, -1, Bottom, 1000));
    }
    
    [self.enclosureConstraints addObjectsFromArray:newConstraints];
    return newConstraints;
}

- (void)removeAndDeactivateAllEnclosureConstraints {
    [NSLayoutConstraint deactivateConstraints:self.enclosureConstraints];
    [self.enclosureConstraints removeAllObjects];
}

- (NSArray *)removeEnclosureConstriantsForIndex:(NSInteger)index {
    id item = ITEM_AT_INDEX(index);
    NSMutableArray *oldConstriants = [NSMutableArray array];
    
    for (NSInteger i = self.enclosureConstraints.count - 1; i >= 0; --i) {
        NSLayoutConstraint *c = self.enclosureConstraints[i];
        if (c.firstItem == item || c.secondItem == item) {
            SAFE_ADD(oldConstriants, c);
            [self.enclosureConstraints removeObjectAtIndex:i];
        }
    }
    
    return oldConstriants;
}



#pragma mark- Spacing

- (void)addAndActivateSpacingConstraintsForAll {
    if (self.arrangedSubviews.count) {
        NSInteger index1 = -1;
        
        while (index1 < (NSInteger)self.arrangedSubviews.count) {
            NSInteger index2 = [self nextVisibleViewIndexForIndex:index1];
            [self addSpacingConstraintBetweenIndex1:index1 index2:index2];
            index1 = index2;
        }
        
        [NSLayoutConstraint activateConstraints:self.spacingConstraints];
    }
}

- (NSLayoutConstraint *)addSpacingConstraintBetweenIndex1:(NSInteger)index1 index2:(NSInteger)index2 {
    UIView *item1 = ITEM_AT_INDEX(index1);
    UIView *item2 = ITEM_AT_INDEX(index2);
    
    if (item1 == item2) return nil;
    
    NSLayoutAttribute att1 = 0, att2 = 0;
    
    if (self.axis == UILayoutConstraintAxisVertical) {
        att1 = (item1 == self? NSLayoutAttributeTop: NSLayoutAttributeBottom);
        att2 = (item2 != self? NSLayoutAttributeTop: NSLayoutAttributeBottom);
    } else {
        att1 = (item1 == self? NSLayoutAttributeLeading: NSLayoutAttributeTrailing);
        att2 = (item2 != self? NSLayoutAttributeLeading: NSLayoutAttributeTrailing);
    }
    
    CGFloat spacing = 0;
    if (item1 == self && self.headAttachSpace) {
        spacing = -[self.headAttachSpace floatValue];
    } else if (item1.nerAttachSpace) {
        spacing = -[item1.nerAttachSpace floatValue];
    } else if (item1 != self && item2 != self) {
        spacing = -self.spacing;
    }
    
    id c = [self makeConstraint:index1 :att1 :NSLayoutRelationEqual :index2 :att2 :1 :spacing :1000];
    [self.spacingConstraints addObject:c];
    return c;
}

- (void)removeAndDeactivateAllSpacingConstraints {
    [NSLayoutConstraint deactivateConstraints:self.spacingConstraints];
    [self.spacingConstraints removeAllObjects];
}

- (NSLayoutConstraint *)removeSpacingConstraintBetweenIndex1:(NSInteger)index1 index2:(NSInteger)index2 {
    id item1 = ITEM_AT_INDEX(index1);
    id item2 = ITEM_AT_INDEX(index2);
    
    for (NSLayoutConstraint *c in self.spacingConstraints) {
        if ((c.firstItem == item1 && c.secondItem == item2)) {
            [self.spacingConstraints removeObject:c];
            return c;
        }
    }
    
    return nil;
}

- (void)removeAndRebuildSpacingConstriantsForIndex:(NSInteger)index {
    NSMutableArray *oldConstriants = [NSMutableArray array];
    NSMutableArray *newConstraints = [NSMutableArray array];
    
    NSInteger previousIndex = [self previousVisibleViewIndexForIndex:index];
    NSInteger nextIndex = [self nextVisibleViewIndexForIndex:index];
    
    SAFE_ADD(oldConstriants, [self removeSpacingConstraintBetweenIndex1:previousIndex index2:index]);
    SAFE_ADD(oldConstriants, [self removeSpacingConstraintBetweenIndex1:index index2:nextIndex]);
    
    if (oldConstriants.count) {
        SAFE_ADD(newConstraints, [self addSpacingConstraintBetweenIndex1:previousIndex index2:nextIndex]);
    }
    
    [NSLayoutConstraint deactivateConstraints:oldConstriants];
    [NSLayoutConstraint activateConstraints:newConstraints];
}


- (void)attachSpaceDidChangeForViewAtIndex:(NSInteger)index {
    UIView *item1 = ITEM_AT_INDEX(index);
    UIView *item2 = ITEM_AT_INDEX(index + 1);
    
    for (NSLayoutConstraint *c in self.spacingConstraints) {
        if (c.firstItem == item1 && c.secondItem == item2) {
            if (item1 == self && self.headAttachSpace) {
                c.constant = -[self.headAttachSpace floatValue];
                break;
            } else if (item1.nerAttachSpace) {
                c.constant = -[item1.nerAttachSpace floatValue];
                break;
            }
        }
    }
}


#pragma mark- Spacing

- (void)addAndActivateSpringConstraintsForSpringAtIndex:(NSInteger)index {
    for (int i = 0; i < self.arrangedSubviews.count; ++i) {
        UIView *sv = self.arrangedSubviews[i];
        
        if ([sv isKindOfClass:NERStackSpring.class] && i != index) {
            NSLayoutAttribute att = (self.axis == UILayoutConstraintAxisVertical?
                                     NSLayoutAttributeHeight:
                                     NSLayoutAttributeWidth);
            
            NSLayoutConstraint *c = [self makeConstraint:i :att :NSLayoutRelationEqual :index :att :1 :0 :1000];
            [self.springConstraints addObject:c];
            c.active = YES;
        }
    }
}

- (void)removeAndDeactivateSpringConstriantsForSpringAtIndex:(NSInteger)index {
    id item = ITEM_AT_INDEX(index);
    
    for (int i = (int)self.springConstraints.count - 1; i >= 0; --i) {
        NSLayoutConstraint *c = self.springConstraints[i];
        if (c.firstItem == item || c.secondItem == item) {
            c.active = NO;
            [self.springConstraints removeObject:c];
        }
    }
}

- (void)removeAndDeactivateAllSpringsConstriants {
    [NSLayoutConstraint deactivateConstraints:self.springConstraints];
    [self.springConstraints removeAllObjects];
}



#pragma mark - Lifecycle

- (CGSize)sizeThatFits:(CGSize)size {
    return [self ner_fittingSize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.arrangedSubviews = [NSMutableArray array];
    self.alignmentConstraints = [NSMutableArray array];
    self.spacingConstraints = [NSMutableArray array];
    self.enclosureConstraints = [NSMutableArray array];
    self.springConstraints = [NSMutableArray array];
    return self;
}

+ (instancetype)verticalStackWithItems:(NSArray *)items {
    NERStack *stack = [NERStack new];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = NERStackAlignmentLeading;
    
    for (id item in items) {
        [stack addArrangedSubview:item];
    }
    return stack;
}

+ (instancetype)horizontalStackWithItems:(NSArray *)items {
    NERStack *stack = [NERStack new];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.alignment = NERStackAlignmentCenter;
    
    for (id item in items) {
        [stack addArrangedSubview:item];
    }
    return stack;
}

+ (Class)layerClass {
    return [NERTransformLayer class];
}

@end






@implementation NERStackSpring

#pragma mark- Override

- (void)setBackgroundColor:(UIColor *)backgroundColor { }
- (void)setOpaque:(BOOL)opaque { }
- (void)setClipsToBounds:(BOOL)clipsToBounds { }


#pragma mark- Normal

- (instancetype)init {
    self = [super init];
    self.userInteractionEnabled = NO;
    [self updateContentPriprities];
    return self;
}

- (void)updateContentPriprities {
    BOOL isHorizontal = (self.axis == UILayoutConstraintAxisHorizontal);
    CGFloat horPriority = isHorizontal? 1: 1000;
    CGFloat verPriority = isHorizontal? 1000: 1;
    
    [self setContentHuggingPriority:horPriority forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:verPriority forAxis:UILayoutConstraintAxisVertical];
    [self setContentCompressionResistancePriority:horPriority forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentCompressionResistancePriority:verPriority forAxis:UILayoutConstraintAxisVertical];
}

- (void)setAxis:(UILayoutConstraintAxis)axis {
    if (_axis != axis) {
        _axis = axis;
        [self updateContentPriprities];
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeZero;
}

+ (Class)layerClass {
    return [NERTransformLayer class];
}

@end






