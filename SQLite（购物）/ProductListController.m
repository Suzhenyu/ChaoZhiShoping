//
//  FeedBack.m
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "ProductListController.h"
#import "ProductListCell.h"
#import "InformationController.h"
#import "MarketInfo.h"
#import "GoodsInfo.h"
#import "DBGoods.h"

@interface ProductListController ()
{
    NSArray *_goodsArray;
    BOOL _sortType;//YES降序,NO升序
}
@end

@implementation ProductListController
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData:NO];
    
    NSString *titleStr=[NSString stringWithFormat:@"\"%@\"",self.title];
    UIFont *contentsFont = [UIFont systemFontOfSize:14];
    CGSize contentsSize = [titleStr sizeWithFont:contentsFont constrainedToSize:CGSizeMake(320, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    [_lbTitle setFrame:CGRectMake(10, 9, contentsSize.width, 21)];
    [_lbTotalCount setFrame:CGRectMake(10+contentsSize.width+5, 9, 195, 21)];
    _lbTitle.text=titleStr;
    _lbTotalCount.text=[NSString stringWithFormat:@"共%li条信息",(unsigned long)_goodsArray.count];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData:(BOOL)sortBOOL{
    if (_fromMarket!=nil) {//活动->进入
        self.title=_fromMarket.market_value;
        _goodsArray=[[DBGoods shareDBGoods] selectGoodsList:nil type:0 market:_fromMarket.market_id sort:sortBOOL];
    }else if (_fromSearchParam!=nil){//搜索->进入
        self.title=_fromSearchParam;
        _goodsArray=[[DBGoods shareDBGoods] selectGoodsList:_fromSearchParam type:0 market:0 sort:sortBOOL];
    }else{//分类->进入
        switch (_fromTypeId) {
            case 10001:
                self.title=@"手机数码";
                break;
            case 10002:
                self.title=@"服装鞋帽";
                break;
            case 10003:
                self.title=@"美妆护理";
                break;
            case 10004:
                self.title=@"家居家电";
                break;
            case 10005:
                self.title=@"礼品箱包";
                break;
            case 10006:
                self.title=@"美食美酒";
                break;
            case 10007:
                self.title=@"营养保健";
                break;
            default:
                self.title=@"汽车户外";
                break;
        }
        _goodsArray=[[DBGoods shareDBGoods] selectGoodsList:nil type:_fromTypeId market:0 sort:sortBOOL];
    }
}

-(IBAction)sortAction:(UIButton*)sender{
    if (_sortType) {
        //升序
        _sortType=NO;
        [_imgSortIcon setImage:[UIImage imageNamed:@"icon_sort2.png"]];
        [self loadData:NO];
    }else{
        //降序
        _sortType=YES;
        [_imgSortIcon setImage:[UIImage imageNamed:@"icon_sort1.png"]];
        [self loadData:YES];
    }
    [productListTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _goodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ProductListCell";
    
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProductListCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    GoodsInfo *goods=[_goodsArray objectAtIndex:indexPath.row];
    cell.lbTitle.text=goods.goods_name;
    cell.lbPrice.text=[NSString stringWithFormat:@"￥%.2f",goods.goods_price];
    [cell.imgLogo setImage:[UIImage imageNamed:goods.goods_logo]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 68;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    GoodsInfo *goodsInfo=[_goodsArray objectAtIndex:indexPath.row];
    InformationController *controller=[[InformationController alloc] init];
    controller.fromGoods=goodsInfo;
    [self.navigationController pushViewController:controller animated:YES];
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
