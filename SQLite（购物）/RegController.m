//
//  ViewController.m
//  Talktalk
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "RegController.h"
#import "Toast.h"
#import "LoadingRequestView.h"
#import "UserInfo.h"
#import "DBUser.h"
#import "MyFilePlist.h"

extern UserInfo *LoginUserInfo;
@implementation RegController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"注册";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    _imgLoginIcon.layer.cornerRadius=5.0f;
    _imgLoginIcon.layer.masksToBounds=YES;
    
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
	[loginBgView addGestureRecognizer:singleRecognizer];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleSingleTapFrom{
    [tfUsername resignFirstResponder];
    [tfPwd1 resignFirstResponder];
    [tfPwd2 resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [loginBgView setFrame:CGRectMake(0, 0, loginBgView.frame.size.width, loginBgView.frame.size.height)];
    [UIView commitAnimations];
}

-(IBAction)nextAction:(id)sender{
    [self checkSubmit];
}

-(void)checkSubmit{
    NSString *usernameStr=tfUsername.text;
    NSString *pwdStr1=tfPwd1.text;
    NSString *pwdStr2=tfPwd2.text;
    if (usernameStr==nil || [usernameStr isEqualToString:@""]) {
        [[Toast shareToast] makeText:@"请输入用户名" aDuration:1];
    }else if (pwdStr1==nil || [pwdStr1 isEqualToString:@""]){
        [[Toast shareToast] makeText:@"请输入密码" aDuration:1];
    }else if (pwdStr2==nil || [pwdStr2 isEqualToString:@""]){
        [[Toast shareToast] makeText:@"请输入确认密码" aDuration:1];
    }else if (![pwdStr1 isEqualToString:pwdStr2]){
        [[Toast shareToast] makeText:@"两次密码输入不一致" aDuration:1];
    }else{
        UserInfo *userInfo=[[UserInfo alloc] init];
        //时间戳、年月日时分秒毫秒
        userInfo.user_id=[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        userInfo.user_name=usernameStr;
        userInfo.user_pwd=pwdStr1;
        userInfo.user_head=@"";
        userInfo.user_balance=0.0f;
        if ([[DBUser shareDBUser] insertData:userInfo]) {
            LoginUserInfo=userInfo;
            [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
            
            [[Toast shareToast] makeText:@"注册成功" aDuration:1];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [[Toast shareToast] makeText:@"用户已存在" aDuration:1];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:tfUsername])
        [tfPwd1 becomeFirstResponder];
    if ([textField isEqual:tfPwd1])
        [tfPwd2 becomeFirstResponder];
    if ([textField isEqual:tfPwd2]){
        [self handleSingleTapFrom];
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
        [loginBgView setFrame:CGRectMake(0, -90, loginBgView.frame.size.width, loginBgView.frame.size.height)];
        [UIView commitAnimations];
    }
    if ([textField isEqual:tfPwd1]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:0.2f];
        [loginBgView setFrame:CGRectMake(0, -100, loginBgView.frame.size.width, loginBgView.frame.size.height)];
        [UIView commitAnimations];
    }
    if ([textField isEqual:tfPwd2]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:0.2f];
        [loginBgView setFrame:CGRectMake(0, -120, loginBgView.frame.size.width, loginBgView.frame.size.height)];
        [UIView commitAnimations];
    }
    return YES;
}

-(void)dealloc{
    NSLog(@"注册页面销毁");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
