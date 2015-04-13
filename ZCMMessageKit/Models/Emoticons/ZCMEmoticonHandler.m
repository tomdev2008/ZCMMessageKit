//
//  ZCMEmoticonHandler.m
//  zcm
//
//  Created by cnstar on 22/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMEmoticonHandler.h"
#import "ZCMEmoticonKeyboard.h"
#import "ZCMEmoji.h"
#import "ZCMFace.h"
#import "ZCMCustomEmoticon.h"



 NSString * const kZCMEmoticonsChangedNotification = @"kZCMEmoticonsChangedNotification";


@interface ZCMEmoticonHandler ()
/**
 *  所有表情类别 数组
 */
@property (nonatomic, strong) NSMutableArray *emoticonMgrs;

@end

static ZCMEmoticonHandler *_instance = nil;

@implementation ZCMEmoticonHandler

+(ZCMEmoticonHandler *)sharedEmoticonHandler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZCMEmoticonHandler alloc] init];
    });
    
    return _instance;
}

+(instancetype)new {
    return [ZCMEmoticonHandler sharedEmoticonHandler];
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


/**
 *  QQ表情
 */
-(ZCMEmoticonMgr *)qqFaces {
    ZCMEmoticonMgr *emtMgr = [[ZCMEmoticonMgr alloc] init];
    emtMgr.emoticonType = ZCMEmoticonQQType;
    emtMgr.emoticonName = @"表情";
    emtMgr.emoticonConverPicture = [UIImage imageNamed:@"EmoticonsQQFaceHL"];
    emtMgr.emoticons = [ZCMFace faces];
    
    return emtMgr;
}

/**
 *  系统emoji表情
 */
-(ZCMEmoticonMgr *)emoji {
    ZCMEmoticonMgr *emtMgr = [[ZCMEmoticonMgr alloc] init];
    emtMgr.emoticonConverPicture = [UIImage imageNamed:@"EmoticonsEmojiHL"];
    emtMgr.emoticonName = @"Emoji";
    emtMgr.emoticonType = ZCMEmoticonEmojiType;
    emtMgr.emoticons = [ZCMEmoji emojis];
    
    return emtMgr;
}

/**
 *  浪小花表情
 */
-(ZCMEmoticonMgr *)tusiji {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lxh" ofType:@"plist"];
    NSDictionary *fileData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSArray *data = [fileData valueForKey:@"emoticon_group_emoticons"];
    
    ZCMEmoticonMgr *emtMgr = [[ZCMEmoticonMgr alloc] init];
    emtMgr.emoticonConverPicture = [UIImage imageNamed:@"EPackageTusijiImage"];
    emtMgr.emoticonType = ZCMEmoticonTusijiType;
    emtMgr.emoticonName = @"浪小花";
    NSMutableArray *emts = [NSMutableArray array];
    for (NSDictionary *value in data) {
        //NSLog(@"%@", value);
        ZCMEmoticon *emt = [[ZCMEmoticon alloc] init];
        emt.emoticonType = ZCMEmoticonTusijiType;
        emt.name = [value valueForKey:@"chs"];
        emt.emoticonPath = [value valueForKey:@"png"];
        emt.isBundleRes = YES;
        [emts addObject:emt];
    }
    emtMgr.emoticons = emts;
    
    return emtMgr;
}

/**
 *  获取所有表情类别
 */
-(NSArray *)emoticonMgrs {
    if (!_emoticonMgrs) {
        NSMutableArray *emoticons = [NSMutableArray array];
        
        ZCMEmoticonMgr *emtMgr = nil;
        
        [emoticons addObject:[self emoji]];          //系统emoji表情
        [emoticons addObject:[self qqFaces]];        //QQ表情
        [emoticons addObject:[self tusiji]];         //浪小花表情
        
        emtMgr = [[ZCMEmoticonMgr alloc] init];
        emtMgr.emoticonType = ZCMEmoticonCustomType;     //自定义表情
        emtMgr.emoticonConverPicture = [UIImage imageNamed:@"EmoticonCustomHL"];
        emtMgr.emoticons = [ZCMCustomEmoticon emoticons];
        [emoticons addObject:emtMgr];
        
        emtMgr = [[ZCMEmoticonMgr alloc] init];
        emtMgr.emoticonType = ZCMEmoticonSettingType;     //表情管理
        emtMgr.emoticonConverPicture = [UIImage imageNamed:@"EmoticonsSetting"];
        [emoticons addObject:emtMgr];
        
        
        _emoticonMgrs = emoticons;
    }
    
    return _emoticonMgrs;
}

-(void)postNotificationForEmoticonChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:kZCMEmoticonsChangedNotification object:self];
}

/**
 *  根据表情类别获取某一类表情
 */
-(ZCMEmoticonMgr *)emoticonMgrWithEmoticonType:(ZCMEmoticonType)type error:(NSError *__autoreleasing *)error {
    if (type == ZCMEmoticonStoreType) {
        if (!error) {
            *error = [NSError errorWithDomain:nil code:-1 userInfo:[NSDictionary dictionaryWithObject:@"想要获取从商店下载的表情，不能调用此方法。请调用emoticonMgrWithEmoticonName:name" forKey:@"desc"]];
        }
        
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"emoticonType==%ld",(long)type];
    NSArray *results = [_emoticonMgrs filteredArrayUsingPredicate:predicate];
    return [results firstObject];
}

/**
 *  根据表情类别名字获取某一类表情
 */
-(ZCMEmoticonMgr *)emoticonMgrWithEmoticonName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"emoticonName==%@",name];
    NSArray *results = [_emoticonMgrs filteredArrayUsingPredicate:predicate];
    return [results firstObject];
}

/**
 *  根据表情类别更新某一类表情
 */
-(void)updateEmoticonMgrsWithEmoticonMgr:(ZCMEmoticonMgr *)emoticonMgr {
    if (!emoticonMgr) {
        return;
    }
    ZCMEmoticonMgr *emtMgr = [self emoticonMgrWithEmoticonName:emoticonMgr.emoticonName];
    if (!emtMgr && emtMgr.emoticonType != ZCMEmoticonStoreType) {
        emtMgr = [self emoticonMgrWithEmoticonType:emoticonMgr.emoticonType error:nil];
    }
    
    if (emtMgr) {
        emtMgr.emoticons = emoticonMgr.emoticons;
    } else {
        [_emoticonMgrs insertObject:emoticonMgr atIndex:2];
    }
    [self postNotificationForEmoticonChanged];
}

#pragma mark - ZCMEmoticonKeyboard DataSource
/**
 *  通过数据源获取统一管理一类表情的回调方法
 *
 *  @param column 列数
 *
 *  @return 返回统一管理表情的Model对象
 */
- (ZCMEmoticonMgr *)emoticonMgrInEmoticonKeyboard:(ZCMEmoticonKeyboard *__unused)keyboard atSection:(NSInteger)section {
    if (section >= 0 && [self emoticonMgrs].count > section) {
        return [[self emoticonMgrs] objectAtIndex:section];
    }
    
    return nil;
}

/**
 *  通过数据源获取一系列的统一管理表情的Model数组
 *
 *  @return 返回包含统一管理表情Model元素的数组
 */
- (NSArray *)emoticonMgrsInEmoticonKeyboard:(ZCMEmoticonKeyboard *__unused)keyboard {
    return [self emoticonMgrs];
}

/**
 *  通过数据源获取总共有多少类gif表情
 *
 *  @return 返回总数
 */
- (NSInteger)numberOfEmoticonMgrsInEmoticonKeyboard:(ZCMEmoticonKeyboard *__unused)keyboard {
    return [[self emoticonMgrs] count];
}

/**
 *  通过数据源 返回是否需要删除按钮
 *
 *  @param column 列数
 *
 *  @return 返回是否需要删除按钮
 */
- (BOOL)shouldShowDeleteActionInEmoticonKeyboard:(ZCMEmoticonKeyboard *)keyboard atSection:(NSInteger)section {
    ZCMEmoticonMgr *emoticonMgr = [self emoticonMgrInEmoticonKeyboard:keyboard atSection:section];
    if (emoticonMgr.emoticonType == ZCMEmoticonQQType || emoticonMgr.emoticonType == ZCMEmoticonEmojiType) {
        return YES;
    }
    
    return NO;
}

@end
