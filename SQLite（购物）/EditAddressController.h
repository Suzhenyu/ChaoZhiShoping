//
//  EditAddressController.h
//  SQLite（购物）
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressInfo;

@protocol EditAddressControllerDelegate <NSObject>

-(void)editAddressDone;

@end

@interface EditAddressController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIView *_viewHeader;
    IBOutlet UITextField *_tfName;
    IBOutlet UITextField *_tfPhone;
    IBOutlet UILabel *_lbArea;
    IBOutlet UITextField *_tfStreet;
    
    IBOutlet UIView *_areaView;
    IBOutlet UIPickerView *_pickerView;
}
@property (nonatomic,strong) AddressInfo *fromAddress;
@property (nonatomic,assign) id <EditAddressControllerDelegate> delegate;
@end
