//
//  GoodsInfo.h
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfo : NSObject

@property (nonatomic,assign) int goods_id;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,assign) double goods_price;
@property (nonatomic,copy) NSString *goods_logo;
@property (nonatomic,copy) NSString *goods_info;
@property (nonatomic,assign) int type_id;

//购物车中需要
@property (nonatomic,assign) int goods_num;
@property (nonatomic,assign) BOOL goods_selected;

//订单中需要
@property (nonatomic,assign) int isComment;

@end
