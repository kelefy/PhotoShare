//
//  CLImageEditorTheme.m
//
//  Created by sho yakushiji on 2013/12/05.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageEditorTheme.h"

@implementation CLImageEditorTheme

#pragma mark - singleton pattern

static CLImageEditorTheme *_sharedInstance = nil;

+ (CLImageEditorTheme*)theme
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CLImageEditorTheme alloc] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.bundleName                     = @"CLImageEditor";
        self.backgroundColor                = [UIColor colorWithRed:0.1686274510 green:0.1647058824 blue:0.1764705882 alpha:1.0000000000];//[UIColor whiteColor];
        self.toolbarColor                   = [UIColor colorWithRed:0.2509803922 green:0.2431372549 blue:0.2627450980 alpha:1.0000000000];//[UIColor colorWithWhite:1 alpha:0.8];
		self.toolIconColor                  = @"white";
        self.toolbarTextColor               = [UIColor whiteColor];
        self.toolbarSelectedButtonColor     = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        self.toolbarTextFont                = [UIFont systemFontOfSize:7];
        self.statusBarStyle                 = UIStatusBarStyleDefault;
    }
    return self;
}

@end
