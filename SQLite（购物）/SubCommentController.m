//
//  FeedBackViewController.m
//  蓝桥播报
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "SubCommentController.h"
#import "Toast.h"
#import "UserInfo.h"
#import "CommentInfo.h"
#import "DBComment.h"
#import "OrderInfo.h"
#import "DBOrder.h"

extern UserInfo *LoginUserInfo;
@interface SubCommentController ()

@end

@implementation SubCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"评论";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn setFrame:CGRectMake(7, 7, 43, 27)];
    [publishBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn setTitle:@"提交" forState:UIControlStateNormal];
    [publishBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    publishBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_textView becomeFirstResponder];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)publishClick{
    NSString *contentStr=_textView.text;
    if ([contentStr isEqualToString:@""]) {
        [[Toast shareToast] makeText:@"请输入内容" aDuration:1];
    }else{
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *nowDateStr=[formatter stringFromDate:[NSDate date]];
        
        //添加到tb_comment表
        CommentInfo *commentInfo=[[CommentInfo alloc] init];
        commentInfo.comment_time=nowDateStr;
        commentInfo.comment_content=contentStr;
        commentInfo.goods_id=_fromGoodsId;
        [[DBComment shareDBComment] insertCommendData:commentInfo userId:LoginUserInfo.user_id];
        //修改tb_order表中order_goods的值
        //12,2,0||13,1,0
        NSArray *goodsIdArray=[_fromOrderInfo.order_goods componentsSeparatedByString:@"||"];
        NSMutableString *mutStr=[NSMutableString string];
        for (int i=0; i<goodsIdArray.count; i++) {
            NSString *idStr=[goodsIdArray objectAtIndex:i];
            //从数组中找出当前评论的goods_id
            NSMutableArray *idArray=[NSMutableArray arrayWithArray:[idStr componentsSeparatedByString:@","]];
            if (_fromGoodsId==[[idArray objectAtIndex:0] integerValue]) {
                [idArray replaceObjectAtIndex:2 withObject:@1];//改为已评论状态
            }
            //重新拼接
            [mutStr appendString:[idArray componentsJoinedByString:@","]];
            if (i!=goodsIdArray.count-1) {
                [mutStr appendString:@"||"];
            }
        }
        NSLog(@"%@",mutStr);
        _fromOrderInfo.order_goods=mutStr;
        [[DBOrder shareDBOrder] updateGoodsCommentStatus:mutStr orderId:_fromOrderInfo.order_id];
        
        //更新订单详情
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshIsComment" object:nil];
        //更新订单列表
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFinishIsComment" object:nil];
        [[Toast shareToast] makeText:@"评论成功" aDuration:1];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([_textView.text length]<=100) {
        _lbCount.textColor=[UIColor darkGrayColor];
        _lbCount.text=[NSString stringWithFormat:@"%d/100",[_textView.text length]];
    }else {
        _textView.text=[_textView.text substringToIndex:100];
        
        _lbCount.textColor=[UIColor redColor];
        _lbCount.text=[NSString stringWithFormat:@"内容超出！%d/100",[_textView.text length]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
