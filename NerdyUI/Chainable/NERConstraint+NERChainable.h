//
//  NERConstraint+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/10/10.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERConstraintMaker.h"
#import "NERDefs.h"

/**
 * Making Constraints using a Masonry like syntax.
 * Usages:
    Constraint(view).width.height.equal.constants(100, 200).make();
    Constraint(view).top.left.equal.view(view2).make();
 
 * Another way of making constraints is:
    view.makeCons(^{
        make.width.height.equal.constants(100, 200);
        make.top.left.equal.view(view2);
    });
 
 * Like Masonry, you have to make sure view1 and view2 are in the same view hierarchy.
 */
#define Constraint(view1)       [[NERConstraint alloc] initWithFirstItem:view1]


@interface NERConstraint (NERChainable)

/**
 * Setting multiplier value, default: 1.
 * Can take multiply values if you are configure mulitply attributes at the same time.
 * Usages: .multiplier(0.5), .size.equal.view(view2).multiply(1, 2)
 */
NER_CONSTRAINT_PROP(FloatList)  multipliers;

/**
 * Setting constant value, default: 0.
 * Can take multiply values if you are configure mulitply attributes at the same time.
 * Usages: .width.equal.constants(10), .width.height.equal.constants(10, 20)
 */
NER_CONSTRAINT_PROP(FloatList)  constants;

/**
 * Second view
 * By default it is refer to first view's parent view.
 * Usages: 
    Constraint(view).left.equal.view(view.suerpview).constants(10).make();
    Constraint(view).left.equal.constants(10).make();       //same as above
 
    Constraint(view1).left.equal.view(view2).right.constants(20).make();
 */
NER_CONSTRAINT_PROP(Object)     view;

/**
 * Setting priority value, default: UILayoutPriorityRequired (1000).
 * Usages: .priority(900)
 */
NER_CONSTRAINT_PROP(Float)      priority;

/**
 * Setting identifier value.
 * Usages: .identifier(@"top constraint")
 */
NER_CONSTRAINT_PROP(Object)     identifier;

#define multipliers(...)        multipliers(NER_MAKE_FLOAT_LIST(__VA_ARGS__))
#define constants(...)          constants(NER_MAKE_FLOAT_LIST(__VA_ARGS__))


/**
 * Constraint attributes
 * If second view's attribute is equal to first view's attribute, it can be ignore eigher.
 * Usages:
    Constraint(view1).center.equal.view(view2).center.make();
    Constraint(view1).center.equal.view(view2).make();      //same as above
 
    Constraint(view).edge.equal.constants(10, 20, 30, 40).make();
 */
- (instancetype)left;                       //NSLayoutAttributeLeft
- (instancetype)right;                      //NSLayoutAttributeRight
- (instancetype)top;                        //NSLayoutAttributeTop
- (instancetype)bottom;                     //NSLayoutAttributeBottom
- (instancetype)leading;                    //NSLayoutAttributeLeading
- (instancetype)trailing;                   //NSLayoutAttributeTrailing
- (instancetype)width;                      //NSLayoutAttributeWidth
- (instancetype)height;                     //NSLayoutAttributeHeight
- (instancetype)centerX;                    //NSLayoutAttributeCenterX
- (instancetype)centerY;                    //NSLayoutAttributeCenterY
- (instancetype)baseline;                   //NSLayoutAttributeBaseline
- (instancetype)firstBaseline;              //NSLayoutAttributeFirstBaseline

- (instancetype)leftMargin;                 //NSLayoutAttributeLeftMargin
- (instancetype)rightMargin;                //NSLayoutAttributeRightMargin
- (instancetype)topMargin;                  //NSLayoutAttributeTopMargin
- (instancetype)bottomMargin;               //NSLayoutAttributeBottomMargin
- (instancetype)leadingMargin;              //NSLayoutAttributeLeadingMargin
- (instancetype)trailingMargin;             //NSLayoutAttributeTrailingMargin
- (instancetype)centerXWithinMargins;       //NSLayoutAttributeCenterXWithinMargins
- (instancetype)centerYWithinMargins;       //NSLayoutAttributeCenterYWithinMargins

- (instancetype)center;                     //shorthand for .centerX.centerY
- (instancetype)size;                       //shorthand for .width.height
- (instancetype)edge;                       //shorthand for .top.left.bottom.right


/**
 * Constraint relations
 * For equal relation, you don't even have to use equal, it's the default behavior.
 * Usages: 
    .width.equal.constants(50)
    .width.constants(50)        //same as above
 
    .width.greaterEqual.constants(50)
 */
- (instancetype)equal;                      //NSLayoutRelationEqual
- (instancetype)lessEqual;                  //NSLayoutRelationLessThanOrEqual
- (instancetype)greaterEqual;               //NSLayoutRelationGreaterThanOrEqual


/**
 * Shorthand for setting second view.
 * Because second view is refer to first view's suerpview by default,
   you use superview only if you want to make it explicitly.
 * Usages: 
    .width.equal.self.height.multiplier(0.5)
    .width.equal.superview.multiplier(0.5)
 */
- (instancetype)self;                       //shorthand for .view(view1)
- (instancetype)superview;                  //shorthand for .view(superview)


/**
 * Chain Constraint making process together.
 * Usages: Constraint(view).size.equal.constants(50, 100).And.center.equal.view(view2).make();
 */
- (instancetype)And;                        //chaining constraints making progress together.


/*
 * Use to suppress getter side effects warning. Optional.
 * Usages: make.left.top.equal.view(view).left.bottom.End();
 */
- (void(^)())End;


/**
 * Install constraints
 * You have to call make/remake/update in the end in order the install the constraints if you use Constraint() macro.
 * Usages:
    .width.constants(10).make();
    .width.constants(20).update();
    .width.equal.superview.remake();
 */
- (NSArray *(^)())make;                     //create constraints and activate.
- (NSArray *(^)())remake;                   //deactivate previous constraints and create new constraints.
- (NSArray *(^)())update;                   //update previous constraints and create new constraints if needed.

@end



/**
 * NERConstraintMaker support an Masonry like way of making constraints.
 * You can use make variable inside makeCons/updateCons/remakeCons without declare it.
 * Usages:
    view.makeCons(^{
        make.width.constants(10);
    });
    view.updateCons(^{
        make.width.constants(20);
    });
    view.remakeCons(^{
        make.width.equal.superview;
    });
 */

@interface NERConstraintMaker (NERChainable)

- (NERConstraint *)left;
- (NERConstraint *)right;
- (NERConstraint *)top;
- (NERConstraint *)bottom;
- (NERConstraint *)leading;
- (NERConstraint *)trailing;
- (NERConstraint *)width;
- (NERConstraint *)height;
- (NERConstraint *)centerX;
- (NERConstraint *)centerY;
- (NERConstraint *)baseline;
- (NERConstraint *)firstBaseline;

- (NERConstraint *)leftMargin;
- (NERConstraint *)rightMargin;
- (NERConstraint *)topMargin;
- (NERConstraint *)bottomMargin;
- (NERConstraint *)leadingMargin;
- (NERConstraint *)trailingMargin;
- (NERConstraint *)centerXWithinMargins;
- (NERConstraint *)centerYWithinMargins;

- (NERConstraint *)center;
- (NERConstraint *)size;
- (NERConstraint *)edge;

@end





