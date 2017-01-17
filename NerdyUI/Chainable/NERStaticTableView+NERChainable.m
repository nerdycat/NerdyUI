//
//  NERStaticTableView+NERChainable.m
//  NerdyUI
//
//  Created by nerdycat on 2016/11/9.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStaticTableView+NERChainable.h"
#import "UIColor+NERChainable.h"
#import "UIFont+NERChainable.h"
#import "UIView+NERChainable.h"
#import "UIImage+NERChainable.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"


@implementation NERStaticTableView (NERChainable)

- (NERChainableNERStaticTableViewObjectBlock)fnt {
    NER_OBJECT_BLOCK([self setValue:Fnt(value) forKey:@"textFont"]);
}

- (NERChainableNERStaticTableViewObjectBlock)color {
    NER_OBJECT_BLOCK([self setValue:Color(value) forKey:@"textColor"]);
}

- (NERChainableNERStaticTableViewObjectBlock)detailFnt {
    NER_OBJECT_BLOCK([self setValue:Fnt(value) forKey:@"detailTextFont"]);
}

- (NERChainableNERStaticTableViewObjectBlock)detailColor {
    NER_OBJECT_BLOCK([self setValue:Color(value) forKey:@"detailTextColor"]);
}

- (NERChainableNERStaticTableViewFloatBlock)cellHeight {
    NER_FLOAT_BLOCK([self setValue:@(value) forKey:@"cellHeightNumber"]);
}

- (NERChainableNERStaticTableViewFloatBlock)separatorLeftInset {
    NER_FLOAT_BLOCK(
                    UIEdgeInsets insets = UIEdgeInsetsMake(0, value, 0, 0);
                    [self setValue:[NSValue valueWithUIEdgeInsets:insets] forKey:@"lineInsets"];
                    );
}

- (NERChainableNERStaticTableViewFloatBlock)groupGap {
    NER_FLOAT_BLOCK(
                    if (self.style == UITableViewStyleGrouped) {
                        [self setValue:@(value) forKey:@"groupSpacingNumber"];
                    }
                    );
}

- (NERChainableNERStaticTableViewBlockBlock)configRow {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"configRowBlock"]);
}

- (NERChainableNERStaticTableViewBlockBlock)configCell {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"configCellBlock"]);
}

- (NERChainableNERStaticTableViewObjectBlock)styles {
    NER_OBJECT_BLOCK([NERUtils applyStyleObject:value toItem:self];);
}

- (NERChainableNERStaticTableViewObjectBlock)tint {
    NER_OBJECT_BLOCK(self.tintColor = Color(value));
}

- (NERChainableNERStaticTableViewObjectBlock)header {
    NER_OBJECT_BLOCK(
                     if ([value isKindOfClass:UIView.class]) {
                         self.tableHeaderView = value;
                     } else if ([value isKindOfClass:NSNumber.class]) {
                         self.tableHeaderView = View.h([value floatValue]).bgColor(@"clear");
                     }
                     );
}

- (NERChainableNERStaticTableViewObjectBlock)footer {
    NER_OBJECT_BLOCK(
                     if ([value isKindOfClass:UIView.class]) {
                         self.tableFooterView = value;
                     } else if ([value isKindOfClass:NSNumber.class]) {
                         self.tableFooterView = View.h([value floatValue]).bgColor(@"clear");
                     }
                     );
}

@end



@implementation NERStaticSection (NERChainable)

- (NERChainableNERStaticSectionObjectBlock)header {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"headerObject"]);
}

- (NERChainableNERStaticSectionObjectBlock)footer {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"footerObject"]);
}

- (instancetype)singleCheck {
    [self setValue:@(NERStaticSectionCheckStyleSingle) forKey:@"checkStyle"];
    return self;
}

- (instancetype)multiCheck {
    [self setValue:@(NERStaticSectionCheckStyleMultiply) forKey:@"checkStyle"];
    return self;
}

@end



@implementation NERStaticRow (NERChainable)

- (NERChainableNERStaticRowObjectBlock)img {
    NER_OBJECT_BLOCK([self setValue:Img(value) forKey:@"image"]);
}

- (NERChainableNERStaticRowObjectBlock)str {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"text"]);
}

- (NERChainableNERStaticRowObjectBlock)fnt {
    NER_OBJECT_BLOCK([self setValue:Fnt(value) forKey:@"textFont"]);
}

- (NERChainableNERStaticRowObjectBlock)color {
    NER_OBJECT_BLOCK([self setValue:Color(value) forKey:@"textColor"]);
}

- (NERChainableNERStaticRowObjectBlock)detailStr {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"detailText"]);
}

- (NERChainableNERStaticRowObjectBlock)detailFnt {
    NER_OBJECT_BLOCK([self setValue:Fnt(value) forKey:@"detailTextFont"]);
}

- (NERChainableNERStaticRowObjectBlock)detailColor {
    NER_OBJECT_BLOCK([self setValue:Color(value) forKey:@"detailTextColor"]);
}

- (NERChainableNERStaticRowFloatBlock)cellHeight {
    NER_FLOAT_BLOCK([self setValue:@(value) forKey:@"cellHeightNumber"]);
}

- (NERChainableNERStaticRowFloatBlock)separatorLeftInset {
    NER_FLOAT_BLOCK(
                    UIEdgeInsets insets = UIEdgeInsetsMake(0, value, 0, 0);
                    [self setValue:[NSValue valueWithUIEdgeInsets:insets] forKey:@"lineInsets"];
    );
}

- (NERChainableNERStaticRowCallbackBlock)onClick {
    NER_CALLBACK_BLOCK(
                       if (NER_IS_BLOCK(object)) {
                           [self setValue:object forKey:@"selectionBlock"];
                           
                       } else {
                           id block = ^{
                               SEL action = NSSelectorFromString(object);
                               [weakTarget performSelector:action withObject:nil];
                           };
                           
                           [self setValue:block forKey:@"selectionBlock"];
                       }
                       );
}

- (NERChainableNERStaticRowObjectBlock)accessory {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"accessoryView"]);
}

- (NERChainableNERStaticRowBoolBlock)check {
    NER_INT_BLOCK(
                  id n = @(value? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone);
                  [self setValue:n forKey:@"accessoryType"];
                  );
}

- (NERChainableNERStaticRowObjectBlock)custom {
    NER_OBJECT_BLOCK([self setValue:value forKey:@"cellObject"]);
}

- (NERChainableNERStaticRowObjectBlock)styles {
    NER_OBJECT_BLOCK([NERUtils applyStyleObject:value toItem:self];);
}

- (instancetype)cellHeightAuto {
    self.cellHeight(UITableViewAutomaticDimension);
    return self;
}

- (instancetype)subtitleStyle {
    [self setValue:@(UITableViewCellStyleSubtitle) forKey:@"style"];
    return self;
}

- (instancetype)value2Style {
    [self setValue:@(UITableViewCellStyleValue2) forKey:@"style"];
    return self;
}

- (instancetype)disclosure {
    [self setValue:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    return self;
}

@end
