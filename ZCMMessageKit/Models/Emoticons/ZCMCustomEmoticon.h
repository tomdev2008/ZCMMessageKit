//
//  ZCMCustomEmoticon.h
//  zcm
//
//  Created by cnstar on 28/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCMEmoticon.h"

//
//
//    自定义表情管理器
//
//
@interface ZCMCustomEmoticon : NSObject
+(NSArray *)emoticons;
/**
 *  更新自定义表情
 */
+(void)updateCustomEmoticon:(ZCMEmoticon *)emoticon opt:(ZCMCustomEmoticonOperator)opt;


@end
