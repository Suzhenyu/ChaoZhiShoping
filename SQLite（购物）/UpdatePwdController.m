//
//  UpdatePwdController.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "UpdatePwdController.h"
#import "Toast.h"
#import "MyFilePlist.h"
#import "DBUser.h"
#import "UserInfo.h"

@interface UpdatePwdController ()

@end

extern UserInfo *LoginUserInfo;
@implementation UpdatePwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"修改密码";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_tfOldPwd becomeFirstResponder];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleSingleTapFrom{
    [_tfOldPwd resignFirstResponder];
    [_tfNewPwd1 resignFirstResponder];
    [_tfNewPwd2 resignFirstResponder];
}

-(IBAction)enterAction:(id)sender{
    NSString *oldPwdStr=[_tfOldPwd text];
    NSString *newPwdStr1=[_tfNewPwd1 text];
    NSString *newPwdStr2=[_tfNewPwd2 text];
    
    if ([oldPwdStr isEqualToString:@""]) {
        [[Toast shareToast] makeText:@"请输入旧密码" aDuration:1];
    }else if ([newPwdStr1 isEqualToString:@""]){
        [[Toast shareToast] makeText:@"请输入新密码" aDuration:1];
    }else if ([newPwdStr2 isEqualToString:@""]){
        [[Toast shareToast] makeText:@"请确认新密码" aDuration:1];
    }else if (![oldPwdStr isEqualToString:LoginUserInfo.user_pwd]){
        [[Toast shareToast] makeText:@"旧密码不正确" aDuration:1];
    }else if (![newPwdStr1 isEqualToString:newPwdStr2]){
        [[Toast shareToast] makeText:@"两次新密码不一致" aDuration:1];
    }else{
        [self handleSingleTapFrom];
        
        LoginUserInfo.user_pwd=newPwdStr2;
        
        //归档
        [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
        //更新tb_user表
        [[DBUser shareDBUser] updateUserData:LoginUserInfo];
        
        [[Toast shareToast] makeText:@"修改密码成功" aDuration:1];
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
