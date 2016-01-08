//
//  FeedBack.m
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "AddressListController.h"
#import "AddressListCell.h"
#import "Toast.h"
#import "MyFilePlist.h"
#import "DBAddress.h"
#import "UserInfo.h"
#import "AddressInfo.h"
#import "EditAddressController.h"

@interface AddressListController ()<EditAddressControllerDelegate>
{
    NSMutableArray *_addressArray;
}
@end

extern UserInfo *LoginUserInfo;
@implementation AddressListController
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"地址管理";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIButton *btnAdd=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setFrame:CGRectMake(0, 0, 30, 30)];
    [btnAdd setBackgroundImage:[UIImage imageNamed:@"add_normal.png"] forState:UIControlStateNormal];
    btnAdd.showsTouchWhenHighlighted=YES;
    [btnAdd addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem=rightItem;;
    
    _addressArray=[[DBAddress shareDBAddress] selectListByUserId:LoginUserInfo.user_id];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddressList:) name:@"refreshAddressList" object:nil];
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark EditAddressControllerDelegate
-(void)editAddressDone{
    _addressArray=[[DBAddress shareDBAddress] selectListByUserId:LoginUserInfo.user_id];
    [addressListTable reloadData];
}
//-(void)refreshAddressList:(NSNotification *)notif{
//    _addressArray=[[DBAddress shareDBAddress] selectListByUserId:LoginUserInfo.user_id];
//    [addressListTable reloadData];
//}

-(void)addClick{
    EditAddressController *controller=[[EditAddressController alloc] initWithNibName:@"EditAddressController" bundle:[NSBundle mainBundle]];
    controller.delegate=self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"AddressListCell";
    
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddressListCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    AddressInfo *addressInfo=[_addressArray objectAtIndex:indexPath.row];
    cell.lbNick.text=addressInfo.name;
    cell.lbPhone.text=addressInfo.phone;
    cell.lbAddress.text=[NSString stringWithFormat:@"%@%@%@%@",addressInfo.province,addressInfo.city,addressInfo.district,addressInfo.street];
    if (addressInfo.isdefault==1) {
        [cell.imgViewSelected setImage:[UIImage imageNamed:@"address_list_selected.png"]];
    }else{
        [cell.imgViewSelected setImage:[UIImage imageNamed:@"information_box2.png"]];
    }
    
    [cell.btnEdit addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnEdit.tag=indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag=indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    AddressInfo *selectAddress=[_addressArray objectAtIndex:indexPath.row];
    selectAddress.isdefault=1;
    [[DBAddress shareDBAddress] updateAddressData:selectAddress];
    
    for (int i=0; i<_addressArray.count; i++) {
        AddressInfo *info=[_addressArray objectAtIndex:i];
        if (info.address_id!=selectAddress.address_id) {
            info.isdefault=0;
            [[DBAddress shareDBAddress] updateAddressData:info];
        }
    }
    
    [addressListTable reloadData];
}

-(void)editClick:(UIButton*)sender{
    int index=(int)sender.tag;
    AddressInfo *addressInfo=[_addressArray objectAtIndex:index];
    
    EditAddressController *controller=[[EditAddressController alloc] init];
    controller.fromAddress=addressInfo;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)deleteClick:(UIButton*)sender{
    int index=(int)sender.tag;
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"确认删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag=index;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        AddressInfo *addressInfo=[_addressArray objectAtIndex:alertView.tag];
        if ([[DBAddress shareDBAddress] deleteById:addressInfo.address_id]) {
            _addressArray=[[DBAddress shareDBAddress] selectListByUserId:LoginUserInfo.user_id];
            [addressListTable reloadData];
            [[Toast shareToast] makeText:@"删除成功" aDuration:1];
        }
    }
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
