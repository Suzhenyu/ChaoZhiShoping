//
//  NoticeCell.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyComCell :  UITableViewCell {
	
}
@property (nonatomic,weak) IBOutlet UIImageView *imgGoodsLogo;
@property (nonatomic,weak) IBOutlet UILabel *lbGoodsName;
@property (nonatomic,weak) IBOutlet UILabel *lbGoodsPrice;
@property (nonatomic,weak) IBOutlet UILabel *lbPostDate;
@property (nonatomic,weak) IBOutlet UILabel *lbContents;
@end
