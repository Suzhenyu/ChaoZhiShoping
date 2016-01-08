//
//  AppDelegate.h
//  SQLite（购物）
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    UITabBarController *_mainTabContrl;
    int _tabSelectedIndex;
}

@property (strong, nonatomic) UIWindow *window;

@end

