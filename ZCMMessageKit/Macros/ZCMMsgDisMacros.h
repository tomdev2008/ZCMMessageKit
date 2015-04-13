//
//  ZCMMsgDisMacros.h
//  zcm
//
//  Created by cnstar on 29/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#ifndef zcm_ZCMMsgDisMacros_h
#define zcm_ZCMMsgDisMacros_h

#define ZCMCLASSFROMESTORYBOARD(storyboardName, identifier) [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:identifier]

#define ZCMMSG_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZCMMSG_ScreenWidth  [UIScreen mainScreen].bounds.size.width

#endif
