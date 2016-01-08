//
//  FeedBack.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderInfo;
@interface OrderDetailController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *informationTable;
    IBOutlet UIView *headView;
    
    IBOutlet UIButton *_btnDelete;
    IBOutlet UIButton *_btnConfirm;
    
    IBOutlet UILabel *lbOrderNo;
    IBOutlet UILabel *lbOrderStatus;
    
    //商品列表
    IBOutlet UILabel *_lbTotalPrice;
    
    //收货人信息
    IBOutlet UIView *receiveAddressView;
    IBOutlet UILabel *lbReceiveName;
    IBOutlet UILabel *lbReceiveAddress;
    IBOutlet UILabel *lbReceivePhone;
}
@property (nonatomic,strong) OrderInfo *fromOrderInfo;
@end
