//
//  ZCMShareMoreMenuCell.h
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCMShareMoreMenuItem.h"

@protocol ZCMShareMoreMenuCellDelegate;

@interface ZCMShareMoreMenuCell : UICollectionViewCell

@property (nonatomic, weak) id<ZCMShareMoreMenuCellDelegate> delegate;
/**
 *  需要显示和配置的gif表情对象
 */
@property (nonatomic, strong) ZCMShareMoreMenuItem *shareItem;

@end

@protocol ZCMShareMoreMenuCellDelegate <NSObject>

/**
 *  多媒体功能被点击 的delegate
 */
-(void)shareMoreCollectionViewCell:(ZCMShareMoreMenuCell *)cell didSelectedShareItem:(ZCMShareMoreMenuItem *)shareItem;

@end

