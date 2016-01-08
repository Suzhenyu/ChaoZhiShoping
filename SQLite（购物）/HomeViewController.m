//
//  HomeViewController.m
//  SQLite（购物）
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "HelperUtil.h"
#import "InformationController.h"
#import "ProductListController.h"
#import "SearchProductController.h"
#import "MyFilePlist.h"
#import "DBMarket.h"
#import "MarketInfo.h"
#import "GoodsInfo.h"

@interface HomeViewController ()
{
    NSArray *_marketArray;
    //为了防止tableView的页眉重复添加
    //定义该变量统计（最大只能是_marketArray最元素个数）
//    NSMutableArray *_headerMarketArray;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_viewHeader setBackgroundColor:[HelperUtil colorWithHexString:@"#ededed"]];
    [_tableView setBackgroundColor:[HelperUtil colorWithHexString:@"#ededed"]];
    
    _tableView.tableHeaderView=_viewHeader;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forwardSearchToList:) name:@"forwardSearchToList" object:nil];
    
    [self loadHeadScroll];
    
    _marketArray=[[DBMarket shareDBMarket] selectAllMarket];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.title=@"首页";
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
}

-(void)forwardSearchToList:(NSNotification *)notifi{
    NSString *searchValue=[notifi object];
    NSLog(@"%@",searchValue);
    
    ProductListController *controller=[[ProductListController alloc] init];
    controller.fromSearchParam=searchValue;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)loadHeadScroll{
    CGSize newSize = CGSizeMake(_scrollHeader.frame.size.width*3, _scrollHeader.bounds.size.height);
    [_scrollHeader setContentSize:newSize];
    
    for (int i=0; i<3; i++) {
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(_scrollHeader.frame.size.width*i, _scrollHeader.frame.origin.y, _scrollHeader.frame.size.width, _scrollHeader.frame.size.height)];
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_test%i.png",i+1]]];
        [_scrollHeader addSubview:imgView];
        
        UIButton *btnImg=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnImg setFrame:imgView.frame];
        btnImg.tag=i;
        [_scrollHeader addSubview:btnImg];
    }
}

-(IBAction)searchAction:(id)sender{
    SearchProductController *controller=[[SearchProductController alloc] init];
    [self presentViewController:controller animated:NO completion:nil];
}
-(IBAction)typeClickAction:(UIButton *)sender{
    int typeIndex=(int)[sender tag];
    
    ProductListController *controller=[[ProductListController alloc] init];
    controller.fromTypeId=typeIndex;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _marketArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MarketInfo *marketInfo=[_marketArray objectAtIndex:section];
    /*
     5/2=2;
     5.0/2.0=2.5;
     */
    return marketInfo.goodsArray.count%2==0?marketInfo.goodsArray.count/2:marketInfo.goodsArray.count/2+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 223;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HomeCell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    //取出MarketInfo对象
    MarketInfo *marketInfo=[_marketArray objectAtIndex:indexPath.section];
    
    //从MarketInfo对象中的goodsArray取出GoodsInfo对象
    GoodsInfo *goods1=[[GoodsInfo alloc] init];
    GoodsInfo *goods2=[[GoodsInfo alloc] init];
    
    goods1=[marketInfo.goodsArray objectAtIndex:2*indexPath.row];//左边的商品
    if (marketInfo.goodsArray.count>2*indexPath.row+1) {//右边的商品
        goods2=[marketInfo.goodsArray objectAtIndex:2*indexPath.row+1];
    }
    
    //左边的商品
    cell.imgBg1.hidden=YES;
    [cell.imgLogo1 setImage:[UIImage imageNamed:goods1.goods_logo]];
    cell.btn1.tag=2*indexPath.row;//goodsArray数组中的下标
    [cell.btn1 addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.lbTitle1.text=goods1.goods_name;
    cell.lbPrice1.text=[NSString stringWithFormat:@"￥%.2f",goods1.goods_price];
    //右边的商品
    if (marketInfo.goodsArray.count>2*indexPath.row+1) {
        cell.imgBg2.hidden=YES;
        [cell.imgLogo2 setImage:[UIImage imageNamed:goods2.goods_logo]];
        cell.btn2.tag=2*indexPath.row+1;//goodsArray数组中的下标
        [cell.btn2 addTarget:self action:@selector(goodsClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.lbTitle2.text=goods2.goods_name;
        cell.lbPrice2.text=[NSString stringWithFormat:@"￥%.2f",goods2.goods_price];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
//    if (section==0) {
//        return 338;
//    }else{
//        return 35;
//    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return _viewHeader;
//    }else{
        MarketInfo *marketInfo=[_marketArray objectAtIndex:section];
        
        UIView *returnView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        UIImageView *imgBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        [imgBg setImage:[UIImage imageNamed:@"search_hd_bar_02.png"]];
        [returnView addSubview:imgBg];
        
        UILabel *lbSubTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 7, 128, 21)];
        lbSubTitle.text=marketInfo.market_value;
        lbSubTitle.font=[UIFont systemFontOfSize:17];
        lbSubTitle.textAlignment=NSTextAlignmentLeft;
        lbSubTitle.textColor=[UIColor whiteColor];
        [lbSubTitle setBackgroundColor:[UIColor clearColor]];
        [returnView addSubview:lbSubTitle];
        
        UILabel *lbMore=[[UILabel alloc] initWithFrame:CGRectMake(262, 7, 50, 21)];
        lbMore.text=@"更多";
        lbMore.font=[UIFont systemFontOfSize:14];
        lbMore.textAlignment=NSTextAlignmentRight;
        lbMore.textColor=[UIColor whiteColor];
        [lbMore setBackgroundColor:[UIColor clearColor]];
        [returnView addSubview:lbMore];
        
        UIButton *btnMore=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnMore setFrame:CGRectMake(255, 0, 65, 35)];
        [btnMore addTarget:self action:@selector(marketClick:) forControlEvents:UIControlEventTouchUpInside];
        btnMore.tag=section;
        [returnView addSubview:btnMore];
        
        return returnView;
        
//    }
}

-(void)marketClick:(UIButton *)sender{
    int index=(int)[sender tag];
    MarketInfo *marketInfo=[_marketArray objectAtIndex:index];
    
    ProductListController *controller=[[ProductListController alloc] init];
    controller.fromMarket=marketInfo;
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)goodsClick:(UIButton *)sender{
    //通过supertview逐级获取
    HomeCell *cell=(HomeCell *)[[sender superview] superview];
    //-(NSIndexPath *)indexPathForCell:(UITableViewCell*)cell
    //通过该方法可以获取到对应的NSIndexPath，然后通过NSIndexPath可以获取到section、row
    NSIndexPath *indexPath=[_tableView indexPathForCell:cell];
    
    MarketInfo *marketInfo=[_marketArray objectAtIndex:indexPath.section];
    GoodsInfo *goods=[marketInfo.goodsArray objectAtIndex:sender.tag];
    NSLog(@"%@",goods.goods_name);
    
    InformationController *controller=[[InformationController alloc] init];
    controller.fromGoods=goods;
    [self.navigationController pushViewController:controller animated:YES];
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
