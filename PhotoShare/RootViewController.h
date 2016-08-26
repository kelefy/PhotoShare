//
//  RootViewController.h
//  PhotoShare
//
//  Created by kongfanyi on 16/7/17.
//  Copyright © 2016年 dd. All rights reserved.
//

#import <TuSDK/TuSDK.h>
#import "TuSDKGeeV1/TuSDKGeeV1.h"

@interface RootViewController : TuSDKICViewController
// 照片美化组件
@property (nonatomic,strong,readonly) TuSDKCPPhotoEditMultipleComponent *photoEditMultipleComponent;

@end
