//
//  NSArray+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/12/5.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NERChainable)


/**
 * Execute a provided method or block once per array element.
 * Argument can be:
    1) method name
    2) A block
 
 * Block arguments:
    1) value: The current element being processed in the array. Can either be object or primitive.
    2) index: The index of the current element being processed in the array. Optional.
    3) array: The array map was called upon. Optional.
 
 * Usages:
    subviews.forEach(@"removeFromSuperview");
    subviews.forEach(^(UIView *view) {
        [view removeFromSuperview];
    };
 */
- (NSArray *(^)(id))forEach;


/**
 * Creates a new array with the results of calling a provided block on every element in this array.
 * Block arguments:
   1) value: The current element being processed in the array. Can either be object or primitive.
   2) index: The index of the current element being processed in the array. Optional.
   3) array: The array map was called upon. Optional.
 
 * Usages:
   @[@"a", @"b", @"c"].map(^(NSString *text) {
       return [text uppercaseString];
   });
 
   @[@1, @2, @3].map(^(int n, int index) {
       return [NSString stringWithFormat:@"%d * %d = %d", n, index, n * index];
   });
 */
- (NSArray *(^)(id))map;


/**
 * Creates a new array with all elements that pass the test implemented by the provided block.
 * Block arguments:
   1) value: The current element being processed in the array. Can either be object or primitive.
   2) index: The index of the current element being processed in the array. Optional.
   3) array: The array filter was called upon. Optional.
 
 * Usages:
   @[@1.1, @2.2, @3.3, @4, @5].filter(^(CGFloat value) {
       return value > 3;
   });
 */
- (NSArray *(^)(id))filter;


/**
 * Applies a block against an accumulator and each value of the array to reduce it to a single value.
   1. initialValue
   Value to use as the first argument to the first call of the block. Can only be Object. Optional.
 
   2. Block arguments:
   1) accumulator: The accumulated value previously returned in the last invocation of the callback.
   2) value: The current element being processed in the array. Can either be object or primitive.
   3) index: The index of the current element being processed in the array. Optional.
   4) array: The array reduce was called upon. Optional.
 
 * Note: accumulator and value are required to have the same type.
 
 * Usages:
   @[@1, @2, @3, @4, @5].reduce(^(int accumulator, int value) {
      return accumulator * value;
   });
 
   //with initialValue
   @[@"a", @"hello", @"greeting"].reduce(@0, ^(NSNumber *totalLength, NSString *text) {
      return [totalLength integerValue] + text.length;
   });
 */
- (id (^)(id, ...))reduce;

@end

