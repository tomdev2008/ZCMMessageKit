//
//  ZCMShareMoreMenuCell.m
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMShareMoreMenuCell.h"

@interface ZCMShareMoreMenuCell ()

/**
 *  显示多媒体功能的控件
 */
@property (nonatomic, weak) UIButton *shareButton;
@property (nonatomic, weak) UILabel *titleLabel;

/**
 *  配置默认控件和参数
 */
- (void)setup;

@end

@implementation ZCMShareMoreMenuCell

#pragma setter method

- (void)setShareItem:(ZCMShareMoreMenuItem *)shareItem {
    _shareItem = shareItem;
    
    if (!_shareItem) {
        self.shareButton.hidden = YES;
        self.titleLabel.hidden = YES;
        return;
    }
    
    self.shareButton.hidden = NO;
    self.titleLabel.hidden = NO;
    [self.shareButton setImage:_shareItem.image forState:UIControlStateNormal];
    self.titleLabel.text = _shareItem.title;
}

#pragma mark - Life cycle

- (void)setup {
    //self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!_shareButton) {
        UIButton *shareButton = [UIButton new];
        shareButton.translatesAutoresizingMaskIntoConstraints = NO;
        //shareButton.imageView.contentMode = UIViewContentModeCenter;
        [shareButton setBackgroundImage:[UIImage imageNamed:@"sharemore_other"] forState:UIControlStateNormal];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"sharemore_other_HL"] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:shareButton];
        self.shareButton = shareButton;
        
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:label];
        self.titleLabel = label;
        
        //autolayout 布局，约束条件
        UIView *contentView = self.contentView;
        NSDictionary *views = NSDictionaryOfVariableBindings(contentView, _shareButton, _titleLabel);
        
        CGFloat btnW = 59;
        NSDictionary *metrics = @{@"btnW":@(btnW)};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[contentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
        
        NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_shareButton]-0-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views];
        [contentView addConstraints:c];
        
        c = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_titleLabel]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
        [contentView addConstraints:c];
        
        c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_shareButton(btnW)]-5-[_titleLabel(15)]-|" options:0 metrics:metrics views:views];
        [contentView addConstraints:c];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.shareItem = nil;
}

-(void)clicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareMoreCollectionViewCell:didSelectedShareItem:)]) {
        [self.delegate shareMoreCollectionViewCell:self didSelectedShareItem:_shareItem];
    }
}

@end
