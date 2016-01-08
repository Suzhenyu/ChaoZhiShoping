//
//  FeedBack.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubOrderController : UIViewController<UIAlertViewDelegate>{
    IBOutlet UITableView *informationTable;
    IBOutlet UIView *tableBottomView;
    
    IBOutlet UIView *headView;
    IBOutlet UILabel *lbName;
    IBOutlet UILabel *lbPhone;
    IBOutlet UILabel *lbAddress;
    IBOutlet UILabel *lbPayPrice2;
    
    IBOutlet UIView *_viewGoodsList;
}
@property (nonatomic,strong) NSArray *fromGoodsList;
@property (nonatomic,assign) double fromTotalPrice;
@end
