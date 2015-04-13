//
//  ZCMFace.m
//  zcm
//
//  Created by cnstar on 28/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMFace.h"
#import "ZCMEmoticon.h"

@implementation ZCMFace

/*
+(NSArray *)faceNames {
    static NSArray *_faceNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *faces = @[@"/微笑",@"/撇嘴",@"/色",@"/发呆",@"/得意",@"/流泪",@"/害羞",@"/闭嘴",@"/睡",@"/大哭",@"/尴尬",@"/发怒",@"/调皮",@"/呲牙",@"/惊讶",@"/难过",@"/酷",@"/冷汗",@"/抓狂",@"/吐",@"/偷笑",@"/可爱",@"/白眼",@"/傲慢",@"/饥饿",@"/困",@"/惊恐",@"/流汗",@"/憨笑",@"/大兵",@"/奋斗",@"/咒骂",@"/疑问",@"/嘘",@"/晕",@"/折磨",@"/衰",@"/骷髅",@"/敲打",@"/再见",@"/擦汗",@"/抠鼻",@"/鼓掌",@"/糗大了",@"/坏笑",@"/左哼哼",@"/右哼哼",@"/哈欠",@"/鄙视",@"/委屈",@"/快哭了",@"/阴险",@"/亲亲",@"/吓",@"/可怜",@"/菜刀",@"/西瓜",@"/啤酒",@"/篮球",@"/乒乓",@"/咖啡",@"/饭",@"/猪头",@"/玫瑰",@"/凋谢",@"/示爱",@"/爱心",@"/心碎",@"/蛋糕",@"/闪电",@"/炸弹",@"/刀",@"/足球",@"/瓢虫",@"/便便",@"/月亮",@"/太阳",@"/礼物",@"/拥抱",@"/强",@"/弱",@"/握手",@"/胜利",@"/抱拳",@"/勾引",@"/拳头",@"/差劲",@"/爱你",@"/NO",@"/OK",@"/爱情",@"/飞吻",@"/跳跳",@"/发抖",@"/怄火",@"/转圈",@"/磕头",@"/回头",@"/跳绳",@"/挥手",@"/激动",@"/街舞",@"/献吻",@"/左太极",@"/右太极",@"/双喜",@"/鞭炮",@"/灯笼",@"/发财",@"/K歌",@"/购物",@"/邮件",@"/帅",@"/喝彩",@"/祈祷",@"/爆筋",@"/棒棒糖",@"/喝奶",@"/下面",@"/香蕉",@"/飞机",@"/开车",@"/左车头",@"/车厢",@"/右车头",@"/多云",@"/下雨",@"/钞票",@"/熊猫",@"/灯泡",@"/风车",@"/闹钟",@"/打伞",@"/彩球",@"/钻戒",@"/沙发",@"/纸巾",@"/药",@"/手枪",@"/青蛙"];
        
        _faceNames = [[NSArray alloc] initWithArray:faces];
    });
    
    return _faceNames;
}

+(NSArray *)facePaths {
    static NSArray *_facePaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *faces = @[@"024",@"041",@"020",@"044",@"022",@"010",@"021",@"105",@"036",@"011",@"026",@"025",@"002",@"001",@"034",@"033",@"013",@"003",@"083",@"023",@"004",@"019",@"031",@"032",@"080",@"081",@"027",@"028",@"038",@"051",@"043",@"082",@"035",@"012",@"050",@"014",@"040",@"077",@"006",@"005",@"007",@"084",@"085",@"086",@"047",@"087",@"045",@"088",@"049",@"015",@"089",@"042",@"037",@"090",@"052",@"018",@"061",@"062",@"091",@"092",@"067",@"059",@"008",@"009",@"058",@"030",@"029",@"073",@"060",@"079",@"017",@"069",@"076",@"063",@"016",@"068",@"074",@"075",@"046",@"053",@"054",@"055",@"056",@"057",@"064",@"072",@"071",@"066",@"083",@"065",@"039",@"048",@"094",@"070",@"095",@"096",@"097",@"098",@"099",@"078",@"100",@"101",@"102",@"103",@"104",@"107",@"108",@"109",@"110",@"111",@"112",@"113",@"114",@"115",@"116",@"117",@"118",@"119",@"120",@"121",@"122",@"123",@"124",@"125",@"126",@"127",@"128",@"129",@"130",@"131",@"132",@"133",@"134",@"135",@"136",@"137",@"138",@"139",@"140",@"141"];
        
        _facePaths = [[NSArray alloc] initWithArray:faces];
    });
    
    return _facePaths;
}

+(NSString *)faceName:(NSInteger)index {
    if (index < 0 || index >= [ZCMFace faceNames].count) {
        return nil;
    }
    
    return [[ZCMFace faceNames] objectAtIndex:index];
}

+(NSString *)facePath:(NSInteger)index {
    if (index < 0 || index >= [ZCMFace facePaths].count) {
        return nil;
    }
    
    return [[ZCMFace facePaths] objectAtIndex:index];
}
*/

+(NSArray *)faces {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Face" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:plistPath];
 
    NSMutableArray *emts = [NSMutableArray array];
    for (NSDictionary *dict in data) {
        ZCMEmoticon *emt = [[ZCMEmoticon alloc] init];
        emt.emoticonType = ZCMEmoticonQQType;
        emt.name = [dict.allKeys firstObject];
        emt.emoticonPath = [NSString stringWithFormat:@"%@", dict.allValues.firstObject];
        emt.isBundleRes = YES;
        [emts addObject:emt];
    }
    
    return emts;
}



@end
