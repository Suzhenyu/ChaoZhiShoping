//
//  FeedBack.h
//  GuanZ
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsInfo;
@interface InformationController : UIViewController{
    IBOutlet UITableView *informationTable;
    IBOutlet UIView *tableBottomView;
    IBOutlet UIImageView *imgGoodsAnima;
    IBOutlet UIView *headView;
    
    IBOutlet UILabel *_lbPrice;
    IBOutlet UILabel *_lbImgsPage;
    IBOutlet UIScrollView *scrollImgs;
    IBOutlet UILabel *_lbGoodsName;
    IBOutlet UILabel *lbCommentCounts;
    
    IBOutlet UIView *viewRecommend;
    IBOutlet UIView *viewGoodsInfo;
    IBOutlet UIView *viewCommentsCount;
}
@property (nonatomic,strong) GoodsInfo *fromGoods;
@end
