//
//  AppStoreViewController.m
//  NerdyUIExample
//
//  Created by nerdycat on 2017/1/11.
//  Copyright © 2017 nerdycat. All rights reserved.
//

#import "AppStoreViewController.h"
#import "AppStoreCell.h"

@interface AppStoreViewController ()

@property (nonatomic, strong) NSArray *appList;

@end

@implementation AppStoreViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateWithApp:self.appList[indexPath.row] index:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 84;
    [self.tableView registerClass:AppStoreCell.class forCellReuseIdentifier:@"cell"];
    
    id path = [[NSBundle mainBundle] pathForResource:@"appList" ofType:@"plist"];
    self.appList = [NSArray arrayWithContentsOfFile:path];
    self.appList = [self.appList arrayByAddingObjectsFromArray:self.appList];
    self.appList = [self.appList arrayByAddingObjectsFromArray:self.appList];
    self.appList = [self.appList arrayByAddingObjectsFromArray:self.appList];
}

@end
