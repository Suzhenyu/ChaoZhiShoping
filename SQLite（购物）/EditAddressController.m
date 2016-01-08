//
//  EditAddressController.m
//  SQLite（购物）
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "EditAddressController.h"
#import "HomeCell.h"
#import "AddressInfo.h"
#import "Toast.h"
#import "DBAddress.h"
#import "UserInfo.h"

extern UserInfo *LoginUserInfo;
@interface EditAddressController ()
{
    UIButton *_blackBgBtn;
    
    NSDictionary *_areaDic;//所有地区字典
    NSMutableArray *_provinceArray;//省份列表
    NSDictionary *_cityDic;//城市字典
    NSMutableArray *_cityArray;//城市列表
    NSArray *_districtArray;//地区列表
    
    NSString *_selectProvince;//选择的省份
    NSString *_selectCity;//选择的城市
    NSString *_selectDistrict;//选择的地区
}
@end

@implementation EditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_fromAddress==nil) {
        self.title=@"新增收货地址";
    }else{
        self.title=@"编辑收货地址";
        _tfName.text=_fromAddress.name;
        _tfPhone.text=_fromAddress.phone;
        _lbArea.text=[NSString stringWithFormat:@"%@%@%@",_fromAddress.province,_fromAddress.city,_fromAddress.district];
        _tfStreet.text=_fromAddress.street;
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(7, 7, 28, 20)];
    [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    _blackBgBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_blackBgBtn setFrame:self.view.bounds];
    [_blackBgBtn setBackgroundColor:[UIColor blackColor]];
    _blackBgBtn.alpha=0.0f;
    [_blackBgBtn addTarget:self action:@selector(areaDissmissClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_blackBgBtn];
    _areaView.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+_areaView.frame.size.height/2);
    [self.view addSubview:_areaView];
    
    
    //取出area.plist文件路径
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    //将字典的key进行冒泡排序
    NSArray *sortedArray = [[_areaDic allKeys] sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {//例如10>1，则将10往下降
            return NSOrderedDescending;//下降
        }else if ([obj1 integerValue] < [obj2 integerValue]) {//例如1<5，则将1往上升
            return NSOrderedAscending;//上升
        }else{
            return NSOrderedSame;//一样
        }
    }];
    //加载省数组
    int editProvinceIndex=0;
    _provinceArray=[NSMutableArray array];
    for (int i=0; i<sortedArray.count; i++) {
        NSDictionary *dic=[_areaDic objectForKey:[sortedArray objectAtIndex:i]];
        if ([_fromAddress.province isEqualToString:[[dic allKeys] objectAtIndex:0]]) {
            NSLog(@"当前省份：%@",[[dic allKeys] objectAtIndex:0]);
            editProvinceIndex=i;
        }
        [_provinceArray addObject:[[dic allKeys] objectAtIndex:0]];
    }
    _selectProvince=[_provinceArray objectAtIndex:editProvinceIndex];
    
    /*
     加载城市数组、区数组
     */
    //取出市
    _cityArray=[NSMutableArray array];
    NSDictionary *tempDic=[_areaDic objectForKey:[NSString stringWithFormat:@"%i",editProvinceIndex]];
    _cityDic=[tempDic objectForKey:_selectProvince];
    NSArray *cityKeyArray = [[_cityDic allKeys] sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;//下降
        }else if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;//上升
        }else{
            return NSOrderedSame;//一样
        }
    }];
    int editCityIndex=0;
    for (int i=0; i<cityKeyArray.count; i++) {
        NSDictionary *dic=[_cityDic objectForKey:[cityKeyArray objectAtIndex:i]];
        if ([_fromAddress.city isEqualToString:[[dic allKeys] objectAtIndex:0]]) {
            NSLog(@"当前城市：%@",[[dic allKeys] objectAtIndex:0]);
            editCityIndex=i;
        }
        [_cityArray addObject:[[dic allKeys] objectAtIndex:0]];
    }
    _selectCity=[_cityArray objectAtIndex:editCityIndex];
    //取出区
    NSDictionary *dic=[_cityDic objectForKey:[cityKeyArray objectAtIndex:editCityIndex]];
    _districtArray=[dic objectForKey:[_cityArray objectAtIndex:editCityIndex]];
    _selectDistrict=_fromAddress.district==nil?[_districtArray objectAtIndex:0]:_fromAddress.district;
    NSLog(@"当前区：%@",_selectDistrict);
    if (_fromAddress!=nil) {
        //滚动省份到对应行
        [_pickerView selectRow:editProvinceIndex inComponent:0 animated:YES];
        //滚动市到对应行
        [_pickerView selectRow:editCityIndex inComponent:1 animated:YES];
        //滚动区到对应行
        for (int i=0; i<_districtArray.count; i++) {
            if ([_selectDistrict isEqualToString:[_districtArray objectAtIndex:i]]) {
                [_pickerView selectRow:i inComponent:2 animated:YES];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [_tfName becomeFirstResponder];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadCityArray:(int)index{
    _selectProvince=[_provinceArray objectAtIndex:index];
    //取出市
    _cityArray=[NSMutableArray array];
    NSDictionary *tempDic=[_areaDic objectForKey:[NSString stringWithFormat:@"%i",index]];
    _cityDic=[tempDic objectForKey:_selectProvince];
    NSArray *sortedArray = [[_cityDic allKeys] sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;//下降
        }else if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;//上升
        }else{
            return NSOrderedSame;//一样
        }
    }];
    for (int i=0; i<sortedArray.count; i++) {
        NSDictionary *dic=[_cityDic objectForKey:[sortedArray objectAtIndex:i]];
        [_cityArray addObject:[[dic allKeys] objectAtIndex:0]];
    }
    _selectCity=[_cityArray objectAtIndex:0];
    //取出区
    NSDictionary *dic=[_cityDic objectForKey:[sortedArray objectAtIndex:0]];
    _districtArray=[dic objectForKey:[_cityArray objectAtIndex:0]];
    _selectDistrict=[_districtArray objectAtIndex:0];
}

-(IBAction)areaDissmissAction:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];//设置动画相对速度为匀速
    _blackBgBtn.alpha=0.0f;
    _areaView.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+_areaView.frame.size.height/2);
    [UIView commitAnimations];
}
-(void)areaDissmissClick{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];//设置动画相对速度为匀速
    _blackBgBtn.alpha=0.0f;
    _areaView.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+_areaView.frame.size.height/2);
    [UIView commitAnimations];
}
-(IBAction)areaAction:(id)sender{
    [_tfName resignFirstResponder];
    [_tfPhone resignFirstResponder];
    [_tfStreet resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];//设置动画相对速度为匀速
    _blackBgBtn.alpha=0.6f;
    _areaView.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-_areaView.frame.size.height/2);
    [UIView commitAnimations];
}
-(IBAction)areaDoneAction:(id)sender{
    _lbArea.text=[NSString stringWithFormat:@"%@%@%@",_selectProvince,_selectCity,_selectDistrict];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];//设置动画相对速度为匀速
    _blackBgBtn.alpha=0.0f;
    _areaView.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height+_areaView.frame.size.height/2);
    [UIView commitAnimations];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //如果是第1列，则返回_cityArray的元素个数
    //否则返回_dictionary中对应key的NSArray的元素个数
    if (component==0) {
        return _provinceArray.count;
    }else if (component==1){
        return _cityArray.count;
    }else{
        return _districtArray.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //如果是第1列，则返回_cityArray的对应索引的元素
    //否则返回_dictionary中对应key的NSArray的元素
    if (component==0) {
        return [_provinceArray objectAtIndex:row];
    }else if (component==1){
        return [_cityArray objectAtIndex:row];
    }else{
        return [_districtArray objectAtIndex:row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {//选择的是省，则刷新市
        //加载市
        [self loadCityArray:(int)row];
        //刷新市
        [_pickerView reloadComponent:1];
        //刷新区
        [_pickerView reloadComponent:2];
        //将城市滚动到第1行
        [_pickerView selectRow:0 inComponent:1 animated:YES];
        //将区滚动到第1行
        [_pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (component==1) {//选择的是市，则刷新区
        _selectCity=[_cityArray objectAtIndex:row];
        //取出区
        NSDictionary *dic=[_cityDic objectForKey:[NSString stringWithFormat:@"%li",row]];
        _districtArray=[dic objectForKey:_selectCity];
        //刷新区
        [_pickerView reloadComponent:2];
        //将区滚动到第1行
        [_pickerView selectRow:0 inComponent:2 animated:YES];
        _selectDistrict=[_districtArray objectAtIndex:0];
    }
    if (component==2) {//选择区
        _selectDistrict=[_districtArray objectAtIndex:row];
    }
    
    NSLog(@"%@%@%@",_selectProvince,_selectCity,_selectDistrict);
    _lbArea.text=[NSString stringWithFormat:@"%@%@%@",_selectProvince,_selectCity,_selectDistrict];
    
}

-(IBAction)saveAction:(id)sender{
    NSString *nameStr=_tfName.text;
    NSString *phoneStr=_tfPhone.text;
    NSString *areaStr=_lbArea.text;
    NSString *streetStr=_tfStreet.text;
    
    if ([nameStr isEqualToString:@""]) {
        [[Toast shareToast] makeText:@"请输入收货人" aDuration:1];
    }else if ([phoneStr isEqualToString:@""]){
        [[Toast shareToast] makeText:@"请输入手机" aDuration:1];
    }else if ([areaStr isEqualToString:@""]){
        [[Toast shareToast] makeText:@"请选择所在地区" aDuration:1];
    }else if ([streetStr isEqualToString:@""]){
        [[Toast shareToast] makeText:@"请输入详细地址" aDuration:1];
    }else{
        if (_fromAddress==nil) {
            AddressInfo *addressInfo=[[AddressInfo alloc] init];
            addressInfo.name=nameStr;
            addressInfo.phone=phoneStr;
            addressInfo.province=_selectProvince;
            addressInfo.city=_selectCity;
            addressInfo.district=_selectDistrict;
            addressInfo.street=streetStr;
            addressInfo.isdefault=0;
            [[DBAddress shareDBAddress] insertAddressData:addressInfo userId:LoginUserInfo.user_id];
            
            [[Toast shareToast] makeText:@"添加成功" aDuration:1];
        }else{
            
            _fromAddress.name=nameStr;
            _fromAddress.phone=phoneStr;
            _fromAddress.province=_selectProvince;
            _fromAddress.city=_selectCity;
            _fromAddress.district=_selectDistrict;
            _fromAddress.street=streetStr;
            [[DBAddress shareDBAddress] updateAddressData:_fromAddress];
            
            [[Toast shareToast] makeText:@"修改成功" aDuration:1];
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAddressList" object:nil];
        [_delegate editAddressDone];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    return 292;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _viewHeader;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [_tfName resignFirstResponder];
    [_tfPhone resignFirstResponder];
    [_tfStreet resignFirstResponder];
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
