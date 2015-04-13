//
//  ZCMEmoticonKeyboardToolBar.m
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMEmoticonKeyboardToolBar.h"
#import "ZCMEmoticonMgr.h"

#import "ZCMEmoticonHandler.h"

#define kEmoticonSectionBarItemWidth             60


@interface ZCMEmoticonKeyboardToolBar ()

@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  表情商店
 */
@property (nonatomic, strong) UIButton *storeButton;
/**
 *  发送
 */
@property (nonatomic, strong) UIButton *sendButton;
/**
 *  当前选中的表情类别
 */
@property (nonatomic, assign) NSInteger seletedIndex;
/**
 *  subviews水平布局的约束
 */
@property (nonatomic, strong) NSArray *horizontalContraints;
/**
 *  storeButton 的布局约束
 */
@property (nonatomic, strong) NSArray *storeVerticalContraints;
@property (nonatomic, strong) NSArray *storeHorizontalContraints;

@end

@implementation ZCMEmoticonKeyboardToolBar

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"emoticonMgrs"];
    self.emoticonMgrs = nil;
    self.storeButton = nil;
    self.sendButton = nil;
    self.horizontalContraints = nil;
    self.storeVerticalContraints = nil;
    self.storeHorizontalContraints = nil;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

- (UIButton *)createdButtonWithImage:(UIImage *)img {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.translatesAutoresizingMaskIntoConstraints = NO;
    button.frame = CGRectMake(0, 0, kEmoticonSectionBarItemWidth, kZCMEmoticonSectionBarHeight);
    [button setBackgroundImage:[UIImage imageNamed:@"EmoticonsBagTabBg"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"EmoticonsBagTabBgFocus"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"EmoticonsBagTabBgFocus"] forState:UIControlStateSelected];
    if (img) {
        [button setImage:img forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)reloadData {
    if (0 == _emoticonMgrs.count) {
        return;
    }
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger index = 0;
    UIButton *button = nil;
    for (ZCMEmoticonMgr *emoticonMgr in _emoticonMgrs) {
        button = [self createdButtonWithImage:emoticonMgr.emoticonConverPicture];
        button.tag = index;
        
        CGRect rect = button.frame;
        rect.origin.x = index * (CGRectGetWidth(rect));
        button.frame = rect;
        
        [_scrollView addSubview:button];
        
        if (index==_seletedIndex) {
            button.selected = YES;
            if ([self.delegate respondsToSelector:@selector(didSelectedEmoticonMgr:atSection:)]) {
                [self.delegate didSelectedEmoticonMgr:emoticonMgr atSection:index];
            }
        } else {
            button.selected = NO;
        }
        
        ++index;
    }
    
    //[self.scrollView setContentSize:CGSizeMake(self.emoticonMgrs.count * kEmoticonSectionBarItemWidth, CGRectGetHeight(self.bounds))];
    [self relayoutToolBar];
}

/**
 *  重新布局Toolbar
 */
-(void)relayoutToolBar {
    BOOL shouldShowSendBtn = YES;
    
    if (_seletedIndex >= 0 && _seletedIndex < _emoticonMgrs.count) {
        ZCMEmoticonMgr *emtMgr = [_emoticonMgrs objectAtIndex:_seletedIndex];
        if (emtMgr.emoticonType == ZCMEmoticonEmojiType || emtMgr.emoticonType == ZCMEmoticonQQType) {
            shouldShowSendBtn = YES;
        } else {
            shouldShowSendBtn = NO;
        }
    }
    
    if (shouldShowSendBtn) {
        _storeButton.translatesAutoresizingMaskIntoConstraints = YES;
        if (_storeButton.superview != _scrollView) {
            [_storeButton removeFromSuperview];
        }
        if (!_storeButton.superview) {
            CGRect rect = _storeButton.frame;
            rect.origin.x = self.emoticonMgrs.count * kEmoticonSectionBarItemWidth;
            _storeButton.frame = rect;
            [_scrollView addSubview:_storeButton];
        }
        
        [self.scrollView setContentSize:CGSizeMake((self.emoticonMgrs.count+1) * kEmoticonSectionBarItemWidth, CGRectGetHeight(self.bounds))];
    } else {
        _storeButton.translatesAutoresizingMaskIntoConstraints = NO;
        if (_storeButton.superview != self) {
            [_storeButton removeFromSuperview];
        }
        if (!_storeButton.superview) {
            [self addSubview:_storeButton];
        }
        [self.scrollView setContentSize:CGSizeMake(self.emoticonMgrs.count * kEmoticonSectionBarItemWidth, CGRectGetHeight(self.bounds))];
    }
    
    [self resetupSubviewsContraintsForShouldShowStore:!shouldShowSendBtn];
}


#pragma mark - Lefy cycle

- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (!_scrollView) {
        UIScrollView *sectionBarScrollView = [UIScrollView new];
        sectionBarScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [sectionBarScrollView setScrollsToTop:NO];
        sectionBarScrollView.scrollEnabled = YES;
        sectionBarScrollView.bounces = YES;
        sectionBarScrollView.showsVerticalScrollIndicator = NO;
        sectionBarScrollView.showsHorizontalScrollIndicator = NO;
        sectionBarScrollView.pagingEnabled = NO;
        [self addSubview:sectionBarScrollView];
        _scrollView = sectionBarScrollView;
    }
    
    UIButton *button = [self createdButtonWithImage:[UIImage imageNamed:@"EmoticonsBagAdd"]];
    [button setBackgroundImage:[UIImage imageNamed:@"EmoticonsStoreTabBg"] forState:UIControlStateNormal];
    [button removeTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(storeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.storeButton = button;
        
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setBackgroundImage:[UIImage imageNamed:@"EmoticonsSendBtnGrey"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"EmoticonsSendBtnBlue"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"EmoticonsSendBtnBlue"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitle:@"发送"  forState:UIControlStateHighlighted];
    button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(sendEmoticonButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.sendButton = button;
    
    
    [self setupSubviewsContraints];
    
    //emoticonMgrs KVO,观察emoticonMgrs
    [self addObserver:self forKeyPath:@"emoticonMgrs" options:NSKeyValueObservingOptionNew |
     NSKeyValueObservingOptionInitial context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoticonsChanged:) name:kZCMEmoticonsChangedNotification object:nil];
}

-(void)emoticonsChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

#pragma mark - Key-value Observing
//emoticonMgrs KVO,观察到emoticonMgrs改变时reloadData
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"emoticonMgrs"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }
}

/**
 *  设置subviews约束
 */
-(void)setupSubviewsContraints {
    //autolayout 布局，约束条件
    NSDictionary *metrics = @{@"margin":@0, @"w":@70};
    NSDictionary *views = NSDictionaryOfVariableBindings(self,_scrollView, _sendButton);
    
    [self resetupSubviewsContraintsForShouldShowStore:NO];
    
    NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [self addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sendButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
    [self addConstraints:c];
}

/**
 *  重新设置约束
 */
-(void)resetupSubviewsContraintsForShouldShowStore:(BOOL)showStoreBtn {
//    if (_storeHorizontalContraints) {
//        [self removeConstraints:_storeHorizontalContraints];
//        _storeHorizontalContraints = nil;
//    }
//    if (_storeVerticalContraints) {
//        [self removeConstraints:_storeVerticalContraints];
//        _storeVerticalContraints = nil;
//    }
  //  [_scrollView removeConstraints:_scrollView.constraints];
    
    BOOL shouldUpdate = NO;
    
    //autolayout 布局，约束条件
    NSDictionary *metrics = @{@"margin":@0, @"sendW":@70, @"storeW":@(kEmoticonSectionBarItemWidth), @"nStoreW":@(-70)};
    NSDictionary *views = NSDictionaryOfVariableBindings(self,_scrollView, _sendButton, _storeButton);
    if (!_horizontalContraints) {
        NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"|-margin-[_scrollView]-(-10)-[_sendButton(sendW)]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
        _horizontalContraints = c;
        [self addConstraints:_horizontalContraints];
    }
    if (!showStoreBtn) {
        //else {
            for (NSLayoutConstraint *cont in _horizontalContraints) {
                if (cont.firstItem == _sendButton && cont.firstAttribute == NSLayoutAttributeLeading && cont.constant != -10) {
                    cont.constant = -10;
                    shouldUpdate = YES;
                } else if (cont.secondItem == _sendButton && cont.secondAttribute == NSLayoutAttributeTrailing && cont.constant != 0) {
                    cont.constant = 0;
                    shouldUpdate = YES;
                }
            }
        //}
       // [_sendButton removeConstraints:_sendButton.constraints];
    } else {
        for (NSLayoutConstraint *cont in _horizontalContraints) {
            if (cont.firstItem == _sendButton && cont.firstAttribute == NSLayoutAttributeLeading && cont.constant != 70) {
                cont.constant = 60;
                shouldUpdate = YES;
            } else if (cont.secondItem == _sendButton && cont.secondAttribute == NSLayoutAttributeTrailing && cont.constant != -70) {
                cont.constant = -70;
                shouldUpdate = YES;
            }
        }
        
        if (!_storeHorizontalContraints) {
            NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"[_storeButton(storeW)]-margin-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
            _storeHorizontalContraints = c;
            [_storeButton removeConstraints:_storeButton.constraints];
            
            c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_storeButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
            _storeVerticalContraints = c;
        }
        
        if (![self.constraints containsObject:[_storeHorizontalContraints firstObject]]) {
            [self addConstraints:_storeHorizontalContraints];
            [self addConstraints:_storeVerticalContraints];
        }
    }
    
    if (shouldUpdate) {
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 *  刷新tool bar item选中状态
 */
-(void)refreshToolBarSelectedStatus:(UIButton *)sender {
    for (UIButton *btn in _scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    
    _seletedIndex = sender.tag;
    sender.selected = YES;
    
    [self relayoutToolBar];
}

/**
 *  表情类别 clicked 处理事件
 */
- (void)sectionButtonClicked:(UIButton *)sender {
    if (_seletedIndex == sender.tag) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectedEmoticonMgr:atSection:)]) {
        NSInteger section = sender.tag;
        if (section < self.emoticonMgrs.count) {
            if ([self.delegate respondsToSelector:@selector(shouldShowSelectedStatusForEmoticonMgr:atSection:)]) {
                if ([self.delegate shouldShowSelectedStatusForEmoticonMgr:[self.emoticonMgrs objectAtIndex:section] atSection:section]) {
                    [self refreshToolBarSelectedStatus:sender];
                }
            }
            
            [self.delegate didSelectedEmoticonMgr:[self.emoticonMgrs objectAtIndex:section] atSection:section];
        }
    }
}

/**
 *  表情商店 clicked 处理事件
 */
-(void)storeButtonClicked {
    if ([self.delegate respondsToSelector:@selector(didSelectedEmoticonStore)]) {
        [self.delegate didSelectedEmoticonStore];
    }
}

/**
 *  发送按钮 clicked 处理事件
 */
-(void)sendEmoticonButtonClicked {
    if ([self.delegate respondsToSelector:@selector(didSelectedSendEmoticon)]) {
        [self.delegate didSelectedSendEmoticon];
    }
}


@end
