//
//  ZCMVoiceChangeButton.m
//  zcm
//
//  Created by cnstar on 21/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMVoiceChangeButton.h"

@implementation ZCMVoiceChangeButton

-(instancetype)init {
    self = [super init];
    if (self) {
        self.isVoice = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isVoice = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isVoice = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

-(void)setIsVoice:(BOOL)isVoice {
    _isVoice = isVoice;
    if (isVoice) {
        [self setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
    } else {
        [self setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
    }
}

@end
