//
//  DBOrder.h
//  SQLite（购物）
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class OrderInfo;
@interface DBOrder : NSObject
{
    sqlite3 *_database;
}
+(DBOrder *)shareDBOrder;
-(BOOL)deleteById:(NSString *)order_id;
-(BOOL)insertData:(OrderInfo *)orderInfo userId:(NSString *)user_id;
-(NSMutableArray *)selectListByUserId:(NSString *)user_id AndStatus:(int)order_status;
-(BOOL)updateGoodsCommentStatus:(NSString *)order_goods orderId:(NSString *)order_id;
-(BOOL)updateStatus:(int)status userId:(NSString *)user_id orderId:(NSString *)order_id;
@end
