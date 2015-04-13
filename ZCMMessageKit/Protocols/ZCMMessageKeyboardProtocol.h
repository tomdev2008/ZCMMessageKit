//
//  ZCMMessageKeyboardProtocol.h
//  zcm
//
//  Created by cnstar on 23/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZCMEmoticonKeyboardDelegate;
@protocol ZCMEmoticonKeyboardDataSource;

@protocol ZCMShareMoreKeyboardDelegate;
@protocol ZCMShareMoreKeyboardDataSource;

@protocol ZCMMessageKeyboardProtocol <NSObject>
@required
/**
 *  获取表情键盘的DataSource代理
 */
-(__weak id<ZCMEmoticonKeyboardDataSource>)getEmoticonKeyboardDataSource;
/**
 *  获取表情键盘的操作回调代理
 */
-(__weak id<ZCMEmoticonKeyboardDelegate>)getEmoticonKeyboardDelegate;
/**
 *  获取多媒体键盘的DataSource代理
 */
-(__weak id<ZCMShareMoreKeyboardDataSource>)getShareMoreKeyboardDataSource;
/**
 *  获取多媒体键盘的操作回调代理
 */
-(__weak id<ZCMShareMoreKeyboardDelegate>)getShareMoreKeyboardDelegate;
@end


@class ZCMEmoticon;
@class ZCMEmoticonKeyboard;
@class ZCMEmoticonMgr;

#pragma mark - ZCMEmoticonKeyboardDelegate
//
//
//  ZCMEmoticonKeyboardDelegate
//
//
@protocol ZCMEmoticonKeyboardDelegate <NSObject>

@required

/**
 *  第三方gif表情被点击的回调事件
 *
 *  @param emoticon   被点击的gif表情Model
 *  @param indexPath 被点击的位置
 */
-(void)emoticonKeyboard:(ZCMEmoticonKeyboard *)keyboard didSelectedEmoticon:(ZCMEmoticon *)emoticon atIndexPath:(NSIndexPath *)indextPath;

/**
 *  删除按钮被点击的回调事件
 */
-(void)emoticonKeyboardDidPressBackspace:(ZCMEmoticonKeyboard *)keyboard;

/**
 *  点击发送表情按钮
 */
- (void)didSelectedSendEmoticon;

/**
 *  点击表情商店按钮
 */
- (void)didSelectedEmoticonStore;

/**
 *  点击表情管理按钮
 */
- (void)didSelectedSettingEmoticon;

/**
 *  点击自定义表情按钮
 */
- (void)didSelectedCustomEmoticon;

@end

#pragma mark - ZCMEmoticonKeyboardDataSource
//
//
//  ZCMEmoticonKeyboardDataSource
//
//
@protocol ZCMEmoticonKeyboardDataSource <NSObject>

@required
/**
 *  通过数据源获取统一管理一类表情的回调方法
 *
 *  @param section 列数
 *
 *  @return 返回统一管理表情的Model对象
 */
- (ZCMEmoticonMgr *)emoticonMgrInEmoticonKeyboard:(ZCMEmoticonKeyboard *)keyboard atSection:(NSInteger)section;

/**
 *  通过数据源获取一系列的统一管理表情的Model数组
 *
 *  @return 返回包含统一管理表情Model元素的数组
 */
- (NSArray *)emoticonMgrsInEmoticonKeyboard:(ZCMEmoticonKeyboard *)keyboard;

/**
 *  通过数据源获取总共有多少类gif表情
 *
 *  @return 返回总数
 */
- (NSInteger)numberOfEmoticonMgrsInEmoticonKeyboard:(ZCMEmoticonKeyboard *)keyboard;

/**
 *  通过数据源 返回是否需要删除按钮
 *
 *  @param column 列数
 *
 *  @return 返回是否需要删除按钮
 */
- (BOOL)shouldShowDeleteActionInEmoticonKeyboard:(ZCMEmoticonKeyboard *)keyboard atSection:(NSInteger)section;

@end


#pragma mark - ZCMShareMoreKeyboardDelegate

@class ZCMShareMoreKeyboard;
@class ZCMShareMoreMenuItem;

@protocol ZCMShareMoreKeyboardDelegate <NSObject>

/**
 *  多媒体功能被点击 的delegate
 */
-(void)shareMoreKeyboard:(ZCMShareMoreKeyboard *)keyboard didSelectedShareItem:(ZCMShareMoreMenuItem *)shareItem;

@end


#pragma mark - ZCMShareMoreKeyboardDataSource

@protocol ZCMShareMoreKeyboardDataSource <NSObject>

@required
/**
 *  通过数据源获取统一管理一类多媒体功能的回调方法
 *
 *  @param column 列数
 *
 *  @return 返回统一管理多媒体功能的Model对象
 */
- (ZCMShareMoreMenuItem *)shareItemInShareMoreKeyboard:(ZCMShareMoreKeyboard *)keyboard atSection:(NSInteger)section;
/**
 *  通过数据源获取一系列的统一管理多媒体功能的Model数组
 *
 *  @return 返回包含统一管理多媒体功能Model元素的数组
 */
- (NSArray *)shareItemsInShareMoreKeyboard:(ZCMShareMoreKeyboard *)keyboard;
/**
 *  通过数据源获取总共有多少种多媒体功能
 *
 *  @return 返回总数
 */
- (NSInteger)numberOfShareItemInShareMoreKeyboard:(ZCMShareMoreKeyboard *)keyboard;

@end
