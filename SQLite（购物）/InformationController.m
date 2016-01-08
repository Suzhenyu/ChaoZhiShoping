//
//  FeedBack.m
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "InformationController.h"
#import "HomeCell.h"
#import "InfoDetailViewController.h"
#import "CommentListController.h"
#import "CartNavController.h"
#import "DBImg.h"
#import "GoodsInfo.h"
#import "DBCart.h"
#import "Toast.h"
#import "DBComment.h"
#import "DBGoods.h"
#import "HelperUtil.h"
#import "XPhotoBrowserViewController.h"
#import "XPhoto.h"

@interface InformationController ()<XPhotoBrowserViewControllerDelegate,XPhotoBrowserViwControllerDataSource>
{
    NSMutableArray *_goodsImgArray;
    UIImageView *_imgCartNum;
    UILabel *_lbCartNum;
    
    NSMutableArray *_recommendArray;
    NSMutableArray *_randomArray;
}
@end

@implementation InformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"商品详情";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIView *viewCart=[[UIView alloc] initWithFrame:CGRectMake(7, 7, 26, 30)];
    [viewCart setBackgroundColor:[UIColor clearColor]];
    UIButton *btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCart setFrame:CGRectMake(0, 4, 26, 22)];
    [btnCart addTarget:self action:@selector(cartClick) forControlEvents:UIControlEventTouchUpInside];
    [btnCart setBackgroundImage:[UIImage imageNamed:@"nav_cart_bg.png"] forState:UIControlStateNormal];
    btnCart.showsTouchWhenHighlighted = YES;
    [viewCart addSubview:btnCart];
    _imgCartNum=[[UIImageView alloc] initWithFrame:CGRectMake(10, -2, 18, 18)];
    [_imgCartNum setImage:[UIImage imageNamed:@"nav_cart_num.png"]];
    [viewCart addSubview:_imgCartNum];
    _lbCartNum=[[UILabel alloc] initWithFrame:CGRectMake(13, 1, 12, 12)];
    [_lbCartNum setBackgroundColor:[UIColor clearColor]];
    _lbCartNum.font = [UIFont boldSystemFontOfSize:10];
    _lbCartNum.textColor = [UIColor whiteColor];
    _lbCartNum.textAlignment=NSTextAlignmentCenter;
    _lbCartNum.text=@"";
    [viewCart addSubview:_lbCartNum];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:viewCart];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [informationTable setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-52-64)];
    [tableBottomView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-53-64, 320, 53)];
    [imgGoodsAnima setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-53-64, 55, 40)];
    
    _lbGoodsName.text=_fromGoods.goods_name;
    _lbPrice.text=[NSString stringWithFormat:@"￥%.2f",_fromGoods.goods_price];
    _goodsImgArray=[[DBImg shareDBImg] selectImgsByGoodsId:_fromGoods.goods_id];
    _lbImgsPage.text=[NSString stringWithFormat:@"1/%li",_goodsImgArray.count];
    lbCommentCounts.text=[NSString stringWithFormat:@"已有%i人评价",[[DBComment shareDBComment] selectCountByGoodsId:_fromGoods.goods_id]];
    NSLog(@"%i",_fromGoods.type_id);
    
    [self loadHeadScroll];
    
    _randomArray=[NSMutableArray array];
    _recommendArray=[[DBGoods shareDBGoods] selectRecommandList:_fromGoods.goods_id type:_fromGoods.type_id];
    [self loadRecommend];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    int num=[[DBCart shareDBCart] selectCartCount];
    if (num>0) {
        _imgCartNum.hidden=NO;
        _lbCartNum.text=[NSString stringWithFormat:@"%i",num];
    }else{
        _imgCartNum.hidden=YES;
        _lbCartNum.text=@"";
    }
}

-(void)cartClick{
    CartNavController *controller=[[CartNavController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)loadHeadScroll{
    CGSize newSize = CGSizeMake(scrollImgs.frame.size.width*_goodsImgArray.count, scrollImgs.bounds.size.height);
    [scrollImgs setContentSize:newSize];
    
    for (int i=0; i<_goodsImgArray.count; i++) {
        XPhoto *xPhoto=[_goodsImgArray objectAtIndex:i];
        
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(scrollImgs.frame.size.width*i, scrollImgs.frame.origin.y, scrollImgs.frame.size.width, scrollImgs.frame.size.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView setImage:xPhoto.image];
        [scrollImgs addSubview:imgView];
        
        UIButton *btnImg=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnImg setFrame:imgView.frame];
        btnImg.tag=i;
        [btnImg addTarget:self action:@selector(imgClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollImgs addSubview:btnImg];
    }
}
-(void)imgClick:(UIButton *)sender{
    int currentIndex=(int)[sender tag];
    
    XPhotoBrowserViewController *vc = [[XPhotoBrowserViewController alloc] init];
    vc.delegate = self;
    vc.dataSource = self;
    //设置当前第几页
    vc.currentPhotoIndex = currentIndex;
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark XPhotoBrowserViewControllerDelegate AND XPhotoBrowserViwControllerDataSource
//删除按钮点击
- (void)photoBrowser:(XPhotoBrowserViewController *)photoBrowser didDeletePhotoAtIndex:(NSUInteger)index
{
    [_goodsImgArray removeObjectAtIndex:index];
    [photoBrowser reloadData];
}
- (void)photoBrowser:(XPhotoBrowserViewController *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    
}
//每一页显示的XPhoto对象
- (XPhoto*)photoBrowser:(XPhotoBrowserViewController *)photoBrowser photoOfIndex:(NSUInteger)index
{
    XPhoto *photo = [_goodsImgArray objectAtIndex:index];
    return photo;
}
//显示的数量
- (NSInteger)numberOfPhotoInPhotoBrowser:(XPhotoBrowserViewController *)photoBrowser
{
    return _goodsImgArray.count;
}

-(void)loadRecommend{
    //产生随机3个商品
    int r1 = arc4random()%[_recommendArray count];
    [_randomArray addObject:[_recommendArray objectAtIndex:r1]];
    [_recommendArray removeObjectAtIndex:r1];
    int r2 = arc4random()%[_recommendArray count];
    [_randomArray addObject:[_recommendArray objectAtIndex:r2]];
    [_recommendArray removeObjectAtIndex:r2];
    int r3 = arc4random()%[_recommendArray count];
    [_randomArray addObject:[_recommendArray objectAtIndex:r3]];
    [_recommendArray removeObjectAtIndex:r3];
    
    for (int i=0; i<_randomArray.count; i++) {
        GoodsInfo *goodsInfo=[_randomArray objectAtIndex:i];
        
        UIImageView *imgLogoBg=[[UIImageView alloc] initWithFrame:CGRectMake(12+99*i, 32, 85, 85)];
        [imgLogoBg setImage:[UIImage imageNamed:@"cart_imgbg.png"]];
        UIImageView *imgLogo=[[UIImageView alloc] initWithFrame:CGRectMake(13+99*i, 33, 83, 83)];
        [imgLogo setImage:[UIImage imageNamed:goodsInfo.goods_logo]];
        UIButton *btnImgClick=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnImgClick setFrame:imgLogo.frame];
        btnImgClick.tag=i;
        [btnImgClick addTarget:self action:@selector(recommendGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lbName=[[UILabel alloc] initWithFrame:CGRectMake(12+99*i, 121, 85, 32)];
        [lbName setBackgroundColor:[UIColor clearColor]];
        lbName.font = [UIFont systemFontOfSize:12];
        lbName.textColor = [HelperUtil colorWithHexString:@"#333333"];
        lbName.numberOfLines=2;
        lbName.text=goodsInfo.goods_name;
        UILabel *lbGoodsPrice=[[UILabel alloc] initWithFrame:CGRectMake(12+99*i, 154, 85, 21)];
        [lbGoodsPrice setBackgroundColor:[UIColor clearColor]];
        lbGoodsPrice.font = [UIFont systemFontOfSize:14];
        lbGoodsPrice.textColor = [HelperUtil colorWithHexString:@"#e50012"];
        lbGoodsPrice.text=[NSString stringWithFormat:@"￥%.2f",goodsInfo.goods_price];
        [viewRecommend addSubview:imgLogoBg];
        [viewRecommend addSubview:imgLogo];
        [viewRecommend addSubview:btnImgClick];
        [viewRecommend addSubview:lbName];
        [viewRecommend addSubview:lbGoodsPrice];
    }
}

-(IBAction)addCarAction:(UIButton *)sender{
    if ([[DBCart shareDBCart] insertData:_fromGoods.goods_id]) {
        int num=[[DBCart shareDBCart] selectCartCount];
        _imgCartNum.hidden=NO;
        _lbCartNum.text=[NSString stringWithFormat:@"%i",num];
        [[Toast shareToast] makeText:@"添加购物车成功" aDuration:1];
    }else{
        [[Toast shareToast] makeText:@"添加购物车失败" aDuration:1];
    }
    
}

-(IBAction)goDetailAction:(id)sender{
    InfoDetailViewController *controller=[[InfoDetailViewController alloc] init];
    controller.fromGoodsId=_fromGoods.goods_id;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)commentListAction:(id)sender{
    CommentListController *controller=[[CommentListController alloc] init];
    controller.fromGoodsId=_fromGoods.goods_id;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)recommendGoodsClick:(UIButton *)sender{
    int index=(int)sender.tag;
    GoodsInfo *goods=[_randomArray objectAtIndex:index];
    InformationController *controller=[[InformationController alloc] init];
    controller.fromGoods=goods;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    if ([scrollView isEqual:scrollImgs]) {
        int page = scrollView.contentOffset.x / 320;
        NSLog(@"page---%i",page);
        _lbImgsPage.text=[NSString stringWithFormat:@"%i/%li",page+1,_goodsImgArray.count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
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
    return 615;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return headView;
}

-(void)dealloc{
    NSLog(@"销毁");
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


@end
