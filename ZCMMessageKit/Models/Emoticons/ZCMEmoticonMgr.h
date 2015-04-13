//
//  ZCMEmoticonMgr.h
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCMEmoticon.h"


//
//
//  表情类别管理类
//
//
@interface ZCMEmoticonMgr : NSObject

/**
 *  表情类型
 */
@property (nonatomic, assign) ZCMEmoticonType emoticonType;
/**
 *  某一类表情名字
 */
@property (nonatomic, copy) NSString *emoticonName;

@property (nonatomic, copy) UIImage *emoticonConverPicture;

/**
 *  某一类表情的数据源
 */
@property (nonatomic, strong) NSArray *emoticons;

/**
 *  根据表情类型EmoticonMgr 来返回sections
 */
-(NSUInteger)numberOfSections;

/**
 *  根据表情类型 来返回rows
 */
-(NSUInteger)numberOfRowsInSection;

/**
 *  根据表情类型 来返回 表情width
 */
-(CGFloat)emoticonWidth;

/**
 *  根据表情类型 来返回 表情height
 */
-(CGFloat)emoticonHeight;

@end
