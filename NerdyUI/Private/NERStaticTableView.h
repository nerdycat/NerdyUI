//
//  NERStaticTableView.h
//  NerdyUI
//
//  Created by admin on 2016/11/9.
//  Copyright © 2016年 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NERStaticSectionCheckStyleNone,
    NERStaticSectionCheckStyleSingle,
    NERStaticSectionCheckStyleMultiply,
} NERStaticSectionCheckStyle;


@interface NERStaticTableView : UITableView

+ (instancetype)plainStyleWithSections:(NSArray *)sections;
+ (instancetype)groupedStyleWithSections:(NSArray *)sections;

- (NSArray *)checkedIndexPaths;

@end



@interface NERStaticSection : NSObject

+ (instancetype)sectionWithRows:(NSArray *)rows;

@end



@interface NERStaticRow : NSObject

@end
