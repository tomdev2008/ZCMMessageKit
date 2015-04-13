//
//  ZCMEmoticon.h
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>

//表情类型
typedef NS_ENUM(NSInteger, ZCMEmoticonType) {
    ZCMEmoticonAddCustomType = -3,       //添加自定义表情
    ZCMEmoticonSettingType   = -2,       //管理表情
    ZCMEmoticonDeleteType    = -1,       //删除按钮
    ZCMEmoticonEmojiType     = 0,        //系统Emoji表情
    ZCMEmoticonQQType        = 1,        //QQ表情
    ZCMEmoticonTusijiType    = 2,
    ZCMEmoticonCustomType    = 3,        //自定义表情
    ZCMEmoticonStoreType     = 4         //从表情商店下载的表情
};

//自定义表情 编辑操作类型
typedef NS_ENUM(NSInteger, ZCMCustomEmoticonOperator) {
    ZCMCustomEmoticonOptAdd        = 0,        //添加自定义表情
    ZCMCustomEmoticonOptDel        = 1,        //删除自定义表情
    ZCMCustomEmoticonOptEdit       = 2         //编辑表情
};

//
//
//  自定义表情键盘 表情按键 实体类
//
//
@interface ZCMEmoticon : NSObject

/**
 *  表情类型
 */
@property (nonatomic, assign) ZCMEmoticonType emoticonType;

/**
 *  表情名字
 */
@property (nonatomic, strong) NSString *name;

/**
 *  gif表情的封面图
 */
@property (nonatomic, strong) UIImage *emoticonConverPicture;

/**
 *  gif表情的路径
 */
@property (nonatomic, copy) NSString *emoticonPath;

@property (nonatomic, assign) BOOL isBundleRes;

@end
