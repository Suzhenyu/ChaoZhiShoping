//
//  NoticeCell.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell :  UITableViewCell {
	
}
@property (nonatomic,weak) IBOutlet UIImageView *imgLogo1;
@property (nonatomic,weak) IBOutlet UIImageView *imgLogo2;

@property (nonatomic,weak) IBOutlet UILabel *lbTitle1;
@property (nonatomic,weak) IBOutlet UILabel *lbTitle2;
@property (nonatomic,weak) IBOutlet UILabel *lbPrice1;
@property (nonatomic,weak) IBOutlet UILabel *lbPrice2;

@property (nonatomic,weak) IBOutlet UIButton *btn1;
@property (nonatomic,weak) IBOutlet UIButton *btn2;

@property (nonatomic,weak) IBOutlet UIImageView *imgBg1;
@property (nonatomic,weak) IBOutlet UIImageView *imgBg2;
@end
