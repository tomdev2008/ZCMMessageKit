//
//  ZCMEmoticonSettingController.m
//  zcm
//
//  Created by cnstar on 29/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMEmoticonSettingController.h"
#import "ZCMMsgDisMacros.h"
#import "ZCMCustomEmoticonController.h"


@implementation ZCMEmoticonSettingCell

@end

@implementation ZCMEmoticonSettingOtherCell

@end


@interface ZCMEmoticonSettingController ()
@property (nonatomic, assign) BOOL sorting;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *barItem;

@end

@implementation ZCMEmoticonSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的表情";
    
    self.tableView.rowHeight = 50;
    CGRect frame = self.tableView.tableHeaderView.frame;
    frame.size.height = 1;
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    [self.tableView setTableHeaderView:headerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)sort:(id)sender {
    _sorting = !_sorting;
    if (_sorting) {
        [_barItem setTitle:@"完成"];
        [_barItem setTintColor:[UIColor colorWithRed:50 green:255 blue:50 alpha:1]];
    } else {
        [_barItem setTitle:@"排序"];
        [_barItem setTintColor:[UIColor whiteColor]];
    }
    
    [self.tableView reloadData];
    [self.tableView setEditing:_sorting animated:YES];
}

+(void)showEmoticonSettingWithRootViewController:(UIViewController *)parentViewController {
    ZCMEmoticonSettingController *vc = ZCMCLASSFROMESTORYBOARD(@"ZCMMsg", NSStringFromClass([ZCMEmoticonSettingController class]));
    UINavigationController *nav = ZCMCLASSFROMESTORYBOARD(@"ZCMMsg", @"ZCMEmoticonNavigationController");
    [nav setViewControllers:@[vc]];
    [parentViewController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"聊天面板中的表情";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_sorting) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ZCMEmoticonSettingOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCMEmoticonSettingOtherCell class])];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"我收藏的表情";
        } else {
            cell.titleLabel.text = @"表情购买记录";
        }
        
        return cell;
    } else {
        ZCMEmoticonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCMEmoticonSettingCell class])];
        cell.titleLabel.text = @"浪小花";
        
        return cell;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ZCMCustomEmoticonController *vc = ZCMCLASSFROMESTORYBOARD(@"ZCMMsg", NSStringFromClass([ZCMCustomEmoticonController class]));
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
        }
    }
}

@end
