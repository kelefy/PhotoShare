//
//  SimpleEditMultipleController.m
//  PhotoShare
//
//  Created by kongfanyi on 16/7/17.
//  Copyright © 2016年 dd. All rights reserved.
//

#import "SimpleEditMultipleController.h"
#import "_CLImageEditorViewController.h"
#import "CLTextTool.h"
#import "UIColor+Viking.h"
#import "UIColor+Puertorico.h"
#import "UIColor+Silversand.h"

@interface SimpleEditMultipleController()

@end

@implementation SimpleEditMultipleController
{
    UIView *_bottomView;
}



#pragma LoadView

-(void)loadView;
{
    // !!!!!!!!!!!
    // 初始化父类的方法，这里很重要
    [super loadView];
    //可在此直接对导航栏进行设置，例如导航栏两侧按钮的显示或隐藏
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
//    
//    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
//    [notiCenter addObserver:self selector:@selector(stickComplete:) name:@"stickComplete123" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
}


/**
 *  配置默认样式视图
 *
 *  @param view 默认样式视图 (如需创建自定义视图，请覆盖该方法，并配置自己的视图类)
 */
- (void)configDefaultStyleView:(TuSDKPFEditMultipleView *)view;
{
    if (!view) return;
    // !!!!!!!!!!!
    // 初始化视图,这里很重要
    [view lsqInitView];
    view.backgroundColor = [UIColor silverSand];
    view.autoAdjustButton.hidden = YES;
    // 是否禁用操作步骤记录
//    view.stepView.hidden = self.disableStepsSave;
    
//    [view.imageView setSizeHeight:view.height];
//    view.imageView.image = view.imageView.image;
    view.stepView.hidden = YES;
    // 步骤后退按钮
    [view.stepView.prevButton addTouchUpInsideTarget:self action:@selector(onStepPreviewAction)];
    // 步骤前进按钮
    [view.stepView.nextButton addTouchUpInsideTarget:self action:@selector(onStepNextAction)];
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, view.optionBar.frame.size.height)];
    _bottomView.backgroundColor = [UIColor viking];
    [view.optionBar addSubview:_bottomView];
    //    [self.optionBar removeFromSuperview];
    
    UIButton *btnFilter = [view.optionBar buildButtonWithActionType:lsqTuSDKCPEditActionFilter moduleCount:33];
    btnFilter.frame = CGRectMake(0, 10, 40, 40);
    [btnFilter addTarget:self action:@selector(onEditWithAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnFilter setStateNormalTitle:nil];
    [btnFilter setStateNormalImage:nil];
    [btnFilter setBackgroundImage:[UIImage imageNamed:@"Filter"] forState:UIControlStateNormal];
//    [_bottomView addSubview:btnFilter];
    
    //美颜
    UIButton *btnEditSkin = [view.optionBar buildButtonWithActionType:lsqTuSDKCPEditActionSkin moduleCount:33];
    btnEditSkin.frame = CGRectMake(0, 0, 40, 40);
    [btnEditSkin addTarget:self action:@selector(onEditWithAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:btnEditSkin];
    
    //贴纸
    UIButton *btnSticker = [view.optionBar buildButtonWithActionType:lsqTuSDKCPEditActionSticker moduleCount:33];
    btnSticker.frame = CGRectMake(0, 0, 40, 40);
    [btnSticker addTarget:self action:@selector(onStickAction:) forControlEvents:UIControlEventTouchUpInside];
//    [btnSticker addTarget:self action:@selector(onEditWithAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:btnSticker];
    [btnSticker setImage:nil forState:UIControlStateNormal];
    [btnSticker setStateNormalTitle:nil];
    [btnSticker setBackgroundImage:[UIImage imageNamed:@"btn_img_addStick"] forState:UIControlStateNormal];
    
    UIButton *btnDrawing = [view.optionBar buildButtonWithActionType:lsqTuSDKCPEditActionSmudge moduleCount:33];
    btnDrawing.frame = CGRectMake(0, 0, 40, 40);
    [btnDrawing addTarget:self action:@selector(onDrawingAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnDrawing setStateNormalTitle:nil];
    [btnDrawing setImage:nil forState:UIControlStateNormal];
    [btnDrawing setBackgroundImage:[UIImage imageNamed:@"addText"] forState:UIControlStateNormal];
//    [_bottomView addSubview:btnDrawing];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"btn_shareAction"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 60, 60);
    [shareBtn addTarget:self action:@selector(onShareAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    
    [self addButtonsToBottomView:@[btnFilter,btnEditSkin,shareBtn,btnSticker,btnDrawing]];
    
    [view.stepView.prevButton setOriginX:[btnEditSkin getOriginX]];
    [view.stepView.nextButton setOriginX:[btnSticker getOriginX]];
    
    // 修改这里 !!!!!!!!!!!
    // 更改导航左侧按钮点击事件
    [view.cancelButton addTouchUpInsideTarget:self action:@selector(leftText)];
    // 更改导航右侧按钮点击事件
    [view.doneButton addTouchUpInsideTarget:self action:@selector(rightText)];

    [view.autoAdjustButton addTarget:self action:@selector(onAutoAdjustAction) forControlEvents:UIControlEventTouchUpInside];
//    [view.optionBar bindModules:@[@2,@4,@3] target:self action:@selector(onEditWithAction:)];
    
    [view needUpdateLayout];
    [self.view addSubview:view];
    
//    [self onEditWithAction:btnSticker];
    [self onEditWithAction:[view.optionBar buildButtonWithActionType:lsqTuSDKCPEditActionCuter moduleCount:33]];
    
}

-(void)addButtonsToBottomView:(NSArray *)btnList
{
    NSInteger count = [btnList count];
    NSInteger insetWidth = 20;
    __block NSInteger btnWithTotal = insetWidth*2;
    [btnList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        btnWithTotal += btn.frame.size.width;
    }];
    
    float spaceWidth = (float)(_bottomView.frame.size.width-btnWithTotal)/(count - 1);
    
    for(int i=0;i<btnList.count;i++)
    {
        UIButton *btn = btnList[i];
        if(i==0)
        {
            btn.frame = CGRectMake(insetWidth,(_bottomView.frame.size.height - btn.frame.size.height)/2.f,btn.frame.size.width,btn.frame.size.height);
        }
        else
        {
            UIButton *last = btnList[i-1];
            btn.frame = CGRectMake(last.frame.origin.x+last.frame.size.width+spaceWidth,(_bottomView.frame.size.height - btn.frame.size.height)/2,btn.frame.size.width,btn.frame.size.height);
        }
        [_bottomView addSubview:btn];
    }
}

-(void)leftText
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self popViewControllerAnimated:YES];
}

-(void)rightText
{
    [super onImageCompleteAtion];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onDrawingAction:(id)sender
{
    _CLImageEditorViewController *editor = [[_CLImageEditorViewController alloc] initWithImage:self.defaultStyleView.imageView.image];
    editor.imageFrame = self.defaultStyleView.imageView.frame;
    editor.OnDrawCompleteBlock = ^(UIImage *drawImage){
        
        [self setNavigationBarHidden:YES];
        TuSDKResult *result = [TuSDKResult result];
        result.image = drawImage;
        [super saveToTempWithResult:result];
        NSString *path = result.imagePath;
        [super appendHistory:path];
        self.displayImage = drawImage;
    };
    editor.setupToosIdx = 9;
    [self presentViewController:editor animated:NO completion:nil];
}

-(void)onStickAction:(id)sender
{
    _CLImageEditorViewController *editor = [[_CLImageEditorViewController alloc] initWithImage:self.defaultStyleView.imageView.image];
    editor.imageFrame = self.defaultStyleView.imageView.frame;
    editor.setupToosIdx = 8;
    editor.simpleEditMultipleController = self;
    editor.OnDrawCompleteBlock = ^(UIImage *drawImage){
        [self setNavigationBarHidden:YES];
        TuSDKResult *result = [TuSDKResult result];
        result.image = drawImage;
        [super saveToTempWithResult:result];
        NSString *path = result.imagePath;
        [super appendHistory:path];
        self.displayImage = drawImage;
    };

    [self presentViewController:editor animated:NO completion:nil];

}

-(void)onShareAction:(UIButton *)sender
{
    UIActivityViewController *act = [[UIActivityViewController alloc]initWithActivityItems:@[self.defaultStyleView.imageView.image] applicationActivities:nil];
//    act.popoverPresentationController.sourceView = self.view;
//    act.popoverPresentationController.barButtonItem = self;
//    act.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter];
//    [self presentViewController:act animated:YES completion:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
    }
    //if iPad
    else {
        // Change Rect to position Popover
//        UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc]init];
        act.popoverPresentationController.sourceView = self.view;
//        [popup presentPopoverFromBarButtonItem:shareBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    [self presentViewController:act animated:YES completion:nil];
}

-(void)onEditWithAction:(UIButton *)btn
{
    [super onEditWithAction:btn];
}

//-(void)stickComplete:(NSNotification *)noti
//{
//    UIImage *image = noti.object;
////    TuSDKResult *result = [TuSDKResult result];
////    result.image = image;
////    [super saveToTempWithResult:result];
////    NSString *path = result.imagePath;
////    [super appendHistory:path];
//    [self setDisplayImage:image];
//    [self setInputImage:image];
//}

@end
