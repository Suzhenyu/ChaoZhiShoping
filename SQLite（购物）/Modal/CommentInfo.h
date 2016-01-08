//
//  CommentInfo.h
//  SQLite（购物）
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (nonatomic,assign) int comment_id;
@property (nonatomic,copy) NSString *user_head;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *comment_time;
@property (nonatomic,copy) NSString *comment_content;
@property (nonatomic,assign) int goods_id;

//我的评论列表
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_logo;
@property (nonatomic,assign) double goods_price;

@end
