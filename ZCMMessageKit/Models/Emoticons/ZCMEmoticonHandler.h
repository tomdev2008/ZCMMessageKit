//
//  ZCMEmoticonHandler.h
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCMMessageKeyboardProtocol.h"
#import "ZCMEmoticonMgr.h"





@protocol ZCMEmoticonKeyboardDataSource;


//
//
//  表情数据处理器
//
//
@interface ZCMEmoticonHandler : NSObject<ZCMEmoticonKeyboardDataSource>

+(ZCMEmoticonHandler *)sharedEmoticonHandler;

/**
 *  所有表情类别 数组
 */
-(NSArray *)emoticonMgrs;

/**
 *  根据表情类别获取某一类表情
 */
-(ZCMEmoticonMgr *)emoticonMgrWithEmoticonType:(ZCMEmoticonType)type error:(NSError *__autoreleasing *)error;
/**
 *  根据表情类别名字获取某一类表情
 */
-(ZCMEmoticonMgr *)emoticonMgrWithEmoticonName:(NSString *)name;
/**
 *  根据表情类别更新某一类表情
 */
-(void)updateEmoticonMgrsWithEmoticonMgr:(ZCMEmoticonMgr *)emoticonMgr;

@end


///--------------------
/// @name Notifications
///--------------------

/**
 *  emoticons data changed.
 */
extern NSString * const kZCMEmoticonsChangedNotification;
