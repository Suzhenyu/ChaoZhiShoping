//
//  LoadingRequestView.m
//  蓝桥播报
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "LoadingRequestView.h"
#import "AppDelegate.h"

static LoadingRequestView *singleInstance=nil;

@implementation LoadingRequestView

+(LoadingRequestView *)shareLoadingView{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[LoadingRequestView alloc] init];
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
    
    _centerLoadingView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 201, 60)];
    _centerLoadingView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 60)];
    [imgView setImage:[UIImage imageNamed:@"loadingRequestView_bg.png"]];
    UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(10,imgView.frame.size.height/2-30, 100, 60)];
    labelInfo.numberOfLines = 2;
    labelInfo.backgroundColor = [UIColor clearColor];
    labelInfo.textAlignment = NSTextAlignmentLeft;
    labelInfo.textColor = [UIColor whiteColor];
    labelInfo.font = [UIFont systemFontOfSize:16];
    labelInfo.text=@"正在请求...";
    [imgView addSubview:labelInfo];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = CGPointMake(110, imgView.frame.size.height/2);
    _activityView.hidesWhenStopped = YES;
    [_activityView startAnimating];
    [imgView addSubview:_activityView];
    [_centerLoadingView addSubview:imgView];
    UIButton *btnClose=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setFrame:CGRectMake(141, 0, 60, 60)];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"loadingRequestView_cancel.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_centerLoadingView addSubview:btnClose];
    [delegate.window addSubview:_centerLoadingView];
    
}
-(void)hide{
    [_activityView stopAnimating];
    [_centerLoadingView removeFromSuperview];
    [_backGroundView removeFromSuperview];
}

-(void)dealloc{
    NSLog(@"LoadingRequestView销毁");
}

@end
