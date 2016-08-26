//
//  SimpleEditStickerController.m
//  PhotoShare
//
//  Created by kongfanyi on 16/7/24.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "SimpleEditStickerController.h"
#import "UIColor+Puertorico.h"
#import "UIColor+Viking.h"
#import "UIColor+Silversand.h"
#import "UIColor+Hex.h"
#import "UIView+Extension.h"

@implementation SimpleEditStickerController
{
    CGSize _stickSize;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
}


- (void)configDefaultStyleView:(TuSDKPFEditStickerView *)view
{
    [super configDefaultStyleView:view];
    
    UIButton *left = [UIButton buttonWithFrame:CGRectMake(0, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_cancel_bg"];
    [left addTarget:self action:@selector(backActionHadAnimated) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:left];
    
    UIButton *right = [UIButton buttonWithFrame:CGRectMake(view.width-70, 0, 70, 70) imageName:@"TuSDK.bundle/ui_default/style_default_edit_button_confirm_bg"];
    [right addTarget:self action:@selector(onImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:right];
    
    view.cutRegionView.edgeMaskColor = [UIColor silverSand];
    view.imageView.height+=view.bottomBar.height;
    view.cutRegionView.height+=view.bottomBar.height;
    view.stickerView.height += view.bottomBar.height;
    //    设置bottomView事件
    [view.bottomBar.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [view.bottomBar.completeButton addTarget:self action:@selector(onImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
    view.bottomBar.backgroundColor = [UIColor viking];
    view.stickerBar.backgroundColor = [UIColor puertoRico];
    view.stickerBar.y+=view.bottomBar.height;
    
    view.bottomBar.listButton.hidden = YES;
    view.bottomBar.onlineButton.frame = CGRectMake((view.bottomBar.frame.size.width-view.bottomBar.onlineButton.frame.size.width)/2, view.bottomBar.onlineButton.frame.origin.y, view.bottomBar.onlineButton.frame.size.width, view.bottomBar.onlineButton.frame.size.height);
    [view.bottomBar.onlineButton addTarget:self action:@selector(openOnlineAtion) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化贴纸栏
    TuSDKPFStickerLocalPackage *package = [TuSDKPFStickerLocalPackage package];
    
    //只加载相框与贴纸
    TuSDKPFStickerCategory *stickerCate = [package categorieWithIdt:3];
    stickerCate.name = @"相框";
    
    
    [view.stickerBar loadCatategories:@[stickerCate,[package categorieWithIdt:1]]];
    view.stickerBar.tableView.delegate = self;
    [view.stickerBar selectCateButtonWithIndex:1];
    [view.stickerBar selectCateWithIndex:1];
    //自动加载第一张贴纸
    //    TuSDKPFStickerCategory *ca =  [package categorieWithIdt:3];
    TuSDKPFStickerGroup *group = stickerCate.datas[0];
    TuSDKPFSticker *stick = group.stickers[0];
    _stickSize = CGSizeMake(stick.size.width*2, stick.size.height*2);
    stick.size = _stickSize;
    [self appendSticker:stick];
    
    //    [view.stickerBar.paramsView setOriginX:-150];
    NSArray *arr = [view.stickerBar.paramsView subviews];
    NSInteger width = ((UIButton *)arr[0]).frame.size.width*2+10;
    for(NSInteger i=arr.count-1;i>=0;i--)
    {
        UIButton *btn = arr[i];
        [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateSelected];
        if(i>0)
        {
            if(i==2)
                [btn setOriginX: (view.frame.size.width-width)/2+((UIButton *)arr[0]).frame.size.width+10];
            else
                [btn setOriginX: (view.frame.size.width-width)/2];
            //            btn.frame = ((UIButton *)arr[i-1]).frame;
        }
        else
        {
            btn.hidden = YES;
        }
        
    }

}

//- (void)configDefaultStyleView:(TuSDKPFEditStickerView *)view
//{
//    if (!view) return;
//    // 初始化视图
//    [view initView];
//    view.cutRegionView.edgeMaskColor = [UIColor silverSand];
//    //    设置bottomView事件
//    [view.bottomBar.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
//    [view.bottomBar.completeButton addTarget:self action:@selector(onImageCompleteAtion) forControlEvents:UIControlEventTouchUpInside];
//    view.bottomBar.backgroundColor = [UIColor viking];
//    view.stickerBar.backgroundColor = [UIColor puertoRico];
//    view.bottomBar.listButton.hidden = YES;
//    view.bottomBar.onlineButton.frame = CGRectMake((view.bottomBar.frame.size.width-view.bottomBar.onlineButton.frame.size.width)/2, view.bottomBar.onlineButton.frame.origin.y, view.bottomBar.onlineButton.frame.size.width, view.bottomBar.onlineButton.frame.size.height);
//    [view.bottomBar.onlineButton addTarget:self action:@selector(openOnlineAtion) forControlEvents:UIControlEventTouchUpInside];
//    
//    //初始化贴纸栏
//    TuSDKPFStickerLocalPackage *package = [TuSDKPFStickerLocalPackage package];
//    
//    //只加载相框与贴纸
//    TuSDKPFStickerCategory *stickerCate = [package categorieWithIdt:3];
//    stickerCate.name = @"相框";
//    
//    
//    [view.stickerBar loadCatategories:@[stickerCate,[package categorieWithIdt:1]]];
//    view.stickerBar.tableView.delegate = self;
//    [view.stickerBar selectCateButtonWithIndex:1];
//    [view.stickerBar selectCateWithIndex:1];
//    //自动加载第一张贴纸
////    TuSDKPFStickerCategory *ca =  [package categorieWithIdt:3];
//    TuSDKPFStickerGroup *group = stickerCate.datas[0];
//    TuSDKPFSticker *stick = group.stickers[0];
//    _stickSize = CGSizeMake(stick.size.width*2, stick.size.height*2);
//    stick.size = _stickSize;
//    [self appendSticker:stick];
//    
////    [view.stickerBar.paramsView setOriginX:-150];
//    NSArray *arr = [view.stickerBar.paramsView subviews];
//    NSInteger width = ((UIButton *)arr[0]).frame.size.width*2+10;
//    for(NSInteger i=arr.count-1;i>=0;i--)
//    {
//        UIButton *btn = arr[i];
//        if(i>0)
//        {
//            if(i==2)
//                [btn setOriginX: (view.frame.size.width-width)/2+((UIButton *)arr[0]).frame.size.width+10];
//            else
//                [btn setOriginX: (view.frame.size.width-width)/2];
////            btn.frame = ((UIButton *)arr[i-1]).frame;
//        }
//        else
//        {
//            btn.hidden = YES;
//        }
//        
//    }
//    [view needUpdateLayout];
//    [self.view addSubview:view];
////    view.imageView.backgroundColor = [UIColor silverSand];
//}

-(void)cancelAction
{
    [self popViewControllerAnimated:NO];
}

-(void)openOnlineAtion
{
    [super openOnlineAtion];
}

-(void)stickerTableView:(TuSDKPFStickerTableView *)view selectedData:(TuSDKPFSticker *)data indexPath:(NSIndexPath *)indexPath
{
    if(data.categoryId==3){
        NSArray *arr = [self.stickerView resultsWithRegionRect:self.stickerView.frame];
        for(int i=0;i<arr.count;i++)
        {
            TuSDKPFStickerResult *result = arr[i];
            if(result.sticker.categoryId==3)
            {
                [self showHubErrorWithStatus:@"相框只可选择一个"];
                return;
            }
        }
        data.size = _stickSize;
    }
    [self.stickerView appenSticker:data];
}

@end
