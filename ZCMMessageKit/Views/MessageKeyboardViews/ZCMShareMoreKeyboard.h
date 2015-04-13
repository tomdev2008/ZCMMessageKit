//
//  ZCMShareMoreKeyboard.h
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMBaseKeyboard.h"
#import "ZCMMessageKeyboardProtocol.h"

@interface ZCMShareMoreKeyboard : ZCMBaseKeyboard

@property (nonatomic, weak) id <ZCMShareMoreKeyboardDelegate> delegate;

@property (nonatomic, weak) id <ZCMShareMoreKeyboardDataSource> dataSource;

@end
