//
//  ZCMFaceSendButton.m
//  zcm
//
//  Created by cnstar on 21/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMFaceSendButton.h"

@implementation ZCMFaceSendButton

-(instancetype)init {
    self = [super init];
    if (self) {
        self.isFace = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isFace = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isFace = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

-(void)setIsFace:(BOOL)isFace {
    _isFace = isFace;
    if (isFace) {
        [super setBackgroundImage:[UIImage imageNamed:@"ToolViewEmoticon"] forState:UIControlStateNormal];
        [super setBackgroundImage:[UIImage imageNamed:@"ToolViewEmoticonHL"] forState:UIControlStateHighlighted];
    } else {
        [super setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        [super setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
    }
}

@end
