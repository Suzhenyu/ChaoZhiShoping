//
//  NoticeCell.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailGoodsCell :  UITableViewCell {
	
}
@property (nonatomic,weak) IBOutlet UILabel *lbTitle;
@property (nonatomic,weak) IBOutlet UILabel *lbPrice;
@property (nonatomic,weak) IBOutlet UIImageView *imgLogo;
@property (nonatomic,weak) IBOutlet UILabel *lbNum;
@property (nonatomic,weak) IBOutlet UIButton *btnComment;
@end
