//
//  FeedBack.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarketInfo;
@interface ProductListController : UIViewController{
    IBOutlet UITableView *productListTable;
    IBOutlet UIView *headView;
    
    IBOutlet UILabel *_lbTitle;
    IBOutlet UILabel *_lbTotalCount;
    IBOutlet UIImageView *_imgSortIcon;
}
//渠道对象
@property (nonatomic,strong) MarketInfo *fromMarket;
//类型的id
@property (nonatomic,assign) int fromTypeId;
//搜索的参数
@property (nonatomic,copy) NSString *fromSearchParam;

@end
