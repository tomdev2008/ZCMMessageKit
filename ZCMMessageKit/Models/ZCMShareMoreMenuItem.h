//
//  ZCMShareMoreMenuItem.h
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZCMShareMenuItemType) {
    ZCMShareMenuOfPic           =   0,              //图片
    ZCMShareMenuOfLoc           =   1,              //位置
    ZCMShareMenuOfFC            =   2,              //名片
    ZCMShareMenuOfFav           =   3,              //收藏
    ZCMShareMenuOfSight         =   4,              //小视频
    ZCMShareMenuOfVideo         =   5,              //拍照
    ZCMShareMenuOfVideoVoip     =   6,              //视频聊天
    ZCMShareMenuOfVoiceInput    =   7,              //语音输入
    ZCMShareMenuOfTalk          =   8,              //实时对讲机
    
};

@interface ZCMShareMoreMenuItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) ZCMShareMenuItemType  type;

@end
