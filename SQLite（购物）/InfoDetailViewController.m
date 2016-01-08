//
//  InfoDetailViewController.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "DBGoods.h"
#import "HelperUtil.h"

@interface InfoDetailViewController ()
{
    NSString *_goodsHTML;
}
@end

@implementation InfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"商品信息";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    _goodsHTML=[[DBGoods shareDBGoods] selectGoodsHTML:_fromGoodsId];
    
    //找到本地资源(info_detail.html)
    NSString *pathStr=[[NSBundle mainBundle] pathForResource:@"info_detail" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathStr]]];
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *bodyStr=[HelperUtil htmlShuangyinhao:_goodsHTML];
    
    /*
     document.getElementById('content').innerHTML="<img src="test.png"></img>'
     <span>dd</span>";
     */
    
    NSString *setContents = [NSString stringWithFormat:@"document.getElementById('content').innerHTML=\"%@\";",bodyStr];
    [_webView stringByEvaluatingJavaScriptFromString:setContents];
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
