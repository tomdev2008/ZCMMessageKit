//
//  ZCMEmoticonKeyboardManager.h
//  zcm
//
//  Created by cnstar on 29/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZCMEmoticonKeyboardManager <NSObject>

/**
 *  点击表情商店按钮
 */
- (void)doGotoEmoticonStore:(void(^)(BOOL finished))completion;

/**
 *  点击表情管理按钮
 */
- (void)doGotoSettingEmoticon:(void(^)(BOOL finished))completion;

/**
 *  点击自定义表情按钮
 */
- (void)doGotoCustomEmoticon:(void(^)(BOOL finished))completion;

@end
