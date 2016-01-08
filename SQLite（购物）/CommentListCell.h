//
//  NoticeCell.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListCell :  UITableViewCell {
	
}
@property (nonatomic,weak) IBOutlet UIImageView *imgHead;
@property (nonatomic,weak) IBOutlet UILabel *lbNick;
@property (nonatomic,weak) IBOutlet UILabel *lbPostDate;
@property (nonatomic,weak) IBOutlet UILabel *lbContents;
@end
