//
//  NERStack+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/11/4.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStack.h"
#import "NERDefs.h"

/**
 * Horizontal Stack with items.
 * Each item is stack horizontally, from left to right with optional spacing.
 
 * There are two way to specify fix spacing:
    1) Use NSNumber for individual spacing between two items.
    2) Use .gap for spacing between all subviews.
   If set both, the NSNumber approach take precedence.
 
 * There is also a NERSpring object that will take as mush space if available. Just like a spring.
 
 * By embed NERStack into another stack, you are able to create a much more complicated UI.
 
 * Usages:
    HStack(view1, @5, view2, @10, view3)
    Hstack(view1, view2, view3).gap(5)
 */
#define HorStack(...)       [NERStack horizontalStackWithItems:@[__VA_ARGS__]]

/**
 * Vertical Stack with items.
 * Each item is stack vertically, from top to bottom with optional spacing.
 
 * Usages:
    VStack(view1, @5, view2, @10, view3)
    VStack(view1, view2, view3).gap(5)
 */
#define VerStack(...)       [NERStack verticalStackWithItems:@[__VA_ARGS__]]

/**
 * Unlike gap create a fix spacing, NERSpring carete an spacing that can shrink or expand.
 * All the NERSprings in the same Stack will take up the same spaces.
 * Usages: HStack(view1, NERSpring, view2, NERSpring, view3).embedIn(self.view);
 */
#define NERSpring           [NERStackSpring new]


@interface NERStack (NERChainable)

/**
 * Item spacing
 * Usages: .gap(10)
 */
NER_STACK_PROP(Float)       gap;

/**
 * Align items.
 
 * For HStack, the valid alignments are:
    .topAlignment
    .bottomAlignment
    .centerAlignment (default)
    .baselineAlignment
    .firstBaselineAlignment
 
 * For VStack, the valid alignments are:
    .leftAlignment (default)
    .rightAlignment
    .centerAlignment
 
 * Usages: .bottomAlignment
 */
- (instancetype)topAlignment;
- (instancetype)bottomAlignment;
- (instancetype)leftAlignment;
- (instancetype)rightAlignment;
- (instancetype)centerAlignment;
- (instancetype)baselineAlignment;
- (instancetype)firstBaselineAlignment;

@end
