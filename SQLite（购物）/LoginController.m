//
//  ViewController.m
//  Talktalk
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"
#import "Toast.h"
#import "LoadingRequestView.h"
#import "RegController.h"
#import "UserInfo.h"
#import "MyFilePlist.h"
#import "DBUser.h"

extern UserInfo *LoginUserInfo;

@implementation LoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"登录";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_top_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"newsTopBg_new.png"] forBarMetrics:UIBarMetricsDefault];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    _imgLoginIcon.layer.cornerRadius=5.0f;
#pragma mark--!!!
    _imgLoginIcon.layer.masksToBounds=YES;
    
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
	[loginBgView addGestureRecognizer:singleRecognizer];
    
}

-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleSingleTapFrom{
    //关闭键盘
    [tfUsername resignFirstResponder];
    [tfPwd resignFirstResponder];
    
    //适配屏幕
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [loginBgView setFrame:CGRectMake(0, 0, loginBgView.frame.size.width, loginBgView.frame.size.height)];
    [UIView commitAnimations];
}

-(IBAction)loginAction:(id)sender{
    [self checkSubmit];
}

-(IBAction)regAction:(id)sender{
    RegController *controller=[[RegController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)checkSubmit{
    NSString *usernameStr=tfUsername.text;
    NSString *pwdStr=tfPwd.text;
    if (usernameStr==nil || [usernameStr isEqualToString:@""]) {
        [[Toast shareToast] makeText:@"请输入用户名" aDuration:1];
    }else if (pwdStr==nil || [pwdStr isEqualToString:@""]){
        [[Toast shareToast] makeText:@"请输入密码" aDuration:1];
    }else{
        [self handleSingleTapFrom];
        
        //在数据库中搜索用户名和密码；如果没有，返回nil
        UserInfo *userInfo=[[DBUser shareDBUser] loginBySearchUser:usernameStr pwd:pwdStr];
        if (userInfo==nil) {
            [[Toast shareToast] makeText:@"用户名或密码错误" aDuration:1];
        }else{
            //将用户名和密码赋给全局变量LoginUserInfo，用于显示已有用户登陆
            LoginUserInfo=userInfo;
            //将用户名和密码数据归档，以便下次登陆时使用
            [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
            
            [[Toast shareToast] makeText:@"登录成功" aDuration:1];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:tfUsername])
        [tfPwd becomeFirstResponder];
    if ([textField isEqual:tfPwd]){
        [self checkSubmit];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:tfUsername]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:0.2f];
        [loginBgView setFrame:CGRectMake(0, -70, loginBgView.frame.size.width, loginBgView.frame.size.height)];
        [UIView commitAnimations];
    }
    if ([textField isEqual:tfPwd]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:0.2f];
        [loginBgView setFrame:CGRectMake(0, -80, loginBgView.frame.size.width, loginBgView.frame.size.height)];
        [UIView commitAnimations];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
