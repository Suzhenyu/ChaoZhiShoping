//
//  SearchProductController.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "SearchProductController.h"
#import "HelperUtil.h"
#import "SearchCell.h"
#import "DBSearchHistory.h"
#import "Toast.h"

@interface SearchProductController ()
{
    NSArray *_historyArray;
}
@end

@implementation SearchProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    
    _historyArray=[[DBSearchHistory shareDBSearchHistory] selectAllHistory];
}

-(void)viewDidAppear:(BOOL)animated{
    [_tfSearch becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(IBAction)cancalAction:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if ([[DBSearchHistory shareDBSearchHistory] insertData:textField.text]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"forwardSearchToList" object:textField.text];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    return YES;
}

#pragma mark UITableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"历史搜索";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _viewFooter;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _historyArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SearchCell";
    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.lbValue.text=[_historyArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *searchValue=[_historyArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"forwardSearchToList" object:searchValue];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)clearAllAction:(id)sender{
    if ([[DBSearchHistory shareDBSearchHistory] deleteAllHistory]) {
        _historyArray=[[DBSearchHistory shareDBSearchHistory] selectAllHistory];
        [_tableView reloadData];
        [[Toast shareToast] makeText:@"清除历史记录成功" aDuration:1];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [_tfSearch resignFirstResponder];
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
