//
//  ZCMEmoticonCollectionViewCell.m
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMEmoticonCollectionViewCell.h"

@interface ZCMEmoticonCollectionViewCell ()

/**
 *  显示表情封面的控件
 */
@property (nonatomic, weak) UIButton *emoticonButton;

/**
 *  配置默认控件和参数
 */
- (void)setup;

@end

@implementation ZCMEmoticonCollectionViewCell

#pragma setter method

- (void)setEmoticon:(ZCMEmoticon *)emoticon {
    _emoticon = emoticon;
    
    if (!_emoticon) {
        self.emoticonButton.hidden = YES;
        return;
    }
    
    self.emoticonButton.hidden = NO;
    if (_emoticon.emoticonType == ZCMEmoticonEmojiType) {
        [self.emoticonButton setImage:nil forState:UIControlStateNormal];
        [self.emoticonButton setTitle:_emoticon.name forState:UIControlStateNormal];
    } else {
        [self.emoticonButton setTitle:nil forState:UIControlStateNormal];
        
        UIImage *img = nil;
        if (_emoticon.emoticonConverPicture) {
            img = _emoticon.emoticonConverPicture;
        } else {
            if (_emoticon.isBundleRes) {
                img = [UIImage imageNamed:_emoticon.emoticonPath];
            } else {
                img = [UIImage imageWithContentsOfFile:_emoticon.emoticonPath];;
            }
        }
        [self.emoticonButton setImage:img forState:UIControlStateNormal];
    }
}

#pragma mark - Life cycle

- (void)setup {
    if (!_emoticonButton) {
        UIButton *emoticonButton = [UIButton new];
        emoticonButton.translatesAutoresizingMaskIntoConstraints = NO;
        emoticonButton.imageView.contentMode = UIViewContentModeCenter;
        emoticonButton.backgroundColor = [UIColor clearColor];
        emoticonButton.titleLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:28.0];
        [emoticonButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:emoticonButton];
        self.emoticonButton = emoticonButton;
        
        //autolayout 布局，约束条件
        NSDictionary *views = NSDictionaryOfVariableBindings(_emoticonButton);
        NSArray *c = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_emoticonButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
        [self.contentView addConstraints:c];
        c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_emoticonButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views];
        [self.contentView addConstraints:c];
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
    self.emoticon = nil;
}

-(void)clicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(emoticonCollectionViewCell:didSelectedEmoticon:)]) {
        [self.delegate emoticonCollectionViewCell:self didSelectedEmoticon:_emoticon];
    }
}

@end
