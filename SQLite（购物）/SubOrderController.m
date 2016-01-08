//
//  FeedBack.m
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "SubOrderController.h"
#import "HomeCell.h"
#import "GoodsInfo.h"
#import "AddressListController.h"
#import "DBAddress.h"
#import "AddressInfo.h"
#import "UserInfo.h"
#import "Toast.h"
#import "MyFilePlist.h"
#import "DBUser.h"
#import "DBCart.h"
#import "DBOrder.h"
#import "OrderInfo.h"

@interface SubOrderController ()

@end

extern UserInfo *LoginUserInfo;
@implementation SubOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"填写订单";
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    [informationTable setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-52-64)];
    [tableBottomView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-53-64, 320, 53)];
    
    lbPayPrice2.text=[NSString stringWithFormat:@"￥%.2f",_fromTotalPrice];
    [self loadGoodsList];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    AddressInfo *addressInfo=[[DBAddress shareDBAddress] selectDefaultByUserId:LoginUserInfo.user_id];
    if (addressInfo!=nil) {
        lbName.text=[NSString stringWithFormat:@"收货人：%@",addressInfo.name];
        lbPhone.text=[NSString stringWithFormat:@"手机：%@",addressInfo.phone];
        lbAddress.text=[NSString stringWithFormat:@"地址：%@%@%@%@",addressInfo.province,addressInfo.city,addressInfo.district,addressInfo.street];
    }else{
        lbName.text=@"";
        lbPhone.text=@"";
        lbAddress.text=@"";
    }
}

-(IBAction)submitAction:(id)sender{
    NSLog(@"提交订单");
    AddressInfo *addressInfo=[[DBAddress shareDBAddress] selectDefaultByUserId:LoginUserInfo.user_id];
    if (addressInfo==nil) {
        [[Toast shareToast] makeText:@"请选择收获地址" aDuration:1];
    }else{
        if (LoginUserInfo.user_balance<_fromTotalPrice) {
            [[Toast shareToast] makeText:@"账户余额不足" aDuration:1];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"请输入密码"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确认",nil];
            alertView.alertViewStyle=UIAlertViewStyleSecureTextInput;
            alertView.delegate=self;
            alertView.tag=10;
            //通过索引0获取第一个文本框
            UITextField *tf=[alertView textFieldAtIndex:0];
            tf.font = [UIFont boldSystemFontOfSize:14];
            [tf setPlaceholder:@"请输入密码"];
            [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
            [tf setReturnKeyType:UIReturnKeyDone];
            [alertView show];
        }
    }
}

-(void)loadGoodsList{
    [_viewGoodsList setFrame:CGRectMake(_viewGoodsList.frame.origin.x, _viewGoodsList.frame.origin.y, _viewGoodsList.frame.size.width, 43+79*_fromGoodsList.count)];
    for (int i=0; i<_fromGoodsList.count; i++) {
        GoodsInfo *goods=[_fromGoodsList objectAtIndex:i];
        
        UIView *viewGoods=[[UIView alloc] initWithFrame:CGRectMake(0, 43+79*i, 306, 79)];
        UIImageView *imgGoodsBg=[[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 64, 64)];
        [imgGoodsBg setImage:[UIImage imageNamed:@"cart_imgbg.png"]];
        [viewGoods addSubview:imgGoodsBg];
        UIImageView *imgGoods=[[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 60, 60)];
        [imgGoods setImage:[UIImage imageNamed:goods.goods_logo]];
        [viewGoods addSubview:imgGoods];
        UILabel *lbGoodsName=[[UILabel alloc] initWithFrame:CGRectMake(94, 4, 198, 39)];
        lbGoodsName.font=[UIFont systemFontOfSize:14];
        lbGoodsName.numberOfLines=2;
        lbGoodsName.textColor=[UIColor darkGrayColor];
        lbGoodsName.text=goods.goods_name;
        [viewGoods addSubview:lbGoodsName];
        UILabel *lbGoodsPrice=[[UILabel alloc] initWithFrame:CGRectMake(94, 53, 90, 23)];
        lbGoodsPrice.font=[UIFont boldSystemFontOfSize:14];
        lbGoodsPrice.textColor=[UIColor redColor];
        lbGoodsPrice.text=[NSString stringWithFormat:@"￥%.2f",goods.goods_price];
        [viewGoods addSubview:lbGoodsPrice];
        UILabel *lbGoodsNum=[[UILabel alloc] initWithFrame:CGRectMake(224, 53, 68, 23)];
        lbGoodsNum.font=[UIFont systemFontOfSize:14];
        lbGoodsNum.textColor=[UIColor darkGrayColor];
        lbGoodsNum.textAlignment=NSTextAlignmentRight;
        lbGoodsNum.text=[NSString stringWithFormat:@"X%i",goods.goods_num];
        [viewGoods addSubview:lbGoodsNum];
        UIImageView *imgLine=[[UIImageView alloc] initWithFrame:CGRectMake(0, 78, 306, 1)];
        [imgLine setImage:[UIImage imageNamed:@"line_solid.png"]];
        [viewGoods addSubview:imgLine];
        
        [_viewGoodsList addSubview:viewGoods];
    }
}

-(IBAction)selectAddressAction:(id)sender{
    AddressListController *controller=[[AddressListController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10) {
        if (buttonIndex==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"是否放弃付款" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alert.tag=20;
            [alert show];
        }
        if (buttonIndex==1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            NSString *pwdStr=[tf text];
            if (![pwdStr isEqualToString:LoginUserInfo.user_pwd]) {
                [[Toast shareToast] makeText:@"密码错误" aDuration:1];
            }else{
                LoginUserInfo.user_balance-=_fromTotalPrice;
                //归档
                [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
                //更新tb_user表
                [[DBUser shareDBUser] updateUserData:LoginUserInfo];
                
                //从tb_cart表中删除
                for (int i=0; i<_fromGoodsList.count; i++) {
                    GoodsInfo *goods=[_fromGoodsList objectAtIndex:i];
                    [[DBCart shareDBCart] deleteByGoodsId:goods.goods_id];
                }
                
                //添加至tb_order表
                OrderInfo *orderInfo=[[OrderInfo alloc] init];
                orderInfo.order_id=[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
                orderInfo.order_price=_fromTotalPrice;
                orderInfo.order_status=1;//待收货
                NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *nowDateStr=[formatter stringFromDate:[NSDate date]];
                NSLog(@"%@",nowDateStr);
                orderInfo.order_time=nowDateStr;
                NSMutableString *goodsIdStr=[NSMutableString string];
                for (int i=0; i<_fromGoodsList.count; i++) {
                    GoodsInfo *goods=[_fromGoodsList objectAtIndex:i];
                    //12,2,0||13,1,0
                    //商品id,数量,评论状态
                    [goodsIdStr appendFormat:@"%i,%i,0",goods.goods_id,goods.goods_num];
                    if (i!=_fromGoodsList.count-1) {
                        [goodsIdStr appendString:@"||"];
                    }
                }
                NSLog(@"%@",goodsIdStr);
                orderInfo.order_goods=goodsIdStr;
                AddressInfo *addressInfo=[[DBAddress shareDBAddress] selectDefaultByUserId:LoginUserInfo.user_id];
                orderInfo.address_id=addressInfo.address_id;
                [[DBOrder shareDBOrder] insertData:orderInfo userId:LoginUserInfo.user_id];
                
                [[Toast shareToast] makeText:@"支付成功" aDuration:2];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    if (alertView.tag==20) {
        if (buttonIndex==0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"请输入密码"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确认",nil];
            alertView.alertViewStyle=UIAlertViewStyleSecureTextInput;
            alertView.delegate=self;
            alertView.tag=10;
            //通过索引0获取第一个文本框
            UITextField *tf=[alertView textFieldAtIndex:0];
            tf.font = [UIFont boldSystemFontOfSize:14];
            [tf setPlaceholder:@"请输入密码"];
            [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
            [tf setReturnKeyType:UIReturnKeyDone];
            [alertView show];
        }
        if (buttonIndex==1) {
            //从tb_cart表中删除
            for (int i=0; i<_fromGoodsList.count; i++) {
                GoodsInfo *goods=[_fromGoodsList objectAtIndex:i];
                [[DBCart shareDBCart] deleteByGoodsId:goods.goods_id];
            }
            
            //添加至tb_order表
            OrderInfo *orderInfo=[[OrderInfo alloc] init];
            orderInfo.order_id=[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            orderInfo.order_price=_fromTotalPrice;
            orderInfo.order_status=0;//待收货
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *nowDateStr=[formatter stringFromDate:[NSDate date]];
            NSLog(@"%@",nowDateStr);
            orderInfo.order_time=nowDateStr;
            NSMutableString *goodsIdStr=[NSMutableString string];
            for (int i=0; i<_fromGoodsList.count; i++) {
                GoodsInfo *goods=[_fromGoodsList objectAtIndex:i];
                //12,2,0||13,1,0
                [goodsIdStr appendFormat:@"%i,%i,0",goods.goods_id,goods.goods_num];
                if (i!=_fromGoodsList.count-1) {
                    [goodsIdStr appendString:@"||"];
                }
            }
            NSLog(@"%@",goodsIdStr);
            orderInfo.order_goods=goodsIdStr;
            AddressInfo *addressInfo=[[DBAddress shareDBAddress] selectDefaultByUserId:LoginUserInfo.user_id];
            orderInfo.address_id=addressInfo.address_id;
            [[DBOrder shareDBOrder] insertData:orderInfo userId:LoginUserInfo.user_id];
            
            [[Toast shareToast] makeText:@"已添加至待付款订单" aDuration:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"HomeCell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 204+79*_fromGoodsList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return headView;
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
