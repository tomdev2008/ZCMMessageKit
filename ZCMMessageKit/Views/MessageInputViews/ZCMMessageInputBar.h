//
//  ZCMMessageInputBar.h
//  zcm
//
//  Created by cnstar on 21/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZCMMessageTextInputView.h"

#import "ZCMEmoticonKeyboardManager.h"


#define kMessageInputBarHeight          49


@protocol ZCMMessageInputBarDelegate <NSObject>

@required

/**
 *  输入框将要开始编辑
 *
 *  @param msgInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(ZCMMessageTextInputView *)msgInputTextView;

/**
 *  输入框刚好开始编辑
 *
 *  @param msgInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(ZCMMessageTextInputView *)msgInputTextView;


@optional

/**
 *  输入框刚好输入结束
 *
 *  @param msgInputTextView 输入框对象
 */
- (void)inputTextViewDidChange:(ZCMMessageTextInputView *)msgInputTextView;

/**
 *  在发送文本和语音之间发生改变时，会触发这个回调函数
 *
 *  @param changed 是否改为发送语音状态
 */
- (void)didChangeToSendVoiceAction:(BOOL)changed;

/**
 *  发送文本消息，包括系统的表情
 *
 *  @param text 目标文本消息
 */
- (void)didSendTextAction:(NSString *)text;

/**
 *  发送第三方表情
 *
 *  @param facePath 目标表情的本地路径
 */
- (void)didSendFaceAction:(BOOL)sendFace;

/**
 *  点击+号按钮Action
 */
- (void)didSelectedMultipleMediaAction;

/**
 *  按下錄音按鈕 "準備" 錄音
 */
- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion;
/**
 *  开始录音
 */
- (void)didStartRecordingVoiceAction;
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction;
/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction;
/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsideAction;
/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction;

@end


@interface ZCMMessageInputBar : UIImageView

@property (nonatomic, weak) id<ZCMMessageInputBarDelegate> delegate;

@property (nonatomic, weak) id<ZCMEmoticonKeyboardManager> keyboardManager;

/**
 *  文本消息的输入框
 */
@property (nonatomic, readonly, weak) ZCMMessageTextInputView *inputTextView;

/**
 *  是否允许发送语音
 */
@property (nonatomic, assign) BOOL allowsSendVoice; // default is YES

/**
 *  是否允许发送多媒体
 */
@property (nonatomic, assign) BOOL allowsSendMultiMedia; // default is YES

/**
 *  是否支持发送表情
 */
@property (nonatomic, assign) BOOL allowsSendFace; // default is YES

/**
 *  ui布局
 */
- (void)layoutToolItems;

/**
 *  动态改变自身的高度和输入框的高度
 */
- (CGFloat)adjustTextViewHeight;

@end

