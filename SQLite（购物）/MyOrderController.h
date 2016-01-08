//
//  MyOrderController.h
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderController : UIViewController<UIAlertViewDelegate>
{
    IBOutlet UITableView *_orderTable;
    IBOutlet UIButton *_btnTab1;
    IBOutlet UIButton *_btnTab2;
    IBOutlet UIButton *_btnTab3;
}
@end
