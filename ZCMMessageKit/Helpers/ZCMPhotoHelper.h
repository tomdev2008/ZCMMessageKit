//
//  ZCMPhotoHelper.h
//  zcm
//
//  Created by cnstar on 30/3/2015.
//  Copyright (c) 2015年 cnstar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZCMPhotoHelper : NSObject

+(ZCMPhotoHelper *)helper;

-(void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completion:(void(^)(UIImage *seletedImage, NSDictionary *userInfo))callback;

@end
