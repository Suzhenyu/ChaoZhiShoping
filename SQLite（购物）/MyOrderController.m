//
//  MyOrderController.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "MyOrderController.h"
#import "HelperUtil.h"
#import "MyOrderCell.h"
#import "OrderDetailController.h"
#import "OrderInfo.h"
#import "DBOrder.h"
#import "UserInfo.h"
#import "Toast.h"
#import "MyFilePlist.h"
#import "DBUser.h"

@interface MyOrderController ()
{
    int _orderType;
    NSArray *_orderArray;
}
@end

extern UserInfo *LoginUserInfo;
@implementation MyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的订单";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    [_orderTable setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    
    [_btnTab1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnTab1 setBackgroundColor:[HelperUtil colorWithHexString:@"#1B1B1B"]];
    [_btnTab2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnTab2 setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
    [_btnTab3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_btnTab3 setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
    
    _orderType=0;
    _orderArray=[[DBOrder shareDBOrder] selectListByUserId:LoginUserInfo.user_id AndStatus:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFinishIsComment) name:@"refreshFinishIsComment" object:nil];
    
}

-(void)refreshFinishIsComment{
    _orderArray=[[DBOrder shareDBOrder] selectListByUserId:LoginUserInfo.user_id AndStatus:2];
    [_orderTable reloadData];
}

-(IBAction)tabClickAction:(UIButton*)sender{
    int index=(int)[sender tag];
    
    if (index==0) {
        [_btnTab1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnTab1 setBackgroundColor:[HelperUtil colorWithHexString:@"#1B1B1B"]];
        [_btnTab2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnTab2 setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        [_btnTab3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnTab3 setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        
        _orderType=0;
        _orderArray=[[DBOrder shareDBOrder] selectListByUserId:LoginUserInfo.user_id AndStatus:0];
        [_orderTable reloadData];
    }
    if (index==1) {
        [_btnTab1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnTab1 setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        [_btnTab2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnTab2 setBackgroundColor:[HelperUtil colorWithHexString:@"#1B1B1B"]];
        [_btnTab3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnTab3 setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        
        _orderType=1;
        _orderArray=[[DBOrder shareDBOrder] selectListByUserId:LoginUserInfo.user_id AndStatus:1];
        [_orderTable reloadData];
    }
    if (index==2) {
        [_btnTab1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnTab1 setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        [_btnTab2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnTab2 setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        [_btnTab3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnTab3 setBackgroundColor:[HelperUtil colorWithHexString:@"#1B1B1B"]];
        
        _orderType=2;
        _orderArray=[[DBOrder shareDBOrder] selectListByUserId:LoginUserInfo.user_id AndStatus:2];
        [_orderTable reloadData];
    }
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _orderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyOrderCell";
    
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    OrderInfo *orderInfo=[_orderArray objectAtIndex:indexPath.row];
    NSLog(@"%i",orderInfo.address_id);
    cell.lbOrderNo.text=[NSString stringWithFormat:@"订单号：%@",orderInfo.order_id];
    cell.lbOrderPrice.text=[NSString stringWithFormat:@"￥%.2f",orderInfo.order_price];
    cell.lbOrderTime.text=[NSString stringWithFormat:@"下单时间：%@",orderInfo.order_time];
    
    if (_orderType==0) {
        cell.btnDetail.hidden=NO;
        [cell.btnDetail setTitle:@"付款" forState:UIControlStateNormal];
        cell.btnDetail.tag=indexPath.row;
        [cell.btnDetail addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.lbOrderStatus.text=@"待付款";
    }
    if (_orderType==1) {
        cell.btnDetail.hidden=NO;
        [cell.btnDetail setTitle:@"确认收货" forState:UIControlStateNormal];
        cell.btnDetail.tag=indexPath.row;
        [cell.btnDetail addTarget:self action:@selector(receiveClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.lbOrderStatus.text=@"待收货";
    }
    if (_orderType==2) {
        cell.btnDetail.hidden=YES;
        cell.lbOrderStatus.text=@"已完成";
        
        NSArray *goodsIdArray=[orderInfo.order_goods componentsSeparatedByString:@"||"];
        BOOL isComment=YES;
        for (int i=0; i<goodsIdArray.count; i++) {
            NSString *idStr=[goodsIdArray objectAtIndex:i];
            NSArray *idArray=[idStr componentsSeparatedByString:@","];
            if ([[idArray objectAtIndex:2] intValue]==0) {
                isComment=NO;
            }
        }
        
        cell.imgIsComment.hidden=isComment;
    }
    
    return cell;
}

-(void)payClick:(UIButton *)sender{
    int index=(int)sender.tag;
    OrderInfo *orderInfo=[_orderArray objectAtIndex:index];
    if (LoginUserInfo.user_balance<orderInfo.order_price) {
        [[Toast shareToast] makeText:@"余额不足" aDuration:1];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入密码"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认",nil];
        alertView.alertViewStyle=UIAlertViewStyleSecureTextInput;
        alertView.delegate=self;
        alertView.tag=index;
        //通过索引0获取第一个文本框
        UITextField *tf=[alertView textFieldAtIndex:0];
        tf.font = [UIFont boldSystemFontOfSize:14];
        [tf setPlaceholder:@"请输入密码"];
        [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
        [tf setReturnKeyType:UIReturnKeyDone];
        [alertView show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    OrderInfo *orderInfo=[_orderArray objectAtIndex:indexPath.row];
    
    OrderDetailController *controller=[[OrderDetailController alloc] init];
    controller.fromOrderInfo=orderInfo;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSString *pwdStr=[tf text];
        if (![pwdStr isEqualToString:LoginUserInfo.user_pwd]) {
            [[Toast shareToast] makeText:@"密码错误" aDuration:1];
        }else{
            OrderInfo *orderInfo=[_orderArray objectAtIndex:alertView.tag];
            LoginUserInfo.user_balance-=orderInfo.order_price;
            //归档
            [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
            //更新tb_user表
            [[DBUser shareDBUser] updateUserData:LoginUserInfo];
            
            //更新订单状态
            [[DBOrder shareDBOrder] updateStatus:1 userId:LoginUserInfo.user_id orderId:orderInfo.order_id];
            
            //更新数据
            _orderArray=[[DBOrder shareDBOrder] selectListByUserId:LoginUserInfo.user_id AndStatus:0];
            [_orderTable reloadData];
            [[Toast shareToast] makeText:@"支付成功" aDuration:2];
        }
    }
}

-(void)receiveClick:(UIButton *)sender{
    int index=(int)sender.tag;
    OrderInfo *orderInfo=[_orderArray objectAtIndex:index];
    
    //更新订单状态
    [[DBOrder shareDBOrder] updateStatus:2 userId:LoginUserInfo.user_id orderId:orderInfo.order_id];
    
    //更新数据
    _orderArray=[[DBOrder shareDBOrder] selectListByUserId:LoginUserInfo.user_id AndStatus:1];
    [_orderTable reloadData];
    [[Toast shareToast] makeText:@"确认收货成功" aDuration:2];
    
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
