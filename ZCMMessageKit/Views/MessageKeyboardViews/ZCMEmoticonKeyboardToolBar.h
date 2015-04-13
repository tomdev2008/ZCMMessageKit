//
//  ZCMEmoticonKeyboardToolBar.h
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kZCMEmoticonSectionBarHeight             37

@class ZCMEmoticonMgr;
@protocol ZCMEmoticonSectionBarDelegate <NSObject>

/**
 *  点击某一类gif表情的回调方法
 *
 *  @param emoticonManager 被点击的管理表情Model对象
 *  @param section        被点击的位置
 */
- (void)didSelectedEmoticonMgr:(ZCMEmoticonMgr *)emoticonMgr atSection:(NSInteger)section;

/**
 *  选择的section，是否需要选中状态
 *
 *  @param emoticonManager 被点击的管理表情Model对象
 *  @param section        被点击的位置
 */
- (BOOL)shouldShowSelectedStatusForEmoticonMgr:(ZCMEmoticonMgr *)emoticonMgr atSection:(NSInteger)section;

/**
 *  点击表情商店按钮
 */
- (void)didSelectedEmoticonStore;

/**
 *  点击发送表情按钮
 */
- (void)didSelectedSendEmoticon;


@end

@interface ZCMEmoticonKeyboardToolBar : UIView

@property (nonatomic, weak) id <ZCMEmoticonSectionBarDelegate> delegate;

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *emoticonMgrs;

/**
 *  根据数据源刷新UI布局和数据
 */
-(void)reloadData;

@end
