//
//  AppDelegate.m
//  SQLite（购物）
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "CartController.h"
#import "UserViewController.h"
#import "HelperUtil.h"
#import "LoginController.h"
#import "MyFilePlist.h"
#import "UserInfo.h"
#import "MLNavigationController.h"

@interface AppDelegate ()

@end

#pragma mark--!!!
//这里不知道什么意思
UserInfo *LoginUserInfo;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@",[MyFilePlist documentFilePathStr:@"isFirstLaunch.archive"]);
    /*
     拷贝db至沙盒、创建用户头像文件夹
     */
    NSString *sqlitePthStr=[MyFilePlist documentFilePathStr:@"CZG.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:sqlitePthStr]) {//如果为nil，代表是第一次启动
        NSLog(@"文件不存在，拷贝db至沙盒");
        NSString *dbPathStr=[[NSBundle mainBundle] pathForResource:@"CZG" ofType:@"sqlite"];
        //将资源文件中的db拷贝至沙盒中的Document（以后读取沙盒中的db）
        [[NSFileManager defaultManager] copyItemAtPath:dbPathStr toPath:[MyFilePlist documentFilePathStr:@"CZG.sqlite"] error:nil];
        //创建用户头像文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:[MyFilePlist documentFilePathStr:@"UserHead"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    /*
     获取登录用户
     判断登录状态（LoginUserInfo如果为nil，代表未登录状态）
     */
    LoginUserInfo=[NSKeyedUnarchiver unarchiveObjectWithFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
    
#pragma mark--!!!
    //顶部状态条白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    HomeViewController *homeController=[[HomeViewController alloc] init];
    homeController.tabBarItem.title=@"首页";
    homeController.tabBarItem.image=[UIImage imageNamed:@"icon_home"];
    CartController *cartController=[[CartController alloc] init];
    cartController.tabBarItem.title=@"购物车";
    cartController.tabBarItem.image=[UIImage imageNamed:@"icon_cart"];
    UserViewController *userController=[[UserViewController alloc] init];
    userController.tabBarItem.title=@"用户中心";
    userController.tabBarItem.image=[UIImage imageNamed:@"icon_user"];
    
    _mainTabContrl=[[UITabBarController alloc] init];
    _mainTabContrl.delegate=self;
    _mainTabContrl.viewControllers=@[homeController,cartController,userController];
    [_mainTabContrl.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg.png"]];
    //设置选中颜色
    _mainTabContrl.tabBar.tintColor=[HelperUtil colorWithHexString:@"#e50012"];
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:_mainTabContrl];
#pragma mark--!!!
    //设置导航条背景图片
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <7.0) {
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_top_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"newsTopBg_new.png"] forBarMetrics:UIBarMetricsDefault];
    }
    //设置导航条字体颜色
    nav.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    _window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController=nav;
    [_window makeKeyAndVisible];
    
    return YES;
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    int index=(int)tabBarController.selectedIndex;
    if (index==2) {
        if (LoginUserInfo==nil) {//未登录状态，跳转至登录界面
            LoginController *controller=[[LoginController alloc] init];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:controller];
            [_mainTabContrl presentViewController:nav animated:YES completion:nil];
            //将选中的下标赋给之前保留的下标
            _mainTabContrl.selectedIndex=_tabSelectedIndex;
        }
    }else{
        //代表当前选中的下标，保留用户选中的下标
        _tabSelectedIndex=(int)tabBarController.selectedIndex;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
