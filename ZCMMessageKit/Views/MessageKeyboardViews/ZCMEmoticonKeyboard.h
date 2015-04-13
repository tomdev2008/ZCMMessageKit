//
//  ZCMEmoticonKeyboard.h
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMBaseKeyboard.h"
#import "ZCMMessageKeyboardProtocol.h"





//
//
//  ZCMEmoticonKeyboard
//
//
//
@interface ZCMEmoticonKeyboard : ZCMBaseKeyboard

@property (nonatomic, weak) id <ZCMEmoticonKeyboardDelegate> delegate;

@property (nonatomic, weak) id <ZCMEmoticonKeyboardDataSource> dataSource;

@end




