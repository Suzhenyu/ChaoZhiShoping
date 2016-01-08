//
//  FeedBack.m
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "OrderDetailController.h"
#import "OrderDetailGoodsCell.h"
#import "OrderInfo.h"
#import "AddressInfo.h"
#import "DBAddress.h"
#import "DBGoods.h"
#import "GoodsInfo.h"
#import "UserInfo.h"
#import "Toast.h"
#import "MyFilePlist.h"
#import "DBUser.h"
#import "DBOrder.h"
#import "SubCommentController.h"

extern UserInfo *LoginUserInfo;
@interface OrderDetailController ()
{
    NSMutableArray *_goodsArray;
}
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单详情";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    lbOrderNo.text=_fromOrderInfo.order_id;
    _lbTotalPrice.text=[NSString stringWithFormat:@"总计：￥%.2f",_fromOrderInfo.order_price];
    switch (_fromOrderInfo.order_status) {
        case 0:
            lbOrderStatus.text=@"待付款";
            [_btnConfirm setTitle:@"付款" forState:UIControlStateNormal];
            [_btnConfirm addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 1:
            lbOrderStatus.text=@"待收货";
            [_btnConfirm setTitle:@"确认收货" forState:UIControlStateNormal];
            [_btnConfirm addTarget:self action:@selector(receiveClick:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            lbOrderStatus.text=@"已完成";
            _btnDelete.frame=_btnConfirm.frame;
            _btnConfirm.hidden=YES;
            break;
        default:
            break;
    }
    
    AddressInfo *addressInfo=[[DBAddress shareDBAddress] selectAddressById:_fromOrderInfo.address_id];
    lbReceiveName.text=[NSString stringWithFormat:@"姓名：%@",addressInfo.name];
    lbReceivePhone.text=[NSString stringWithFormat:@"手机：%@",addressInfo.phone];
    lbReceiveAddress.text=[NSString stringWithFormat:@"收货地址：%@%@%@%@",addressInfo.province,addressInfo.city,addressInfo.district,addressInfo.street];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIsComment:) name:@"refreshIsComment" object:nil];
    
    //12,2,0||13,1,0
    //商品id,数量,评论状态
    NSArray *goodsIdArray=[_fromOrderInfo.order_goods componentsSeparatedByString:@"||"];
    _goodsArray=[NSMutableArray array];
    for (int i=0; i<goodsIdArray.count; i++) {
        NSString *idStr=[goodsIdArray objectAtIndex:i];
        NSArray *idArray=[idStr componentsSeparatedByString:@","];
        GoodsInfo *goodsInfo=[[DBGoods shareDBGoods] selectGoodsById:[[idArray objectAtIndex:0] intValue]];
        goodsInfo.goods_num=[[idArray objectAtIndex:1] intValue];
        goodsInfo.isComment=[[idArray objectAtIndex:2] intValue];
        [_goodsArray addObject:goodsInfo];
    }
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshIsComment:(NSNotification *)notif{
    NSArray *goodsIdArray=[_fromOrderInfo.order_goods componentsSeparatedByString:@"||"];
    _goodsArray=[NSMutableArray array];
    for (int i=0; i<goodsIdArray.count; i++) {
        NSString *idStr=[goodsIdArray objectAtIndex:i];
        NSArray *idArray=[idStr componentsSeparatedByString:@","];
        GoodsInfo *goodsInfo=[[DBGoods shareDBGoods] selectGoodsById:[[idArray objectAtIndex:0] intValue]];
        goodsInfo.goods_num=[[idArray objectAtIndex:1] intValue];
        goodsInfo.isComment=[[idArray objectAtIndex:2] intValue];
        [_goodsArray addObject:goodsInfo];
    }
    [informationTable reloadData];
}

-(void)payClick:(UIButton *)sender{
    if (LoginUserInfo.user_balance<_fromOrderInfo.order_price) {
        [[Toast shareToast] makeText:@"余额不足" aDuration:1];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入密码"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认",nil];
        alertView.alertViewStyle=UIAlertViewStyleSecureTextInput;
        alertView.delegate=self;
        //通过索引0获取第一个文本框
        UITextField *tf=[alertView textFieldAtIndex:0];
        tf.font = [UIFont boldSystemFontOfSize:14];
        [tf setPlaceholder:@"请输入密码"];
        [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
        [tf setReturnKeyType:UIReturnKeyDone];
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSString *pwdStr=[tf text];
        if (![pwdStr isEqualToString:LoginUserInfo.user_pwd]) {
            [[Toast shareToast] makeText:@"密码错误" aDuration:1];
        }else{
            LoginUserInfo.user_balance-=_fromOrderInfo.order_price;
            //归档
            [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
            //更新tb_user表
            [[DBUser shareDBUser] updateUserData:LoginUserInfo];
            
            //更新订单状态
            [[DBOrder shareDBOrder] updateStatus:1 userId:LoginUserInfo.user_id orderId:_fromOrderInfo.order_id];
            [[Toast shareToast] makeText:@"支付成功" aDuration:2];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

-(void)commentClick:(UIButton *)sender{
    int index=(int)[sender tag];
    GoodsInfo *goods=[_goodsArray objectAtIndex:index];
    SubCommentController *controller=[[SubCommentController alloc] init];
    controller.fromGoodsId=goods.goods_id;
    controller.fromOrderInfo=_fromOrderInfo;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)receiveClick:(UIButton *)sender{
    [[DBOrder shareDBOrder] updateStatus:2 userId:LoginUserInfo.user_id orderId:_fromOrderInfo.order_id];
    [[Toast shareToast] makeText:@"确认收货成功" aDuration:2];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }else{
        return _goodsArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"OrderDetailGoodsCell";
    
    OrderDetailGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OrderDetailGoodsCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    GoodsInfo *goods=[_goodsArray objectAtIndex:indexPath.row];
    [cell.imgLogo setImage:[UIImage imageNamed:goods.goods_logo]];
    cell.lbTitle.text=goods.goods_name;
    cell.lbPrice.text=[NSString stringWithFormat:@"￥%.2f",goods.goods_price];
    cell.lbNum.text=[NSString stringWithFormat:@"X%i",goods.goods_num];
    if (_fromOrderInfo.order_status==2) {
        if (goods.isComment==0) {
            cell.btnComment.hidden=NO;
            cell.btnComment.tag=indexPath.row;
            [cell.btnComment addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 246;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return headView;
    }else{
        return nil;
    }
}

-(IBAction)deleteAction:(id)sender{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    actionSheet.tag=20;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[DBOrder shareDBOrder] deleteById:_fromOrderInfo.order_id];
        [[Toast shareToast] makeText:@"删除成功" aDuration:2];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (void)dealloc {
//    [super dealloc];
//}


@end
