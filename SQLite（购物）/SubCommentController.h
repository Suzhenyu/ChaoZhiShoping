//
//  FeedBackViewController.h
//  蓝桥播报
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderInfo;
@interface SubCommentController : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *_textView;
    IBOutlet UILabel *_lbCount;
}
@property (nonatomic,strong) OrderInfo *fromOrderInfo;
@property (nonatomic,assign) int fromGoodsId;
@end
