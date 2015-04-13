//
//  ZCMShareMoreDataHandler.m
//  zcm
//
//  Created by cnstar on 31/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMShareMoreDataHandler.h"
#import "ZCMShareMoreMenuItem.h"
#import "ZCMShareMoreKeyboard.h"


@interface ZCMShareMoreDataHandler ()
/**
 *  所有表情类别 数组
 */
@property (nonatomic, strong) NSMutableArray *data;

@end

static ZCMShareMoreDataHandler *_instance = nil;

@implementation ZCMShareMoreDataHandler

+(ZCMShareMoreDataHandler *)sharedMoreDataHandler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZCMShareMoreDataHandler alloc] init];
    });
    
    return _instance;
}

+(instancetype)new {
    return [ZCMShareMoreDataHandler sharedMoreDataHandler];
}

-(instancetype)init {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((obj=[super init]) != nil) {
        }
    });
    self = obj;
    
    return self;
}

//重写该方法，控制内存的分配，永远只分配一次存储空间
+(id)allocWithZone:(struct _NSZone *)zone {
    //里面的代码只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance =[super allocWithZone:zone];
    });
    
    return _instance;
}

+(id)copyWithZone:(struct _NSZone *)zone {
    return _instance;
}


-(NSArray *)data {
    if (!_data) {
        NSArray *imgs = @[@"sharemore_pic", @"sharemore_myfav", @"sharemore_video", @"sharemore_location", @"sharemore_sight", @"sharemore_friendcard", @"sharemore_videovoip", @"sharemore_voiceinput", @"sharemore_wxtalk"];
        NSArray *names = @[@"照片", @"收藏", @"拍照", @"位置", @"小视频", @"名片", @"视频聊天", @"语音输入", @"实时对讲"];
        NSArray *types = @[@(ZCMShareMenuOfPic),@(ZCMShareMenuOfFav),@(ZCMShareMenuOfVideo),@(ZCMShareMenuOfLoc),@(ZCMShareMenuOfSight),@(ZCMShareMenuOfFC),@(ZCMShareMenuOfVideoVoip),@(ZCMShareMenuOfVoiceInput),@(ZCMShareMenuOfTalk)];
        
        NSMutableArray *array = [NSMutableArray array];
        int i = 0;
        for (NSString *img in imgs) {
            ZCMShareMoreMenuItem *item = [[ZCMShareMoreMenuItem alloc] init];
            item.image = [UIImage imageNamed:img];
            item.title = [names objectAtIndex:i];
            item.type = [[types objectAtIndex:i] integerValue];
            ++i;
            [array addObject:item];
        }
        
        self.data = array;
    }
    
    return _data;
}

#pragma mark - ZCMShareMoreKeyboard DataSource
/**
 *  通过数据源获取统一管理一类多媒体功能的回调方法
 *
 *  @param column 列数
 *
 *  @return 返回统一管理多媒体功能的Model对象
 */
- (ZCMShareMoreMenuItem *)shareItemInShareMoreKeyboard:(ZCMShareMoreKeyboard *__unused)keyboard atSection:(NSInteger)section {
    if (section >= 0 && [self data].count > section) {
        return [[self data] objectAtIndex:section];
    }
    
    return nil;
}

/**
 *  通过数据源获取一系列的统一管理多媒体功能的Model数组
 *
 *  @return 返回包含统一管理多媒体功能Model元素的数组
 */
- (NSArray *)shareItemsInShareMoreKeyboard:(ZCMShareMoreKeyboard *__unused)keyboard {
    return [self data];
}

/**
 *  通过数据源获取总共有多少种多媒体功能
 *
 *  @return 返回总数
 */
- (NSInteger)numberOfShareItemInShareMoreKeyboard:(ZCMShareMoreKeyboard *__unused)keyboard {
    return [[self data] count];
}


@end

