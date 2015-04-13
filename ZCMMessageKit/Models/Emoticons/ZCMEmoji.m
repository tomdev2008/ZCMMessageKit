//
//  ZCMEmoji.m
//  zcm
//
//  Created by cnstar on 28/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMEmoji.h"
#import "ZCMEmoticon.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24)

@implementation ZCMEmoji

+ (NSArray *)emojis {
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[ZCMEmoji allEmoticons]];
    [array addObjectsFromArray:[ZCMEmoji allOthers]];
    [array addObjectsFromArray:[ZCMEmoji allTrafifics]];
    //[array addObjectsFromArray:[ZCMEmoji allMapSymbols]];
    
    return array;
}

+ (ZCMEmoticon *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    
    ZCMEmoticon *emt = [[ZCMEmoticon alloc] init];
    emt.emoticonType = ZCMEmoticonEmojiType;
    emt.name = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
    
    return emt;
}

+ (NSArray *)allEmoticons {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            [array addObject:[ZCMEmoji emojiWithCode:i]];
        }
    }
    return array;
}

+ (NSArray *)allOthers {
    NSMutableArray *array = [NSMutableArray new];
    
    //月亮
//    for (int i=0x1F300; i<=0x1F320; i++) {
//        [array addObject:[ZCMEmoji emojiWithCode:i]];
//    }
    
    //花草
//    for (int i=0x1F330; i<=0x1F335; i++) {
//        [array addObject:[ZCMEmoji emojiWithCode:i]];
//    }
    
    
//    for (int i=0x1F3A0; i<=0x1F3C4; i++) {
//        [array addObject:[ZCMEmoji emojiWithCode:i]];
//    }
//    
//    for (int i=0x1F3C6; i<=0x1F3CA; i++) {
//        [array addObject:[ZCMEmoji emojiWithCode:i]];
//    }
    
    //房子
//    for (int i=0x1F3E0; i<=0x1F3F0; i++) {
//        [array addObject:[ZCMEmoji emojiWithCode:i]];
//    }
    
    for (int i=0x1F400; i<=0x1F43E; i++) {
        [array addObject:[ZCMEmoji emojiWithCode:i]];
    }
    
    [array addObject:[ZCMEmoji emojiWithCode:0x1F440]];
    
    for (int i=0x1F442; i<=/*0x1F4B9*/0x1F491; i++) {
        [array addObject:[ZCMEmoji emojiWithCode:i]];
    }
    
//    for (int i=0x1F380; i<=0x1F393; i++) {
//        [array addObject:[ZCMEmoji emojiWithCode:i]];
//    }
    
    for (int i=/*0x1F337*/0x1F345; i<=0x1F37C; i++) {
        [array addObject:[ZCMEmoji emojiWithCode:i]];
    }
    
//    for (int i=0x1F4B9; i<=0x1F4F5; i++) {
//        [array addObject:[ZCMEmoji emojiWithCode:i]];
//    }
    
    return array;
}

+ (NSArray *)allTrafifics {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F680; i<=0x1F69D/*0x1F6A4*/; i++) {
        [array addObject:[ZCMEmoji emojiWithCode:i]];
    }
    return array;
}

+ (NSArray *)allMapSymbols {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F6A5; i<=0x1F6C5; i++) {
        [array addObject:[ZCMEmoji emojiWithCode:i]];
    }
    return array;
}


@end
