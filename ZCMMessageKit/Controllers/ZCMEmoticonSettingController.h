//
//  ZCMEmoticonSettingController.h
//  zcm
//
//  Created by cnstar on 29/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCMEmoticonSettingController : UITableViewController

+(void)showEmoticonSettingWithRootViewController:(UIViewController *)parentViewController;

@end


@interface ZCMEmoticonSettingCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@interface ZCMEmoticonSettingOtherCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end
