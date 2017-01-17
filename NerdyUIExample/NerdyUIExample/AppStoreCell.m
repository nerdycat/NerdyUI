//
//  AppStoreCell.m
//  NerdyUIExample
//
//  Created by nerdycat on 2017/1/11.
//  Copyright © 2017 nerdycat. All rights reserved.
//

#import "AppStoreCell.h"
#import "NerdyUI.h"

@implementation AppStoreCell {
    UILabel     *_indexLabel;
    UIImageView *_iconView;
    UILabel     *_titleLabel;
    UILabel     *_categoryLabel;
    UILabel     *_ratingLabel;
    UILabel     *_countLabel;
    UIButton    *_actionButton;
    UILabel     *_iapLabel;
}

- (void)updateWithApp:(NSDictionary *)app index:(NSInteger)index {
    _indexLabel.str(index + 1);
    _iconView.img(app[@"iconName"]);
    _titleLabel.text = app[@"title"];
    _categoryLabel.text = app[@"category"];
    _countLabel.text = Str(@"(%@)", app[@"commentCount"]);
    _iapLabel.hidden = ![app[@"iap"] boolValue];
    
    NSInteger rating = [app[@"rating"] integerValue];
    NSString *ratingStr = @"";
    for (int i = 0; i < 5; ++i) ratingStr = ratingStr.a(i < rating? @"★": @"☆");
    _ratingLabel.text = ratingStr;
    
    NSString *price = app[@"price"];
    _actionButton.str(price.length? @"$".a(price): @"GET");
}

- (void)setupUI {
    _indexLabel = Label.fnt(17).color(@"darkGray").fixWidth(44).centerAlignment;
    _iconView = ImageView.fixWH(64, 64).cornerRadius(10).border(Screen.onePixel, @"#CCCCCC");
    
    //Setting preferWidth here will improve performance.
    _titleLabel = Label.fnt(15).lines(2).preferWidth(Screen.width - 205);
    _categoryLabel = Label.fnt(13).color(@"darkGray");
    
    _ratingLabel = Label.fnt(11).color(@"orange");
    _countLabel = Label.fnt(11).color(@"darkGray");
    
    _actionButton = Button.fnt(@15).color(@"#0065F7").border(1, @"#0065F7").cornerRadius(3);
    _actionButton.highColor(@"white").highBgImg(@"#0065F7").insets(5, 10);
    _iapLabel = Label.fnt(9).color(@"darkGray").lines(2).str(@"In-App\nPurchases").centerAlignment;
    
    //.gap() will add spacing between all items.
    id ratingStack = HorStack(_ratingLabel, _countLabel).gap(5);
    id titleStack = VerStack(_titleLabel, _categoryLabel, ratingStack).gap(4);
    id actionStack = VerStack(_actionButton, _iapLabel).gap(4).centerAlignment;
    
    HorStack(
             _indexLabel,
             _iconView,
             @10,           //Add spacing individually.
             titleStack,
             NERSpring,     //Using spring to ensure actionStack stay in the right most position.
             actionStack
    ).embedIn(self.contentView, 10, 0, 10, 15);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupUI];
    return self;
}

@end

