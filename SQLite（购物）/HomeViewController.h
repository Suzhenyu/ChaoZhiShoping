//
//  HomeViewController.h
//  SQLite（购物）
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_viewHeader;
    IBOutlet UIScrollView *_scrollHeader;
}
@end
