//
//  NoticeCell.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListCell :  UITableViewCell {
	
}
@property (nonatomic,weak) IBOutlet UILabel *lbNick;
@property (nonatomic,weak) IBOutlet UILabel *lbPhone;
@property (nonatomic,weak) IBOutlet UILabel *lbAddress;
@property (nonatomic,weak) IBOutlet UIButton *btnEdit;
@property (nonatomic,weak) IBOutlet UIButton *btnDelete;
@property (nonatomic,weak) IBOutlet UIImageView *imgViewSelected;
@end
