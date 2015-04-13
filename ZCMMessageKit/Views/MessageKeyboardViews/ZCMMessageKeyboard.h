//
//  ZCMMessageKeyboard.h
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCMMessageKeyboardProtocol.h"

#define kZCMEmoticonKeyboardHeight   219//(kZMCEmoticonSectionBarHeight+182)


typedef NS_ENUM(NSUInteger, ZCMKeyboardType) {
    ZCMKeyboardEmoticonType         = 0,            //表情键盘
    ZCMKeyboardShareMoreType        = 1,            //多媒体键盘
};


@interface ZCMMessageKeyboard : NSObject

@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, readonly) NSUInteger delegateHash;

+(ZCMMessageKeyboard *)sharedInstance;
/**
 *  根据类型显示不同的键盘 target为不同键盘提供 delegate和datasource
 */
-(void)showKeyboard:(ZCMKeyboardType)type target:(id<ZCMMessageKeyboardProtocol>)target;
/**
 *  隐藏所有自定义消息键盘
 */
-(void)hide;

/**
 *  根据类型刷新键盘
 */
-(void)reloadKeyboard:(ZCMKeyboardType)type;

@end



///--------------------
/// @name Notifications
///--------------------

/**
 keyboard frame changed.
 */
extern NSString * const kZCMKeyboardWillShowNotification;
extern NSString * const kZCMKeyboardWillHideNotification;
extern NSString * const kZCMKeyboardDidShowNotification;
extern NSString * const kZCMKeyboardDidHideNotification;

