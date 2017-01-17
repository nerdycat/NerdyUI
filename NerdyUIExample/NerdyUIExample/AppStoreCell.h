//
//  AppStoreCell.h
//  NerdyUIExample
//
//  Created by nerdycat on 2017/1/11.
//  Copyright © 2017 nerdycat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppStoreCell : UITableViewCell

- (void)updateWithApp:(NSDictionary *)app index:(NSInteger)index;

@end
