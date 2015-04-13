//
//  ZCMPhotoHelper.m
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import "ZCMPhotoHelper.h"

typedef void(^PhotoHelperCompleteBlock)(UIImage *seletedImage, NSDictionary *userInfo);

@interface ZCMPhotoHelper ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, copy) PhotoHelperCompleteBlock completionBlock;
@property (nonatomic, assign) UIStatusBarStyle barStyle;
@property (nonatomic, assign) BOOL statusBarHide;
@end

@implementation ZCMPhotoHelper

+(ZCMPhotoHelper *)helper {
    ZCMPhotoHelper *_helper = [[ZCMPhotoHelper alloc] init];
    
    return _helper;
}

-(void)dealloc {
    self.completionBlock = nil;
}

-(void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completion:(void(^)(UIImage *seletedImage, NSDictionary *userInfo))callback {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        callback(nil, nil);
        return;
    }
    
    _barStyle = [UIApplication sharedApplication].statusBarStyle;
    _statusBarHide = [UIApplication sharedApplication].statusBarHidden;
    
    self.completionBlock = callback;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.editing = YES;
    picker.delegate = self;
    picker.sourceType = sourceType;
    if ([viewController navigationController]) {
        [picker.navigationBar setTintColor:[viewController navigationController].navigationBar.tintColor];
        [picker.navigationBar setTranslucent:[viewController navigationController].navigationBar.translucent];
        [picker.navigationBar setBarStyle:[viewController navigationController].navigationBar.barStyle];
    } else {
        [picker.navigationBar setTintColor:[UIColor whiteColor]];
        [picker.navigationBar setTranslucent:YES];
        [picker.navigationBar setBarStyle:UIBarStyleBlack];
    }
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [viewController presentViewController:picker animated:YES completion:^{
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            [picker setNavigationBarHidden:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    }];
}

-(void)dismissPickerController:(UIImagePickerController *)picker {
    __weak typeof(&*self) weakSelf = self;
    [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHide];
    [picker dismissViewControllerAnimated:YES completion:^{
        __strong typeof(&*weakSelf) strongSelf = weakSelf;
        strongSelf.completionBlock = nil;
    }];
}

#pragma mark - image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.completionBlock) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        self.completionBlock([img isKindOfClass:[UIImage class]] ? img : nil, info);
    }
    [self dismissPickerController:picker];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPickerController:picker];
}

#pragma mark - navigation delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:_barStyle animated:NO];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:_barStyle animated:NO];
}

@end
