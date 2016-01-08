//
//  InfoDetailViewController.h
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailViewController : UIViewController
{
    IBOutlet UIWebView *_webView;
}
@property (nonatomic,assign) int fromGoodsId;
@end
