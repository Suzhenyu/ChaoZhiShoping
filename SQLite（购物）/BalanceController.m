//
//  BalanceController.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "BalanceController.h"
#import "Toast.h"
#import "DBUser.h"
#import "MyFilePlist.h"
#import "UserInfo.h"

@interface BalanceController ()

@end

extern UserInfo *LoginUserInfo;
@implementation BalanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"余额充值";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_tfPrice becomeFirstResponder];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)enterAction:(id)sender{
    NSString *priceStr=[_tfPrice text];
    if ([priceStr isEqualToString:@""]) {
        [[Toast shareToast] makeText:@"请输入充值金额" aDuration:1];
    }else{
        LoginUserInfo.user_balance+=[priceStr doubleValue];
        
        //归档
        [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
        //更新tb_user表
        [[DBUser shareDBUser] updateUserData:LoginUserInfo];
        
        [[Toast shareToast] makeText:@"充值成功" aDuration:1];
        [self.navigationController popViewControllerAnimated:YES];
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
