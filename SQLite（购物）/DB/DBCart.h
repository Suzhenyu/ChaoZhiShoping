//
//  DBCart.h
//  SQLite（购物）
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBCart : NSObject
{
    sqlite3 *_database;
}
+(DBCart *)shareDBCart;
-(BOOL)deleteAll;
-(BOOL)deleteByGoodsId:(int)goods_id;
-(BOOL)updateNumByGoodsId:(int)goods_id count:(int)num;
-(NSMutableArray *)selectCartGoodsList;
-(int)selectCartCount;
-(BOOL)insertData:(int)goods_id;
@end
