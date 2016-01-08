//
//  DBMarket.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBMarket.h"
#import "MyFilePlist.h"
#import "MarketInfo.h"
#import "GoodsInfo.h"

static DBMarket *singleInstance=nil;
@implementation DBMarket

+(DBMarket *)shareDBMarket{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(NSMutableArray *)selectAllMarket{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=@"SELECT * FROM tb_market";
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询历史记录时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int market_id = sqlite3_column_int(statement, 0);
        char *market_value=(char *)sqlite3_column_text(statement, 1);
        
        MarketInfo *marketInfo=[[MarketInfo alloc] init];
        marketInfo.market_id = market_id;
        marketInfo.market_value=[NSString stringWithUTF8String:market_value];
        //为推荐分类添加商品
        sqlite3_stmt *stmtGoods;
        NSString *sqlGoodsStr=[NSString stringWithFormat:@"SELECT goods_id,goods_name,goods_price,goods_logo,type_id FROM tb_goods WHERE market_id=%i",marketInfo.market_id];
        sqlite3_prepare_v2(_database, [sqlGoodsStr UTF8String], -1, &stmtGoods, nil);
        while (sqlite3_step(stmtGoods)==SQLITE_ROW) {
            int goods_id = sqlite3_column_int(stmtGoods, 0);
            char *goods_name=(char *)sqlite3_column_text(stmtGoods, 1);
            double goods_price=sqlite3_column_double(stmtGoods, 2);
            char *goods_logo=(char *)sqlite3_column_text(stmtGoods, 3);
            int type_id = sqlite3_column_int(stmtGoods, 4);
            
            GoodsInfo *goods=[[GoodsInfo alloc] init];
            goods.goods_id=goods_id;
            goods.goods_name=[NSString stringWithUTF8String:goods_name];
            goods.goods_price=goods_price;
            goods.goods_logo=[NSString stringWithUTF8String:goods_logo];
            goods.type_id=type_id;
            [marketInfo.goodsArray addObject:goods];
        }
        
        [mutArray addObject:marketInfo];
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return mutArray;
}

-(BOOL)openSQLite{
    NSString *filePath=[MyFilePlist documentFilePathStr:@"CZG.sqlite"];
    /*
     打开或创建数据库
     如果result的值是SQLITE_OK，则表明我们操作成功
     注意上述语句中数据库文件的地址字符串前面没有@字符
     因为它是一个C字符串。将NSString字符串转成C字符串的方法是
     [filePath UTF8String];
     &叫取地址符  **ppDb代表ppDb需要的是一个指针地址
     */
    int result=sqlite3_open([filePath UTF8String], &_database);
    if (result!=SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    return YES;
}

@end
