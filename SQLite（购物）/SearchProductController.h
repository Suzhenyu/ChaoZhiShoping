//
//  SearchProductController.h
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchProductController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UITextField *_tfSearch;
    IBOutlet UIView *_viewFooter;
}
@end
