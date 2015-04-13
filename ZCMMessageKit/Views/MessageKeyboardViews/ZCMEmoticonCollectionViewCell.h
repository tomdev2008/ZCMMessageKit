//
//  ZCMEmoticonCollectionViewCell.h
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCMEmoticon.h"

@protocol ZCMEmoticonCollectionViewCellDelegate;
@interface ZCMEmoticonCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<ZCMEmoticonCollectionViewCellDelegate> delegate;
/**
 *  需要显示和配置的gif表情对象
 */
@property (nonatomic, strong) ZCMEmoticon *emoticon;

@end

@protocol ZCMEmoticonCollectionViewCellDelegate <NSObject>

/**
 *  表情被点击 的delegate
 */
-(void)emoticonCollectionViewCell:(ZCMEmoticonCollectionViewCell *)cell didSelectedEmoticon:(ZCMEmoticon *)emoticon;

@end
