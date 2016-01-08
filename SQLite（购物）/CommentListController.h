//
//  FeedBack.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListController : UIViewController{
    IBOutlet UITableView *commentListTable;
}
@property (nonatomic,assign) int fromGoodsId;
@end
