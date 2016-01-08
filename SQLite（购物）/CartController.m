//
//  FeedBack.m
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "CartController.h"
#import "HelperUtil.h"
#import "CartCell.h"
#import "InformationController.h"
#import "SubOrderController.h"
#import "DBCart.h"
#import "GoodsInfo.h"
#import "Toast.h"
#import "UserInfo.h"
#import "LoginController.h"

@interface CartController ()
{
    NSMutableArray *_cartArray;
    
    //总价
    float _cartTotalPrice;
    //总数量
    int _cartTotalCount;
}
@end

extern UserInfo *LoginUserInfo;
@implementation CartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_cartTable setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.title=@"购物车";
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setFrame:CGRectMake(0, 0, 24, 25)];
    [clearBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setBackgroundImage:[UIImage imageNamed:@"cart_delete.png"] forState:UIControlStateNormal];
    clearBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:clearBtn];
    self.tabBarController.navigationItem.rightBarButtonItem = rightBtn;
    
    _cartArray=[[DBCart shareDBCart] selectCartGoodsList];
    NSLog(@"%li",_cartArray.count);
    [_cartTable reloadData];
    
    _cartTotalCount=0;
    _cartTotalPrice=0.0f;
    [_btnBuy setTitle:@"结算（0）" forState:UIControlStateNormal];
    _lbTotalPrice.text=@"总计:0.00";
    
//    cartTotalScore=0;
//    for (int i=0; i<cartArray.count; i++) {
//        GoodsInfo *goodsInfo=[cartArray objectAtIndex:i];
//        goodsInfo.goods_selected=NO;
//    }
//    [cartTable reloadData];
//    [btnBuy setTitle:@"结算（0）" forState:UIControlStateNormal];
//    lbTotalPrice.text=[NSString stringWithFormat:@"总计:%0.2f",cartTotalPrice];
//    lbTotalScore.text=[NSString stringWithFormat:@"消耗积分:%i",cartTotalScore];
}

-(void)deleteClick{
    NSLog(@"删除");
    if (_cartTotalCount>0) {
        
        for (int i=0; i<_cartArray.count; i++) {
            GoodsInfo *goodsInfo=[_cartArray objectAtIndex:i];
            if (goodsInfo.goods_selected) {
                [[DBCart shareDBCart] deleteByGoodsId:goodsInfo.goods_id];
            }
        }
        //恢复初始数据
        _cartTotalPrice=0.0f;
        [_btnBuy setTitle:@"结算（0）" forState:UIControlStateNormal];
        _lbTotalPrice.text=@"总计:0.00";
        
        _cartArray=[[DBCart shareDBCart] selectCartGoodsList];
        [_cartTable reloadData];
        [[Toast shareToast] makeText:@"删除成功" aDuration:1];
        
    }else{
        [[Toast shareToast] makeText:@"请选择商品" aDuration:1];
    }
}

-(IBAction)buyAction:(UIButton*)sender{
    if (_cartTotalCount>0) {
        if (LoginUserInfo==nil) {//未登录状态
            [[Toast shareToast] makeText:@"请先登录" aDuration:1];
            LoginController *controller=[[LoginController alloc] init];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            NSMutableArray *seletedArray=[NSMutableArray array];
            for (int i=0; i<_cartArray.count; i++) {
                GoodsInfo *goodsInfo=[_cartArray objectAtIndex:i];
                if (goodsInfo.goods_selected) {
                    [seletedArray addObject:goodsInfo];
                }
            }
            
            SubOrderController *controller=[[SubOrderController alloc] init];
            controller.fromGoodsList=seletedArray;
            controller.fromTotalPrice=_cartTotalPrice;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        [[Toast shareToast] makeText:@"请选择商品" aDuration:1];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cartArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CartCell";
    
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    GoodsInfo *goods=[_cartArray objectAtIndex:indexPath.row];
    cell.lbGoodsTitle.text=goods.goods_name;
    [cell.imgGoodsLogo setImage:[UIImage imageNamed:goods.goods_logo]];
    //小计
    cell.lbGoodsPrice.text=[NSString stringWithFormat:@"￥%.2f",goods.goods_price*goods.goods_num];
    //数量
    cell.lbGoodsNum.text=[NSString stringWithFormat:@"%i",goods.goods_num];
    
    if (goods.goods_selected) {
        [cell.imgGoodsSelected setImage:[UIImage imageNamed:@"cart_selected1.png"]];
        cell.btnGoodsSelected.tag=indexPath.row;
        [cell.btnGoodsSelected addTarget:self action:@selector(goodsUnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.imgGoodsSelected setImage:[UIImage imageNamed:@"cart_selected0.png"]];
        cell.btnGoodsSelected.tag=indexPath.row;
        [cell.btnGoodsSelected addTarget:self action:@selector(goodsSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.btnGoodsJian1.tag=indexPath.row;
    cell.btnGoodsJian2.tag=indexPath.row;
    cell.btnGoodsJia1.tag=indexPath.row;
    cell.btnGoodsJia2.tag=indexPath.row;
    [cell.btnGoodsJian1 addTarget:self action:@selector(jianClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnGoodsJian2 addTarget:self action:@selector(jianClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnGoodsJia1 addTarget:self action:@selector(jiaClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnGoodsJia2 addTarget:self action:@selector(jiaClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    GoodsInfo *goods=[_cartArray objectAtIndex:indexPath.row];
    
    InformationController *controller=[[InformationController alloc] init];
    controller.fromGoods=goods;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)goodsSelected:(UIButton *)sender{
    NSLog(@"选中");
    int index=(int)[sender tag];
    GoodsInfo *goodsInfo=[_cartArray objectAtIndex:index];
    goodsInfo.goods_selected=YES;
    [_cartTable reloadData];
    
    //计算结算数量
    _cartTotalCount++;
    [_btnBuy setTitle:[NSString stringWithFormat:@"结算(%i)",_cartTotalCount] forState:UIControlStateNormal];
    
    //计算总价
    float fTotal=goodsInfo.goods_price*goodsInfo.goods_num;
    _cartTotalPrice+=fTotal;
    _lbTotalPrice.text=[NSString stringWithFormat:@"总计:%0.2f",_cartTotalPrice];
    
}
-(void)goodsUnSelected:(UIButton *)sender{
    NSLog(@"取消选中");
    int index=(int)[sender tag];
    GoodsInfo *goodsInfo=[_cartArray objectAtIndex:index];
    goodsInfo.goods_selected=NO;
    [_cartTable reloadData];
    
    //计算结算数量
    _cartTotalCount--;
    [_btnBuy setTitle:[NSString stringWithFormat:@"结算(%i)",_cartTotalCount] forState:UIControlStateNormal];
    
    //计算总价
    float fTotal=goodsInfo.goods_price*goodsInfo.goods_num;
    _cartTotalPrice-=fTotal;
    _lbTotalPrice.text=[NSString stringWithFormat:@"总计:%0.2f",_cartTotalPrice];
    
}

-(void)jianClick:(UIButton *)sender{
    NSLog(@"减");
    int index=(int)[sender tag];
    GoodsInfo *goodsInfo=[_cartArray objectAtIndex:index];
    if (goodsInfo.goods_num>1) {
        goodsInfo.goods_num--;
        
        if ([[DBCart shareDBCart] updateNumByGoodsId:goodsInfo.goods_id count:goodsInfo.goods_num]) {
            //刷新指定Cell
            CartCell *cell=(CartCell *)[[[sender superview] superview] superview];
            //取出IndexPath
            NSIndexPath *indexPath=[_cartTable indexPathForCell:cell];
            [_cartTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
//            [_cartTable reloadData];
        }
        
        if (goodsInfo.goods_selected) {
            //计算总价
            _cartTotalPrice-=goodsInfo.goods_price;
            _lbTotalPrice.text=[NSString stringWithFormat:@"总计:%0.2f",_cartTotalPrice];
        }
    }else{
        [[Toast shareToast] makeText:@"受不了了，宝贝不能再减少了哦！" aDuration:1];
    }
}

-(void)jiaClick:(UIButton *)sender{
    NSLog(@"加");
    int index=(int)[sender tag];
    GoodsInfo *goodsInfo=[_cartArray objectAtIndex:index];
    goodsInfo.goods_num++;
    if ([[DBCart shareDBCart] updateNumByGoodsId:goodsInfo.goods_id count:goodsInfo.goods_num]) {
        [_cartTable reloadData];
    }
    
    if (goodsInfo.goods_selected) {
        //计算总价
        _cartTotalPrice+=goodsInfo.goods_price;
        _lbTotalPrice.text=[NSString stringWithFormat:@"总计:%0.2f",_cartTotalPrice];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


@end
