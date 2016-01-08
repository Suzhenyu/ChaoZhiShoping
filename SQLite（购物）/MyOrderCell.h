//
//  NoticeCell.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell :  UITableViewCell {
	
}
@property (nonatomic,weak) IBOutlet UILabel *lbOrderNo;
@property (nonatomic,weak) IBOutlet UILabel *lbOrderPrice;
@property (nonatomic,weak) IBOutlet UILabel *lbOrderTime;
@property (nonatomic,weak) IBOutlet UILabel *lbOrderStatus;
@property (nonatomic,weak) IBOutlet UIButton *btnDetail;
@property (nonatomic,weak) IBOutlet UIImageView *imgIsComment;
@end
