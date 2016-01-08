//
//  LoadingView.m
//  蓝桥播报
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "LoadingView.h"
#import "AppDelegate.h"

static LoadingView *singleInstance=nil;

@implementation LoadingView

+(LoadingView *)shareLoadingView{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    
    return singleInstance;
}

-(void)show{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _backGroundView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_backGroundView setBackgroundColor:[UIColor blackColor]];
    _backGroundView.alpha=0.6;
    [delegate.window addSubview:_backGroundView];
    
    _centerLoadingView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _centerLoadingView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [imgView setImage:[UIImage imageNamed:@"loading_bg.png"]];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height/2-20);
    _activityView.hidesWhenStopped = YES;
    [_activityView startAnimating];
    [imgView addSubview:_activityView];
    UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 140, 60)];
    labelInfo.center=CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height/2+20);
    labelInfo.numberOfLines = 2;
    labelInfo.backgroundColor = [UIColor clearColor];
    labelInfo.textAlignment = NSTextAlignmentCenter;
    labelInfo.textColor = [UIColor whiteColor];
    labelInfo.font = [UIFont systemFontOfSize:16];
    labelInfo.text=@"加载中...";
    [imgView addSubview:labelInfo];
    
    [_centerLoadingView addSubview:imgView];
    [delegate.window addSubview:_centerLoadingView];
    
}

-(void)hide{
    [_activityView stopAnimating];
    [_centerLoadingView removeFromSuperview];
    [_backGroundView removeFromSuperview];
}

@end
