//
//  ZCMBaseKeyboard.m
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMBaseKeyboard.h"
#import "ZCMMessageKeyboard.h"

@interface ZCMBaseKeyboard ()

@property (nonatomic, strong) UIView *keyboard;

@end

@implementation ZCMBaseKeyboard


-(UIView *)view {
    return _keyboard;
}

#pragma mark - Life cycle

- (void)setupKeyboard {
    UIImage *bgImg = [UIImage imageNamed:@"EmoticonPanelBkg"];
    UIImageView *view = [UIImageView new];
    view.image = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(10, bgImg.size.width/2-1, bgImg.size.height-10, bgImg.size.width/2+1)];
    view.userInteractionEnabled = YES;
    //view.translatesAutoresizingMaskIntoConstraints = NO;
    view.frame = [ZCMMessageKeyboard sharedInstance].window.bounds;
    //[[ZCMMessageKeyboard sharedInstance].window addSubview:view];
    
    self.keyboard = view;
    
    [self setup];
}

-(void)setup {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialization code
        [self setupKeyboard];
    }
    return self;
}

- (void)dealloc {
    _keyboard = nil;
}

/**
 *  隐藏键盘, delegate自动置nil
 */
-(void)hide {
    
}

/**
 *  根据数据源刷新UI布局和数据
 */
-(void)reloadData {
    
}

@end
