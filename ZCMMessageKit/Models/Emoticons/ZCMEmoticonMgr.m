//
//  ZCMEmoticonMgr.m
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMEmoticonMgr.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

@implementation ZCMEmoticonMgr

- (void)dealloc {
    self.emoticonName = nil;
    self.emoticonConverPicture = nil;
    self.emoticons = nil;
}

-(NSUInteger)numberOfSections {
    if (_emoticonType == ZCMEmoticonEmojiType || _emoticonType == ZCMEmoticonQQType || _emoticonType == ZCMEmoticonTusijiType) {
        return 7;
    }
    return 4;
}

-(NSUInteger)numberOfRowsInSection {
    if (_emoticonType == ZCMEmoticonEmojiType || _emoticonType == ZCMEmoticonQQType || _emoticonType == ZCMEmoticonTusijiType) {
        return 3;
    }
    return 2;
}

-(CGFloat)emoticonWidth {
//    if (_emoticonType == ZCMEmoticonEmojiType || _emoticonType == ZCMEmoticonQQType) {
//        return SCREEN_WIDTH/[self numberOfSections];
//    }
//    return 75;
    
    return SCREEN_WIDTH/[self numberOfSections];
}

-(CGFloat)emoticonHeight {
//    if (_emoticonType == ZCMEmoticonEmojiType || _emoticonType == ZCMEmoticonQQType) {
//        return SCREEN_WIDTH/[self numberOfSections];
//    }
//    return 75;

    return [self emoticonWidth];
}

@end
