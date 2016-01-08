//
//  NoticeCell.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell :  UITableViewCell {
	
}
@property (nonatomic,retain) IBOutlet UILabel *lbGoodsTitle;
@property (nonatomic,retain) IBOutlet UIButton *btnGoodsSelected;
@property (nonatomic,retain) IBOutlet UIImageView *imgGoodsSelected;
@property (nonatomic,retain) IBOutlet UIImageView *imgGoodsLogo;
@property (nonatomic,retain) IBOutlet UILabel *lbGoodsNum;
@property (nonatomic,retain) IBOutlet UIButton *btnGoodsNum;
@property (nonatomic,retain) IBOutlet UIButton *btnGoodsJian1;
@property (nonatomic,retain) IBOutlet UIButton *btnGoodsJia1;
@property (nonatomic,retain) IBOutlet UIButton *btnGoodsJian2;
@property (nonatomic,retain) IBOutlet UIButton *btnGoodsJia2;
@property (nonatomic,retain) IBOutlet UILabel *lbGoodsPrice;
@end
