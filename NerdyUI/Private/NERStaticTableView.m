//
//  NERStaticTableView.m
//  NerdyUI
//
//  Created by nerdycat on 2016/11/9.
//  Copyright © 2016 nerdycat. All rights reserved.
//

#import "NERStaticTableView.h"
#import "NERDefs.h"

@interface NERStaticTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *sections;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIFont *detailTextFont;
@property (nonatomic, strong) UIColor *detailTextColor;

@property (nonatomic, strong) NSNumber *cellHeightNumber;
@property (nonatomic, strong) NSNumber *groupSpacingNumber;

@property (nonatomic, strong) NSValue *lineInsets;

@property (nonatomic, strong) id configRowBlock;
@property (nonatomic, strong) id configCellBlock;

@end


@interface NERStaticSection ()
@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, strong) id headerObject;
@property (nonatomic, strong) id footerObject;

@property (nonatomic, assign) NERStaticSectionCheckStyle checkStyle;

@end


@interface NERStaticRow ()

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, strong) UIFont *detailTextFont;
@property (nonatomic, strong) UIColor *detailTextColor;

@property (nonatomic, strong) NSNumber *cellHeightNumber;
@property (nonatomic, strong) NSValue *lineInsets;

@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property (nonatomic, assign) UITableViewCellStyle style;
@property (nonatomic, strong) NERSimpleBlock selectionBlock;

@property (nonatomic, strong) id cellObject;

@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, weak) NERStaticTableView *tableView;
@property (nonatomic, weak) NERStaticSection *section;

@end



@implementation NERStaticRow

- (void)setImage:(UIImage *)image {
    _image = image;
    self.cell.imageView.image = image;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.cell.textLabel.text = text;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.cell.textLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.cell.textLabel.textColor = textColor;
}

- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    self.cell.detailTextLabel.text = detailText;
}

- (void)setDetailTextFont:(UIFont *)detailTextFont {
    _detailTextFont = detailTextFont;
    self.cell.detailTextLabel.font = detailTextFont;
}

- (void)setDetailTextColor:(UIColor *)detailTextColor {
    _detailTextColor = detailTextColor;
    self.cell.detailTextLabel.textColor = detailTextColor;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    _accessoryType = accessoryType;
    self.cell.accessoryType = accessoryType;
}

- (void)setAccessoryView:(UIView *)accessoryView {
    _accessoryView = accessoryView;
    self.cell.accessoryView = accessoryView;
}

- (void)setCellHeightNumber:(NSNumber *)cellHeightNumber {
    _cellHeightNumber = cellHeightNumber;
    [self.tableView reloadData];
}

- (void)setSelectionBlock:(NERSimpleBlock)selectionBlock {
    _selectionBlock = selectionBlock;
    self.cell.selectionStyle = selectionBlock? UITableViewCellSelectionStyleDefault: UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath
                          inTableView:(NERStaticTableView *)tableView
                              section:(NERStaticSection *)section {
    self.tableView = tableView;
    self.section = section;
    
    if (self.cell) return self.cell;
    
    UITableViewCellStyle style = self.style;
    if (style == UITableViewCellStyleDefault && self.detailText.length) {
        style = UITableViewCellStyleValue1;
    }
    
    if ([self.cellObject isKindOfClass:NSString.class]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.cellObject ofType:@"nib"];
        if (path) {
            UINib *nib = [UINib nibWithNibName:self.cellObject bundle:nil];
            self.cell = [nib instantiateWithOwner:nil options:nil].firstObject;
        } else {
            Class c = NSClassFromString(self.cellObject);
            self.cell = [[c alloc] initWithStyle:style reuseIdentifier:nil];
        }
        
    } else if ([self.cellObject isKindOfClass:UITableViewCell.class]) {
        self.cell = self.cellObject;
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:nil];
        
        cell.imageView.image = self.image;
        cell.textLabel.text = self.text;
        cell.detailTextLabel.text = self.detailText;
        
        cell.accessoryType = self.accessoryType;
        cell.accessoryView = self.accessoryView;
        
        if (self.textColor || tableView.textColor) {
            cell.textLabel.textColor = self.textColor?: tableView.textColor;
        }
        
        if (self.textFont || tableView.textFont) {
            cell.textLabel.font = self.textFont?: tableView.textFont;
        }
        
        if (self.detailTextColor || tableView.detailTextColor) {
            cell.detailTextLabel.textColor = self.detailTextColor?: tableView.detailTextColor;
        }
        
        if (self.detailTextFont || tableView.detailTextFont) {
            cell.detailTextLabel.font = self.detailTextFont?: tableView.detailTextFont;
        }
        
        if (self.lineInsets || tableView.lineInsets) {
            cell.preservesSuperviewLayoutMargins = NO;
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.separatorInset = [self.lineInsets?: tableView.lineInsets UIEdgeInsetsValue];
        }
        
        if (!self.selectionBlock && section.checkStyle == NERStaticSectionCheckStyleNone) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.cellObject && NER_IS_BLOCK(self.cellObject)) {
            ((void (^)(id, id))self.cellObject)(cell, indexPath);
        }
        
        self.cell = cell;
    }
    
    return self.cell;
}

- (void)invokeCallback {
    if (self.selectionBlock) {
        self.selectionBlock();
    }
}

@end




@implementation NERStaticSection

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.checkStyle == NERStaticSectionCheckStyleNone) {
        return;
    }
    
    NERStaticRow *row = self.rows[indexPath.row];
    
    if (row.cell.accessoryType != UITableViewCellAccessoryCheckmark) {
        row.cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        if (self.checkStyle != NERStaticSectionCheckStyleSingle) {
            row.cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if (self.checkStyle == NERStaticSectionCheckStyleSingle &&
        row.cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        for (NERStaticRow *r in self.rows) {
            if (r != row) {
                r.cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
}

+ (instancetype)sectionWithRows:(NSArray *)rows {
    NERStaticSection *section = [NERStaticSection new];
    section.rows = [rows mutableCopy];
    return section;
}

@end




@implementation NERStaticTableView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(-1, self.contentSize.height + self.contentInset.top + self.contentInset.bottom);
}

- (NSArray *)checkedIndexPaths {
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (int i = 0; i < self.sections.count; ++i) {
        NERStaticSection *section = self.sections[i];
        
        for (int j = 0; j < section.rows.count; ++j) {
            NERStaticRow *row = section.rows[j];
            
            if (row.cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:j inSection:i]];
            }
        }
    }
    return [indexPaths copy];
}

- (NERStaticRow *)rowForIndexPath:(NSIndexPath *)indexPath {
    NERStaticSection *section = self.sections[indexPath.section];
    NERStaticRow *row = section.rows[indexPath.row];
    return row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    NERStaticSection *section = self.sections[sectionIndex];
    return section.rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NERStaticRow *row = [self rowForIndexPath:indexPath];
    if (row.cellHeightNumber) return [row.cellHeightNumber floatValue];
    if (self.cellHeightNumber) return [self.cellHeightNumber floatValue];
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)index {
    NERStaticSection *section = self.sections[index];
    
    if([section.headerObject isKindOfClass:UIView.class]) {
        UIView *headerView = section.headerObject;
        return headerView.bounds.size.height;
        
    } else if ([section.headerObject isKindOfClass:NSNumber.class]) {
        return [section.headerObject floatValue];
        
    } else {
        if (self.groupSpacingNumber) {
            CGFloat spacing = [self.groupSpacingNumber floatValue];
            return index == 0? spacing: spacing / 2;
        } else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)index {
    NERStaticSection *section = self.sections[index];
    
    if([section.footerObject isKindOfClass:UIView.class]) {
        UIView *footerView = section.footerObject;
        return footerView.bounds.size.height;
        
    } else if ([section.footerObject isKindOfClass:NSNumber.class]) {
        return [section.footerObject floatValue];
        
    } else {
        if (self.groupSpacingNumber) {
            CGFloat spacing = [self.groupSpacingNumber floatValue];
            return index == [self numberOfSectionsInTableView:self] - 1? spacing: spacing / 2;
        } else {
            return 0;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)index {
    NERStaticSection *section = self.sections[index];
    return [section.headerObject isKindOfClass:UIView.class]? section.headerObject: nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)index {
    NERStaticSection *section = self.sections[index];
    return [section.footerObject isKindOfClass:UIView.class]? section.footerObject: nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NERStaticSection *section = self.sections[indexPath.section];
    NERStaticRow *row = section.rows[indexPath.row];
    return [row cellForIndexPath:indexPath inTableView:self section:section];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NERStaticRow *row = [self rowForIndexPath:indexPath];
    if (self.configRowBlock) {
        ((void (^)(id, id))self.configRowBlock)(row, indexPath);
    }
    if (self.configCellBlock) {
        ((void (^)(id, id))self.configCellBlock)(cell, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NERStaticSection *section = self.sections[indexPath.section];
    NERStaticRow *row = section.rows[indexPath.row];
    [section didSelectRowAtIndexPath:indexPath];
    [row invokeCallback];
}


- (instancetype)initWithStyle:(UITableViewStyle)style sections:(NSArray *)sections {
    NSMutableArray *realSections = [NSMutableArray array];
    NSMutableArray *orphanRows = nil;
    
    for (id object in sections) {
        if ([object isKindOfClass:NERStaticRow.class]) {
            if (!orphanRows) orphanRows = [NSMutableArray array];
            [orphanRows addObject:object];
            
        } else if ([object isKindOfClass:NERStaticSection.class]) {
            if (orphanRows.count) {
                [realSections addObject:[NERStaticSection sectionWithRows:orphanRows]];
                orphanRows = nil;
            }
            
            [realSections addObject:object];
        }
    }
    
    if (orphanRows.count) {
        [realSections addObject:[NERStaticSection sectionWithRows:orphanRows]];
    }
    
    self = [super initWithFrame:CGRectZero style:style];
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 44;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.sections = realSections;
    return self;
}

+ (instancetype)plainStyleWithSections:(NSArray *)sections {
    return [[NERStaticTableView alloc] initWithStyle:UITableViewStylePlain sections:sections];
}

+ (instancetype)groupedStyleWithSections:(NSArray *)sections {
    return [[NERStaticTableView alloc] initWithStyle:UITableViewStyleGrouped sections:sections];
}

@end



