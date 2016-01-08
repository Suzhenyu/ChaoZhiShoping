//
//  OrderInfo.h
//  SQLite（购物）
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,assign) double order_price;
@property (nonatomic,copy) NSString *order_time;
@property (nonatomic,assign) int order_status;
@property (nonatomic,assign) int address_id;
@property (nonatomic,copy) NSString *order_goods;

@end
