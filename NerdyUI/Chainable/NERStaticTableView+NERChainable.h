//
//  NERStaticTableView+NERChainable.h
//  NerdyUI
//
//  Created by nerdycat on 2016/11/9.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStaticTableView.h"
#import "NERDefs.h"

#define Row                 [NERStaticRow new]
#define Section(...)        [NERStaticSection sectionWithRows:@[__VA_ARGS__]]

#define PlainTV(...)        [NERStaticTableView plainStyleWithSections:@[__VA_ARGS__]]
#define GroupTV(...)        [NERStaticTableView groupedStyleWithSections:@[__VA_ARGS__]]

#define detailFnt(x)        detailFnt(NER_CONVERT_VALUE_TO_STRING(x))


@interface NERStaticTableView (NERChainable)

/**
 * default textLabel.font
 */
NER_STATIC_PROP(Object)     fnt;

/**
 * default textLabel.color
 */
NER_STATIC_PROP(Object)     color;

/**
 * default detailTextLabel.font
 */
NER_STATIC_PROP(Object)     detailFnt;

/**
 * default detailTextLabel.color
 */
NER_STATIC_PROP(Object)     detailColor;

/**
 * default cell height
 */
NER_STATIC_PROP(Float)      cellHeight;

/**
 * default separator left inset
 */
NER_STATIC_PROP(Float)      separatorLeftInset;

/**
 * section gap for GroupedTableView
 * Will change section header and section footer internally.
 */
NER_STATIC_PROP(Float)      groupGap;

/**
 * TableView header
 * Argument can be:
   1) UIView
   2) NSNumber for empty header with specific height.
 * Usages: .header(headerView), .header(@50)
 */
NER_STATIC_PROP(Object)     header;

/**
 * TableView footer
 * Argument can be:
   1) UIView
   2) NSNumber for empty footer with specific height.
 * Usages: .footer(headerView), .footer(@50)
 */
NER_STATIC_PROP(Object)     footer;

/**
 * Configure row before display on screen.
 * Usages: 
    .configRow(^(NERStaticRow *row, NSIndexPath *indexPath) {
        row.checked(indexPath.row == 3);
    });
 */
NER_STATIC_PROP(Block)      configRow;

/**
 * Configure cell before display on screen.
 * Usages:
    .configCell(^(UITableViewCell *cell, NSIndexPath *indexPath) {
        cell.textLabel.str(indexPath);
    });
 */
NER_STATIC_PROP(Block)      configCell;

/**
 * tintColor
 */
NER_STATIC_PROP(Object)     tint;

/**
 * Apply default sytles
 */
NER_STATIC_PROP(Object)     styles;

@end



@interface NERStaticSection (NERChainable)

/**
 * Section header
 * Argument can be:
   1) UIView
   2) NSNumber for empty header with specific height.
 * Usages: .header(headerView), .header(@50)
 */
NER_SECTION_PROP(Object)    header;

/**
 * Section footer
 * Argument can be:
   1) UIView
   2) NSNumber for empty footer with specific height.
 * Usages: .footer(footerView), .footer(@0)
 */
NER_SECTION_PROP(Object)    footer;

/**
 * Enable single check for rows in section.
 * You can get the checked indexPath with -checkedIndexPaths method inside NERStaticTableView class.
 */
- (instancetype)singleCheck;

/**
 * Enable multiply check for rows in section.
 * You can get the checked indexPaths with -checkedIndexPaths method inside NERStaticTableView class.
 */
- (instancetype)multiCheck;

@end



@interface NERStaticRow (NERChainable)

/**
 * imageView.image
 */
NER_ROW_PROP(Object)        img;

/**
 * textLabel.text
 */
NER_ROW_PROP(Object)        str;

/**
 * textLabel.font
 */
NER_ROW_PROP(Object)        fnt;

/**
 * textLabel.color
 */
NER_ROW_PROP(Object)        color;

/**
 * detailTextLabel.text
 */
NER_ROW_PROP(Object)        detailStr;

/**
 * detailTextLabel.font
 */
NER_ROW_PROP(Object)        detailFnt;

/**
 * detailTextLabel.color
 */
NER_ROW_PROP(Object)        detailColor;

/**
 * accessoryView
 * Usages: .accessoryView([UISwitch new])
 */
NER_ROW_PROP(Object)        accessory;

/**
 * Whether or not to check the cell.
 * Use UITableViewCellAccessoryCheckmark internally.
 * Usages: .check(YES), .check(NO)
 */
NER_ROW_PROP(Bool)          check;

/**
 * Cell height
 * Usages: .cellHeight(60)
 */
NER_ROW_PROP(Float)         cellHeight;

/**
 * Separator left inset
 * Usages: .separatorLeftInset(10)
 */
NER_ROW_PROP(Float)         separatorLeftInset;

/**
 * Custom cell
 * Argument can be:
   1) xib file name
   2) cell class name
   3) UITableViewCell object
   4) custom block for set up UITableViewCell
 
 * Usages:
    .custom(@"NewsCell")
    .custom(^(UITableViewCell *cell) {
        HStack(Label.str(@"hello")).embedIn(cell);
    });
 */
NER_ROW_PROP(Object)        custom;

/**
 * Selection callback
 * Only if you set a callback block, can the cell be selected.
 * Usages: .onClick(^{})
 */
NER_ROW_PROP(Callback)      onClick;

/**
 * Apply style to UITableViewCell
 */
NER_ROW_PROP(Object)        styles;

//UITableViewAutomaticDimension
- (instancetype)cellHeightAuto;

//UITableViewCellStyleSubtitle
- (instancetype)subtitleStyle;

//UITableViewCellStyleValue2
- (instancetype)value2Style;

//UITableViewCellAccessoryDisclosureIndicator
- (instancetype)disclosure;

@end


