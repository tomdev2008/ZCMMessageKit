//
//  ZCMCustomEmoticon.m
//  zcm
//
//  Created by cnstar on 28/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMCustomEmoticon.h"


@implementation ZCMCustomEmoticon

/**
 *  获取所有自定义表情
 *
 */
+(NSArray *)emoticons {
    NSMutableArray *array = [NSMutableArray array];
    
    ZCMEmoticon *emt = [[ZCMEmoticon alloc] init];
    emt.emoticonConverPicture = [UIImage imageNamed:@"EmoticonAddButton"];
    emt.emoticonType = ZCMEmoticonAddCustomType;
    [array addObject:emt];
    
    return array;
}

/**
 *  更新自定义表情
 */
+(void)updateCustomEmoticon:(ZCMEmoticon *)emoticon opt:(ZCMCustomEmoticonOperator)opt {
    
}


@end
