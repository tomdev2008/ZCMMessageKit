//
//  ZCMShareMoreDataHandler.h
//  zcm
//
//  Created by cnstar on 31/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCMMessageKeyboardProtocol.h"

@protocol ZCMShareMoreKeyboardDataSource;


//
//
//  表情数据处理器
//
//
@interface ZCMShareMoreDataHandler : NSObject<ZCMShareMoreKeyboardDataSource>

+(ZCMShareMoreDataHandler *)sharedMoreDataHandler;

/**
 *  所有share item 数组
 */
-(NSArray *)data;


@end
