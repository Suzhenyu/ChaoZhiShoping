//
//  LoadingView.h
//  蓝桥播报
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadingView : NSObject
{
    UIView *_backGroundView;
    UIView *_centerLoadingView;
    UIActivityIndicatorView *_activityView;
}

+(LoadingView *)shareLoadingView;
-(void)show;
-(void)hide;

@end
