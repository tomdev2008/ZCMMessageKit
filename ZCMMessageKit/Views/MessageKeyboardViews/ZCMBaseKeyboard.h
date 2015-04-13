//
//  ZCMBaseKeyboard.h
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//
//  自定义键盘基类，（自定义表情键盘 和 多媒体功能键盘 基类）
//
//
@interface ZCMBaseKeyboard : NSObject


/**
 *  键盘view
 */
-(UIView *)view;

/**
 *  根据数据源刷新UI布局和数据
 */
- (void)reloadData;

/**
 *  隐藏键盘, delegate自动置nil
 */
-(void)hide;

@end
