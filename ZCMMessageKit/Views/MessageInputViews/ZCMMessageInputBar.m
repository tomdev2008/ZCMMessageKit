//
//  ZCMMessageInputBar.m
//  zcm
//
//  Created by cnstar on 21/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMMessageInputBar.h"
#import "ZCMFaceSendButton.h"
#import "ZCMVoiceChangeButton.h"

#import "ZCMMessageKeyboard.h"
#import "ZCMShareMoreMenuItem.h"

#import "ZCMCustomEmoticonController.h"
#import "ZCMEmoticonSettingController.h"
#import "ZCMEmoticonStoreController.h"

#import "ZCMMessageKeyboardProtocol.h"

#import "ZCMEmoticonMgr.h"

#import "ZCMPhotoHelper.h"
#import "ZCMMsgDisMacros.h"



#define kMsgTooBarInputViewHeight           35
#define kMsgToolBarItemHeight               35
#define kMsgToolBarItemWidth                35


#define MSG_VOICE_TAG                   1
#define MSG_FACE_TAG                    2
#define MSG_MULTIMEDIA_TAG              3









@interface ZCMMessageInputBar ()<UITextViewDelegate, ZCMMessageKeyboardProtocol, ZCMEmoticonKeyboardDelegate, ZCMShareMoreKeyboardDelegate>

/**
 *  文本消息的输入框
 */
@property (nonatomic, readwrite, weak) ZCMMessageTextInputView *inputTextView;
@property (nonatomic, assign) CGFloat inputViewMargin;

/**
 *  是否取消錄音
 */
@property (nonatomic, assign) BOOL isCancelled;

/**
 *  是否正在錄音
 */
@property (nonatomic, assign) BOOL isRecording;

/**
 *  在切换语音和文本消息的时候，需要保存原本已经输入的文本，这样达到一个好的UE
 */
@property (nonatomic, copy) NSString *inputedText;

/**
 *  切换文本和语音的按钮
 */
@property (nonatomic, weak) ZCMVoiceChangeButton *voiceChangeButton;

/**
 *  +号按钮
 */
@property (nonatomic, weak) UIButton *multiMediaSendButton;

/**
 *  第三方表情按钮
 */
@property (nonatomic, weak) ZCMFaceSendButton *faceSendButton;

/**
 *  语音录制按钮
 */
@property (nonatomic, weak) UIButton *holdDownButton;

/**
 *  图片处理器
 */
@property (nonatomic, strong) ZCMPhotoHelper *photoHelper;

/**
 *  当录音按钮被按下所触发的事件，这时候是开始录音
 */
- (void)holdDownButtonTouchDown;

/**
 *  当手指在录音按钮范围之外离开屏幕所触发的事件，这时候是取消录音
 */
- (void)holdDownButtonTouchUpOutside;

/**
 *  当手指在录音按钮范围之内离开屏幕所触发的事件，这时候是完成录音
 */
- (void)holdDownButtonTouchUpInside;

/**
 *  当手指滑动到录音按钮的范围之外所触发的事件
 */
- (void)holdDownDragOutside;

/**
 *  当手指滑动到录音按钮的范围之内所触发的时间
 */
- (void)holdDownDragInside;

#pragma mark - layout subViews UI

/**
 *  根据正常显示和高亮状态创建一个按钮对象
 *
 *  @param image   正常显示图
 *  @param hlImage 高亮显示图
 *
 *  @return 返回按钮对象
 */
- (UIButton *)createButtonWithImage:(UIImage *)image HLImage:(UIImage *)hlImage;

/**
 *  配置默认参数
 */
- (void)setup;

@end

@implementation ZCMMessageInputBar

#pragma mark - Life cycle
/**
 *  配置默认参数
 */
- (void)setup {
    // 配置自适应
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.opaque = YES;
    // 由于继承UIImageView，所以需要这个属性设置
    self.userInteractionEnabled = YES;
    
    UIImage *bgImg = [UIImage imageNamed:@"MsgToolBarBkg.png"];
    if (bgImg) {
        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(bgImg.size.height/4, bgImg.size.width/4, bgImg.size.height/4*3, bgImg.size.width/4*3)];
        self.image = bgImg;
    }
    
    // 默认设置
    _allowsSendVoice = YES;
    _allowsSendFace = YES;
    _allowsSendMultiMedia = YES;
    
    //[self layoutMessageInputBar];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboardNotification:)
                                                 name:kZCMKeyboardWillHideNotification
                                               object:nil];
}

//- (void)awakeFromNib {
//    [self setup];
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self setup];
    }
    
    return self;
}

-(ZCMPhotoHelper *)photoHelper {
    if (!_photoHelper) {
        _photoHelper = [[ZCMPhotoHelper alloc] init];
    }
    
    return _photoHelper;
}

/**
 *  隐藏自定义键盘
 */
-(void) hideMessageKeyboard {
    if ([ZCMMessageKeyboard sharedInstance].delegateHash == [self hash]) {
        [[ZCMMessageKeyboard sharedInstance] hide];
    }
}

- (void)dealloc {
    // remove KVO
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kZCMKeyboardWillHideNotification object:nil];
    [self.inputTextView removeObserver:self forKeyPath:@"editable"];
    [self hideMessageKeyboard];
    self.inputedText = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
    
    _voiceChangeButton = nil;
    _multiMediaSendButton = nil;
    _faceSendButton = nil;
    _holdDownButton = nil;
    _photoHelper = nil;
}

-(void)handleWillHideKeyboardNotification:(NSNotification *)notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = ZCMMSG_ScreenHeight - keyboardRect.origin.y;
    if (offset <= 0.00001) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _faceSendButton.isFace = YES;
            _multiMediaSendButton.selected = NO;
        });
    }
}

#pragma mark - layout subViews UI
- (UIButton *)createButtonWithImage:(UIImage *)image HLImage:(UIImage *)hlImage {
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    if (image)
        [button setBackgroundImage:image forState:UIControlStateNormal];
    if (hlImage)
        [button setBackgroundImage:hlImage forState:UIControlStateHighlighted];
    
    return button;
}

/**
 *  输入条UI布局
 */
- (void)layoutToolItems {
    [self layoutMessageInputBar];
}
- (void)layoutMessageInputBar {
    // remove KVO
    [self.inputTextView removeObserver:self forKeyPath:@"editable"];
    
    [_voiceChangeButton removeFromSuperview];
    [_faceSendButton removeFromSuperview];
    [_multiMediaSendButton removeFromSuperview];
    [_holdDownButton removeFromSuperview];
    [_inputTextView removeFromSuperview];
    
    // 按钮对象消息
    UIButton *button;
    
    // 允许发送语音
    if (self.allowsSendVoice) {
        ZCMVoiceChangeButton *voiceButton = [[ZCMVoiceChangeButton alloc] init];
        voiceButton.tag = MSG_VOICE_TAG;
        [voiceButton addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voiceButton];
        self.voiceChangeButton = voiceButton;
    }
    
    // 允许发送多媒体消息
    if (self.allowsSendMultiMedia) {
        button = [self createButtonWithImage:[UIImage imageNamed:@"ToolViewMultiMedia"] HLImage:[UIImage imageNamed:@"ToolViewMultiMediaHL"]];
        [button setImage:[UIImage imageNamed:@"ToolViewMultiMediaHL"] forState:UIControlStateSelected];
        button.tag = MSG_MULTIMEDIA_TAG;
        [button addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.multiMediaSendButton = button;
    }
    
    // 允许发送表情
    if (self.allowsSendFace) {
        ZCMFaceSendButton *faceButton = [[ZCMFaceSendButton alloc] init];
        faceButton.tag = MSG_FACE_TAG;
        [faceButton addTarget:self action:@selector(messageStyleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:faceButton];
        self.faceSendButton = faceButton;
    }
    
    // 初始化输入框
    ZCMMessageTextInputView *textView = [[ZCMMessageTextInputView alloc] init];
    // 这个是仿微信的一个细节体验
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    textView.placeHolder = @"发送消息";
    textView.delegate = self;

    
    [self addSubview:textView];
    _inputTextView = textView;
    
    _inputTextView.backgroundColor = [UIColor whiteColor];
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 6.0f;
    
    // 如果是可以发送语言的，那就需要一个按钮录音的按钮，事件可以在外部添加
    if (self.allowsSendVoice) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(9, 9, 9, 9);
        button = [self createButtonWithImage:[[UIImage imageNamed:@"VoiceBtn_Black"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch] HLImage:[[UIImage imageNamed:@"VoiceBtn_BlackHL"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch]];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitle:@"按住 说话" forState:UIControlStateNormal];
        [button setTitle:@"松开 结束"  forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.alpha = !self.voiceChangeButton.isVoice;
        [button addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:button];
        self.holdDownButton = button;
    }
    
    [self setupSubviewsConstraints];

    //add KVO
    [self.inputTextView addObserver:self forKeyPath:@"editable" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  设置subviews的约束
 */
-(void)setupSubviewsConstraints {
    _inputViewMargin = 7.0;
    //autolayout 布局，约束条件
    NSDictionary *metrics = @{@"margin":@2, @"hPadding":@3, @"w":@35, @"h":@35, @"inputM":@(_inputViewMargin)};
    NSDictionary *views = NSDictionaryOfVariableBindings(self,_voiceChangeButton, _inputTextView, _faceSendButton, _multiMediaSendButton, _holdDownButton);
    NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_voiceChangeButton(w)]-hPadding-[_inputTextView]-hPadding-[_faceSendButton(w)]-0-[_multiMediaSendButton(w)]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [self addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_voiceChangeButton(w)]-hPadding-[_holdDownButton]-hPadding-[_faceSendButton(w)]-0-[_multiMediaSendButton(w)]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [self addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_voiceChangeButton(h)]-8-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views];
    [self addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-inputM-[_inputTextView]-inputM-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views];
    [self addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-inputM-[_holdDownButton]-inputM-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views];
    [self addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_faceSendButton(h)]-8-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views];
    [self addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_multiMediaSendButton(h)]-8-|" options:NSLayoutFormatAlignAllBottom metrics:metrics views:views];
    [self addConstraints:c];
}

#pragma mark - Key-value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.inputTextView && [keyPath isEqualToString:@"editable"]) {
        if (self.inputTextView.isEditable == NO) { //BUG
            [self hideMessageKeyboard];
        }
    }
}


#pragma mark - Action
/**
 *  输入框内的所有按钮，点击事件所触发的方法
 *
 *  @param sender 被点击的按钮对象
 */
- (void)messageStyleButtonClicked:(UIButton *)sender {
    NSInteger index = sender.tag;
    switch (index) {
        case MSG_VOICE_TAG: {
            ZCMVoiceChangeButton *voiceButton = (ZCMVoiceChangeButton *)sender;
            voiceButton.isVoice = !voiceButton.isVoice;
            self.faceSendButton.isFace = YES;
            self.multiMediaSendButton.selected = NO;
            
            if (!voiceButton.isVoice) {
                self.inputedText = self.inputTextView.text;
                self.inputTextView.text = @"";
                [self.inputTextView resignFirstResponder];
            } else {
                self.inputTextView.text = self.inputedText;
                self.inputedText = nil;
                [self.inputTextView becomeFirstResponder];
            }
            
    
            [[ZCMMessageKeyboard sharedInstance] hide];
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.alpha = !voiceButton.isVoice;
                self.inputTextView.alpha = voiceButton.isVoice;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didChangeToSendVoiceAction:)]) {
                [self.delegate didChangeToSendVoiceAction:voiceButton.isVoice];
            }
            
            break;
        }
        case MSG_FACE_TAG: {
            ZCMFaceSendButton *faceButton = (ZCMFaceSendButton *)sender;
            faceButton.isFace = !faceButton.isFace;
            self.voiceChangeButton.isVoice = YES;
            self.multiMediaSendButton.selected = NO;
            
            if (faceButton.isFace) {
                [self.inputTextView becomeFirstResponder];
                [[ZCMMessageKeyboard sharedInstance] hide];
            } else {
                [[ZCMMessageKeyboard sharedInstance] showKeyboard:ZCMKeyboardEmoticonType target:self];
                [self.inputTextView resignFirstResponder];
            }
 
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.alpha = 0.0;
                self.inputTextView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didSendFaceAction:)]) {
                [self.delegate didSendFaceAction:!faceButton.isFace];
            }
            
            break;
        }
        case MSG_MULTIMEDIA_TAG: {
            self.faceSendButton.isFace = YES;
            self.voiceChangeButton.isVoice = YES;
            self.holdDownButton.alpha = 0.0;
            self.inputTextView.alpha = 1.0;
            self.multiMediaSendButton.selected = !self.multiMediaSendButton.selected;
            
            if (self.multiMediaSendButton.selected) {
                [[ZCMMessageKeyboard sharedInstance] showKeyboard:ZCMKeyboardShareMoreType target:self];
                [self.inputTextView resignFirstResponder];
            } else {
                [self.inputTextView becomeFirstResponder];
                [[ZCMMessageKeyboard sharedInstance] hide];
            }

            if ([self.delegate respondsToSelector:@selector(didSelectedMultipleMediaAction)]) {
                [self.delegate didSelectedMultipleMediaAction];
            }
            break;
        }
        default:
            break;
    }
}

- (void)holdDownButtonTouchDown {
    self.isCancelled = NO;
    self.isRecording = NO;
    if ([self.delegate respondsToSelector:@selector(prepareRecordingVoiceActionWithCompletion:)]) {
        typeof(self) __weak weakSelf = self;
        
        //這邊回調 return 的 YES, 或 NO, 可以讓底層知道該次錄音是否成功, 進而處理無用的 record 對象
        [self.delegate prepareRecordingVoiceActionWithCompletion:^BOOL{
            typeof(weakSelf) __strong strongSelf = weakSelf;
            
            //這邊要判斷回調回來的時候, 使用者是不是已經早就鬆開手了
            if (strongSelf && !strongSelf.isCancelled) {
                strongSelf.isRecording = YES;
                [strongSelf.delegate didStartRecordingVoiceAction];
                return YES;
            } else {
                return NO;
            }
        }];
    }
}

- (void)holdDownButtonTouchUpOutside {
    
    //如果已經開始錄音了, 才需要做取消的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
            [self.delegate didCancelRecordingVoiceAction];
        }
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownButtonTouchUpInside {
    
    //如果已經開始錄音了, 才需要做結束的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction)]) {
            [self.delegate didFinishRecoingVoiceAction];
        }
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownDragOutside {
    
    //如果已經開始錄音了, 才需要做拖曳出去的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
            [self.delegate didDragOutsideAction];
        }
    } else {
        self.isCancelled = YES;
    }
}

- (void)holdDownDragInside {
    
    //如果已經開始錄音了, 才需要做拖曳回來的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
            [self.delegate didDragInsideAction];
        }
    } else {
        self.isCancelled = YES;
    }
}


#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    self.faceSendButton.isFace = YES;
    self.voiceChangeButton.isVoice = YES;
    self.multiMediaSendButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidChange:)]) {
        [self.delegate inputTextViewDidChange:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
            [self.delegate didSendTextAction:textView.text];
        }
        return NO;
    }
    return YES;
}

#pragma mark - Message Input view frame
/**
 *  动态改变自身的高度和输入框的高度
 */
- (CGFloat)adjustTextViewHeight {
    
    CGFloat fnumLines = self.inputTextView.contentSize.height / [self textViewLineHeight];
    CGFloat numLines = roundf(fnumLines) + (fnumLines > roundf(fnumLines) ? 1 : 0);
    
    if (numLines > [self maxLines]) {
        numLines = [self maxLines];
    }
    
    self.inputTextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 5.0f : 0.0f),
                                                       0.0f,
                                                       (numLines >= 6 ? 5.0f : 0.0f),
                                                       0.0f);
    
    return numLines * [self textViewLineHeight] + _inputViewMargin*2;
}

/**
 *  获取输入框内容字体行高
 *
 *  @return 返回行高
 */
- (CGFloat)textViewLineHeight {
    return _inputTextView.font.lineHeight; // for fontSize 16.0f
}

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
- (CGFloat)maxLines {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 5.0f : 8.0f;
}

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
- (CGFloat)maxHeight {
    return ([self maxLines] + 1.0f) * [self textViewLineHeight]+4;
}

#pragma mark - ZCMEmoticonKeyboard Delegate
/**
 *  第三方gif表情被点击的回调事件
 *
 *  @param emoticon   被点击的gif表情Model
 *  @param indexPath 被点击的位置
 */
-(void)emoticonKeyboard:(ZCMEmoticonKeyboard *__unused)keyboard didSelectedEmoticon:(ZCMEmoticon *)emoticon atIndexPath:(NSIndexPath *__unused)indextPath {
    if (emoticon.emoticonType == ZCMEmoticonEmojiType || emoticon.emoticonType == ZCMEmoticonQQType) {
        if (emoticon.name.length > 0) {
            _inputTextView.text = [_inputTextView.text stringByAppendingString:emoticon.name];
        }
    } else {
        //TODO:直接发送表情
    }
}

/**
 *  删除按钮被点击的回调事件
 */
-(void)emoticonKeyboardDidPressBackspace:(ZCMEmoticonKeyboard *__unused)keyboard {
    [_inputTextView deleteBackward];
}

/**
 *  点击发送表情按钮
 */
- (void)didSelectedSendEmoticon {
    
}

/**
 *  点击表情商店按钮
 */
- (void)didSelectedEmoticonStore {
    if (!_keyboardManager) {
        [ZCMEmoticonStoreController showEmoticonStoreWithRootViewController:self.window.rootViewController];
        return;
    }
    
    [_keyboardManager doGotoEmoticonStore:^(BOOL finished) {
        if (finished) {
            [[ZCMMessageKeyboard sharedInstance] reloadKeyboard:ZCMKeyboardEmoticonType];
        }
    }];
}

/**
 *  点击表情管理按钮
 */
- (void)didSelectedSettingEmoticon {
    if (!_keyboardManager) {
        [ZCMEmoticonSettingController showEmoticonSettingWithRootViewController:self.window.rootViewController];
        return;
    }
    
    [_keyboardManager doGotoSettingEmoticon:^(BOOL finished) {
        if (finished) {
            [[ZCMMessageKeyboard sharedInstance] reloadKeyboard:ZCMKeyboardEmoticonType];
        }
    }];
}

/**
 *  点击自定义表情按钮
 */
- (void)didSelectedCustomEmoticon {
    if (!_keyboardManager) {
        [ZCMCustomEmoticonController showCustomEmoticonWithRootViewController:self.window.rootViewController];
        return;
    }
    
    [_keyboardManager doGotoCustomEmoticon:^(BOOL finished) {
        if (finished) {
            [[ZCMMessageKeyboard sharedInstance] reloadKeyboard:ZCMKeyboardEmoticonType];
        }
    }];
}

#pragma mark - ZCMShareMoreKeyboard dataSource
///**
// *  通过数据源获取统一管理一类多媒体功能的回调方法
// *
// *  @param column 列数
// *
// *  @return 返回统一管理多媒体功能的Model对象
// */
//- (ZCMShareMoreMenuItem *)shareItemInShareMoreKeyboard:(ZCMShareMoreKeyboard *)keyboard atSection:(NSInteger)section {
//    
//}
///**
// *  通过数据源获取一系列的统一管理多媒体功能的Model数组
// *
// *  @return 返回包含统一管理多媒体功能Model元素的数组
// */
//- (NSArray *)shareItemsInShareMoreKeyboard:(ZCMShareMoreKeyboard *)keyboard {
//    
//}
///**
// *  通过数据源获取总共有多少种多媒体功能
// *
// *  @return 返回总数
// */
//- (NSInteger)numberOfShareItemInShareMoreKeyboard:(ZCMShareMoreKeyboard *)keyboard {
//    
//}

#pragma mark - ZCMShareMoreKeyboard delegate
/**
 *  多媒体功能被点击 的delegate
 */
-(void)shareMoreKeyboard:(ZCMShareMoreKeyboard *__unused)keyboard didSelectedShareItem:(ZCMShareMoreMenuItem *)shareItem {
    if (shareItem.type == ZCMShareMenuOfPic) {
        [[self photoHelper] showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self.window.rootViewController completion:^(UIImage *seletedImage, NSDictionary *userInfo) {
            //TODO: 发送图片
        }];
    } else if (shareItem.type == ZCMShareMenuOfVideo) {
        [[self photoHelper] showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera onViewController:self.window.rootViewController completion:^(UIImage *seletedImage, NSDictionary *userInfo) {
            //TODO: 发送照片
        }];
    }
}

#pragma mark - ZCMMessageKeyboardProtocol
/**
 *  获取表情键盘的DataSource代理
 */
-(__weak id<ZCMEmoticonKeyboardDataSource>)getEmoticonKeyboardDataSource {
    return nil;     //采取默认的数据源
}
/**
 *  获取表情键盘的操作回调代理
 */
-(__weak id<ZCMEmoticonKeyboardDelegate>)getEmoticonKeyboardDelegate {
    return (id<ZCMEmoticonKeyboardDelegate>)self;
}
/**
 *  获取多媒体键盘的DataSource代理
 */
-(__weak id<ZCMShareMoreKeyboardDataSource>)getShareMoreKeyboardDataSource {
    return nil;         //采取默认的数据源
}
/**
 *  获取多媒体键盘的操作回调代理
 */
-(__weak id<ZCMShareMoreKeyboardDelegate>)getShareMoreKeyboardDelegate {
    return (id<ZCMShareMoreKeyboardDelegate>)self;
}

@end
