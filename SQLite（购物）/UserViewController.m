//
//  UserViewController.m
//  SQLite（购物）
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "UserViewController.h"
#import "HelperUtil.h"
#import "UserInfo.h"
#import "MyFilePlist.h"
#import "Toast.h"
#import "DBUser.h"
#import "BalanceController.h"
#import "UpdatePwdController.h"
#import "AddressListController.h"
#import "MyComListController.h"
#import "MyOrderController.h"

extern UserInfo *LoginUserInfo;
@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.title=@"用户中心";
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
    [_tableView reloadData];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1) {
        return 3;
    }else if (section==2) {
        return 2;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 60;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if (indexPath.section==0) {
        //用户头像为空字符串，则给一个默认头像headImg.png
        NSString *headStr=[MyFilePlist documentFilePathStr:[NSString stringWithFormat:@"UserHead/%@",LoginUserInfo.user_head]];
        if ([LoginUserInfo.user_head isEqualToString:@""] || [LoginUserInfo.user_head isEqualToString:@"(null)"]
             || [LoginUserInfo.user_head isEqualToString:@"null"] || LoginUserInfo.user_head==nil) {
            headStr=@"headImg.png";
        }
        cell.imageView.image=[UIImage imageNamed:headStr];
        cell.textLabel.text=LoginUserInfo.user_name;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"账户余额：￥%.2f",LoginUserInfo.user_balance];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"我的订单";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"我的评论";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==2) {
            cell.textLabel.text=@"地址管理";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"修改密码";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"余额充值";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section==3) {
        cell.textLabel.text=@"退出登录";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        actionSheet.tag=10;
        [actionSheet showInView:self.view];
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            MyOrderController *controller=[[MyOrderController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row==1) {
            MyComListController *controller=[[MyComListController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row==2) {
            AddressListController *controller=[[AddressListController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            UpdatePwdController *controller=[[UpdatePwdController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row==1) {
            BalanceController *controller=[[BalanceController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    if (indexPath.section==3) {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"确定退出吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.tag=20;
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==10) {
        if (buttonIndex==0) {
            NSLog(@"拍照");
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagepicker.allowsEditing = YES;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
        if (buttonIndex==1) {
            NSLog(@"从相册选择");
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagepicker.allowsEditing = YES;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
    }
    if (actionSheet.tag==20) {
        if (buttonIndex==0) {
            LoginUserInfo=nil;
            [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
            
            [[Toast shareToast] makeText:@"注销成功" aDuration:1];
            self.tabBarController.selectedIndex=0;//让tabBar选中”首页“
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//    NSData *imgData=UIImageJPEGRepresentation(image, 1);
    NSData *imgData=UIImagePNGRepresentation(image);
    NSString *imgNameStr=[NSString stringWithFormat:@"%.0f.png",[[NSDate date] timeIntervalSince1970]];
    BOOL saveSuccess=[imgData writeToFile:[MyFilePlist documentFilePathStr:[NSString stringWithFormat:@"UserHead/%@",imgNameStr]] atomically:YES];
    if (saveSuccess) {
        LoginUserInfo.user_head=imgNameStr;
        //归档
        [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFilePlist documentFilePathStr:@"LoginUserInfo.archive"]];
        //更新tb_user表
        [[DBUser shareDBUser] updateUserData:LoginUserInfo];
        [_tableView reloadData];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
