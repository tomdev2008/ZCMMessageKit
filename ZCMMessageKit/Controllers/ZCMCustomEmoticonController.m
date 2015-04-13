//
//  ZCMCustomEmoticonController.m
//  zcm
//
//  Created by cnstar on 29/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMCustomEmoticonController.h"
#import "ZCMMsgDisMacros.h"
#import "ZCMEmoticonCollectionViewCell.h"
#import "ZCMEmoticonHandler.h"
#import "ZCMPhotoHelper.h"
#import "ZCMEmoticonMgr.h"

typedef void(^CompletionBlock)(BOOL finished);

@interface ZCMCustomEmoticonController ()
@property (nonatomic, strong) ZCMPhotoHelper *photoHelper;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *emoticons;
@end

@implementation ZCMCustomEmoticonController

-(void)dealloc {
    _photoHelper = nil;
    _emoticons = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义表情";
    
    _flowLayout.itemSize = CGSizeMake(ZCMMSG_ScreenWidth/4-1, ZCMMSG_ScreenWidth/4-1);
    ZCMEmoticonMgr *emtMgr = [[ZCMEmoticonHandler sharedEmoticonHandler] emoticonMgrWithEmoticonType:ZCMEmoticonCustomType error:nil];
    if (emtMgr.emoticons.count > 0) {
        self.emoticons = [NSMutableArray arrayWithArray:emtMgr.emoticons];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender {
    
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)done:(id)sender {
    ZCMEmoticonMgr *emtMgr = [[ZCMEmoticonHandler sharedEmoticonHandler] emoticonMgrWithEmoticonType:ZCMEmoticonCustomType error:nil];
    emtMgr.emoticons = _emoticons;
    [[ZCMEmoticonHandler sharedEmoticonHandler] updateEmoticonMgrsWithEmoticonMgr:emtMgr];
    
    [self close:nil];
}

+(void)showCustomEmoticonWithRootViewController:(UIViewController *)parentViewController {
    ZCMCustomEmoticonController *vc = ZCMCLASSFROMESTORYBOARD(@"ZCMMsg", NSStringFromClass([ZCMCustomEmoticonController class]));
    UINavigationController *nav = ZCMCLASSFROMESTORYBOARD(@"ZCMMsg", @"ZCMEmoticonNavigationController");
    [nav setViewControllers:@[vc]];
    [parentViewController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _emoticons.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCMEmoticonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZCMEmoticonCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = (id<ZCMEmoticonCollectionViewCellDelegate>)self;
    if (indexPath.row < _emoticons.count) {
        cell.emoticon = [_emoticons objectAtIndex:indexPath.row];
    } else {
        cell.emoticon = nil;
    }
    
    return cell;
}

#pragma mark - cell delegate
/**
 *  表情被点击 的delegate
 */
-(void)emoticonCollectionViewCell:(ZCMEmoticonCollectionViewCell *)cell didSelectedEmoticon:(ZCMEmoticon *)emoticon {
    if (emoticon.emoticonType == ZCMEmoticonAddCustomType) {
        if (!_photoHelper) {
            ZCMPhotoHelper *helper = [[ZCMPhotoHelper alloc] init];
            self.photoHelper = helper;
        }
        [_photoHelper showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self completion:^(UIImage *seletedImage, NSDictionary *userInfo) {
            if (seletedImage) {
                //TODO: upload to server
                ZCMEmoticon *emt = [[ZCMEmoticon alloc] init];
                emt.emoticonType = ZCMEmoticonCustomType;
                emt.emoticonConverPicture = seletedImage;
                if (!_emoticons) {
                    self.emoticons = [NSMutableArray array];
                }
                [_emoticons addObject:emt];
                
                [self.collectionView reloadData];
            }
        }];
    }
}

@end
