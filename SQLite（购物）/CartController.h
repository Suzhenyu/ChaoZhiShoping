//
//  FeedBack.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartController : UIViewController  {
	IBOutlet UITableView *_cartTable;
    IBOutlet UIButton *_btnBuy;
    IBOutlet UILabel *_lbTotalPrice;
}
@end
