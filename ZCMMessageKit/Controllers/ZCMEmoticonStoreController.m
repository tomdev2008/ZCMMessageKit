//
//  ZCMEmoticonStoreController.m
//  zcm
//
//  Created by cnstar on 29/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMEmoticonStoreController.h"
#import "ZCMEmoticonSettingController.h"
#import "ZCMMsgDisMacros.h"

@implementation ZCMEmoticonStoreController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;
    CGRect frame = self.tableView.tableHeaderView.frame;
    frame.size.height = 1;
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    [self.tableView setTableHeaderView:headerView];
}

-(IBAction)close:(id)sender {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)setting:(id)sender {
    ZCMEmoticonSettingController *vc = ZCMCLASSFROMESTORYBOARD(@"ZCMMsg", NSStringFromClass([ZCMEmoticonSettingController class]));
    [self.navigationController pushViewController:vc animated:YES];
}

+(void)showEmoticonStoreWithRootViewController:(UIViewController *)parentViewController {
    ZCMEmoticonStoreController *vc = ZCMCLASSFROMESTORYBOARD(@"ZCMMsg", NSStringFromClass([ZCMEmoticonStoreController class]));
    UINavigationController *nav = ZCMCLASSFROMESTORYBOARD(@"ZCMMsg", @"ZCMEmoticonNavigationController");
    [nav setViewControllers:@[vc]];
    [parentViewController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCMEmoticonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCMEmoticonSettingCell class])];
    cell.titleLabel.text = @"浪小花";
    
    return cell;
}


@end
