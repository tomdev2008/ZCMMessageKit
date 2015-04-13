//
//  ZCMMessageKeyboard.m
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMMessageKeyboard.h"
#import "ZCMMsgDisMacros.h"
#import "ZCMEmoticonKeyboard.h"
#import "ZCMShareMoreKeyboard.h"

NSString * const kZCMKeyboardWillShowNotification = @"kZCMKeyboardWillShowNotification";
NSString * const kZCMKeyboardWillHideNotification = @"kZCMKeyboardWillHideNotification";
NSString * const kZCMKeyboardDidShowNotification = @"kZCMKeyboardDidShowNotification";
NSString * const kZCMKeyboardDidHideNotification = @"kZCMKeyboardDidHideNotification";


@interface ZCMMessageKeyboard () {
    BOOL _showingKeyboard;
    BOOL _showingSysKeyboard;
}

@property (nonatomic, strong) ZCMEmoticonKeyboard *emoticonKeyboard;
@property (nonatomic, strong) ZCMShareMoreKeyboard *sharemoreKeyboard;

@property (nonatomic, weak) id<ZCMMessageKeyboardProtocol> delegate;

@end


/**
 *  自定义键盘所显示的window
 */
static UIWindow *_keyboardWindow;

static ZCMMessageKeyboard *_instance = nil;


@implementation ZCMMessageKeyboard

+(UIWindow *)getKeyboardWindow {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat scrHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat scrWidth = [UIScreen mainScreen].bounds.size.width;
        _keyboardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, scrHeight, scrWidth, kZCMEmoticonKeyboardHeight)];
        _keyboardWindow.windowLevel = UIWindowLevelNormal+1;
        _keyboardWindow.hidden = NO;
       // [_keyboardWindow makeKeyAndVisible];
    });
    
    return _keyboardWindow;
}

+(ZCMMessageKeyboard *)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZCMMessageKeyboard alloc] init];
    });
    
    return _instance;
}

+(instancetype)new {
    return [ZCMMessageKeyboard sharedInstance];
}

-(instancetype)init {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((obj=[super init]) != nil) {
            [obj setupKeyboardObserver];
        }
    });
    self = obj;

    return self;
}

 //重写该方法，控制内存的分配，永远只分配一次存储空间
+(id)allocWithZone:(struct _NSZone *)zone {
    //里面的代码只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance =[super allocWithZone:zone];
    });
    
    return _instance;
}

+(id)copyWithZone:(struct _NSZone *)zone {
        return _instance;
}

-(void)dealloc {
    [self removeKeyboardObserver];
    _emoticonKeyboard = nil;
    _sharemoreKeyboard = nil;
}

-(UIWindow *)window {
    return [ZCMMessageKeyboard getKeyboardWindow];
}

-(ZCMBaseKeyboard *)getKeyboard:(ZCMKeyboardType)type {
    if (type == ZCMKeyboardShareMoreType) {
        [_emoticonKeyboard hide];
        
        if (!_sharemoreKeyboard) {
            _sharemoreKeyboard = [[ZCMShareMoreKeyboard alloc] init];
        }
        
        _sharemoreKeyboard.dataSource = [_delegate getShareMoreKeyboardDataSource];
        _sharemoreKeyboard.delegate = [_delegate getShareMoreKeyboardDelegate];
        
        return _sharemoreKeyboard;
    } else {
        [_sharemoreKeyboard hide];
        
        if (!_emoticonKeyboard) {
            _emoticonKeyboard = [[ZCMEmoticonKeyboard alloc] init];
        }
        
        _emoticonKeyboard.dataSource = [_delegate getEmoticonKeyboardDataSource];
        _emoticonKeyboard.delegate = [_delegate getEmoticonKeyboardDelegate];
        
        return _emoticonKeyboard;
    }
}

-(void)showKeyboard:(ZCMKeyboardType)type target:(id<ZCMMessageKeyboardProtocol>)target {
    _delegate = target;
    _delegateHash = [target hash];
    
    ZCMBaseKeyboard *keyboard = [self getKeyboard:type];
    UIView *view = [keyboard view];

    if (!view) {
        _delegate = nil;
        _delegateHash = 0;
        return;
    }
    
    _showingKeyboard = YES;
    
    __block CGRect winRect = [ZCMMessageKeyboard getKeyboardWindow].frame;
    __block CGRect keyboardRect = view.frame;
    if (winRect.origin.y != ZCMMSG_ScreenHeight - kZCMEmoticonKeyboardHeight) {
        [self postEmoticonKeyboardNotification:YES will:YES];
        keyboardRect.origin.y = 0;
    } else {
        keyboardRect.origin.y = winRect.size.height;
    }
    view.frame = keyboardRect;
    
    if ([[ZCMMessageKeyboard getKeyboardWindow].subviews containsObject:view]) {
        [[ZCMMessageKeyboard getKeyboardWindow] bringSubviewToFront:view];
    } else {
        [[ZCMMessageKeyboard getKeyboardWindow] addSubview:view];
    }
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (winRect.origin.y != ZCMMSG_ScreenHeight - kZCMEmoticonKeyboardHeight) {
            winRect.origin.y = ZCMMSG_ScreenHeight - kZCMEmoticonKeyboardHeight;
            [ZCMMessageKeyboard getKeyboardWindow].frame = winRect;
        } else {
            keyboardRect.origin.y = 0;
            view.frame = keyboardRect;
        }
        
        for (UIView *subview in [ZCMMessageKeyboard getKeyboardWindow].subviews) {
            if (subview != view) {
                CGRect rect = subview.frame;
                rect.origin.y = winRect.size.height;
                subview.frame = rect;
            }
        }
    } completion:^(BOOL finished) {
        [self postEmoticonKeyboardNotification:YES will:NO];
        _showingKeyboard = NO;
        
        [keyboard reloadData];
    }];
}

-(void)hide {
    _delegateHash = 0;
    _delegate = nil;
    [_emoticonKeyboard hide];
    [_sharemoreKeyboard hide];
    
    [self hideShouldPostNotification:!_showingSysKeyboard];
}

/**
 *  隐藏键盘时 是否广播键盘隐藏消息
 *
 *  should==YES 广播， 否则 不广播
 */
-(void)hideShouldPostNotification:(BOOL)should {
    __block CGRect rect = [ZCMMessageKeyboard getKeyboardWindow].frame;
    if (rect.origin.y < ZCMMSG_ScreenHeight) {
        if (should) {
            [self postEmoticonKeyboardNotification:NO will:YES];
        }
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            rect.origin.y = ZCMMSG_ScreenHeight;
            [ZCMMessageKeyboard getKeyboardWindow].frame = rect;
        } completion:^(BOOL finished) {
            if (should) {
                [self postEmoticonKeyboardNotification:NO will:NO];
            }
        }];
    }
}

/**
 *  根据类型刷新键盘
 */
-(void)reloadKeyboard:(ZCMKeyboardType)type {
    if (type == ZCMKeyboardShareMoreType) {
        [_sharemoreKeyboard reloadData];
    } else {
        [_emoticonKeyboard reloadData];
    }
}

#pragma mark - keyboard
- (void)setupKeyboardObserver {
    // 键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Gestures


#pragma mark - Keyboard notifications

- (void)handleKeyboardDidShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kZCMKeyboardDidShowNotification object:self userInfo:notification.userInfo];
    _showingSysKeyboard = NO;
}

- (void)handleKeyboardDidHideNotification:(NSNotification *)notification {
    if (!_showingKeyboard) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kZCMKeyboardDidHideNotification object:self userInfo:notification.userInfo];
    }
}

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification {
    _showingSysKeyboard = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kZCMKeyboardWillShowNotification object:self userInfo:notification.userInfo];
    [self hide];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification {
    if (!_showingKeyboard) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kZCMKeyboardWillHideNotification object:self userInfo:notification.userInfo];
    }
}

- (void)postEmoticonKeyboardNotification:(BOOL)show will:(BOOL)will {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(UIViewAnimationCurveEaseInOut) forKey:UIKeyboardAnimationCurveUserInfoKey];
    [userInfo setObject:@(0.20) forKey:UIKeyboardAnimationDurationUserInfoKey];
    [userInfo setObject:@(0.20) forKey:UIKeyboardFrameEndUserInfoKey];
    
    NSString *notName = kZCMKeyboardWillShowNotification;
    CGFloat scrHeight = ZCMMSG_ScreenHeight;
    CGFloat scrWidth = ZCMMSG_ScreenWidth;
    CGRect frame = CGRectMake(0, scrHeight-kZCMEmoticonKeyboardHeight, scrWidth, kZCMEmoticonKeyboardHeight);
    if (show && will) {
        notName = kZCMKeyboardWillShowNotification;
    } else if (show && !will) {
        notName = kZCMKeyboardDidShowNotification;
    } else if (!show && will) {
        notName = kZCMKeyboardWillHideNotification;
        frame =  CGRectMake(0, scrHeight, scrWidth, kZCMEmoticonKeyboardHeight);
    } else {
        notName = kZCMKeyboardDidHideNotification;
        frame =  CGRectMake(0, scrHeight, scrWidth, kZCMEmoticonKeyboardHeight);
    }
    [userInfo setObject:[NSValue valueWithCGRect:frame] forKey:UIKeyboardFrameEndUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notName object:[self class] userInfo:userInfo];
}


@end
