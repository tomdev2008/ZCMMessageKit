//
//  ZCMMessageTextInputView.h
//  zcm
//
//  Created by cnstar on 21/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kZCMMessageTextInputViewFontSize          16.0f

@interface ZCMMessageTextInputView : UITextView

/**
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;

@end
