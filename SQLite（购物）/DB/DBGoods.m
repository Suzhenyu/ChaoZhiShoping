//
//  DBGoods.m
//  SQLite（购物）
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBGoods.h"
#import "MyFilePlist.h"
#import "GoodsInfo.h"

static DBGoods *singleInstance=nil;
@implementation DBGoods

+(DBGoods *)shareDBGoods{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
        return singleInstance;
    }
}

-(GoodsInfo *)selectGoodsById:(int)goodsId{
    GoodsInfo *goods=nil;
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT goods_name,goods_price,goods_logo FROM tb_goods WHERE goods_id=%i",goodsId];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询所有用户时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    while (sqlite3_step(statement) == SQLITE_ROW) {
        char *goods_name=(char *)sqlite3_column_text(statement, 0);
        double goods_price=sqlite3_column_double(statement, 1);
        char *goods_logo=(char *)sqlite3_column_text(statement, 2);
        
        goods=[[GoodsInfo alloc] init];
        goods.goods_id=goodsId;
        goods.goods_name=[NSString stringWithUTF8String:goods_name];
        goods.goods_price=goods_price;
        goods.goods_logo=[NSString stringWithUTF8String:goods_logo];
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return goods;
}

-(NSString *)selectGoodsHTML:(int)goodsId{
    NSString *htmlStr=@"";
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT goods_info FROM tb_goods WHERE goods_id=%i",goodsId];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询商品信息时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    if (sqlite3_step(statement) == SQLITE_ROW) {
        char *goods_info=(char *)sqlite3_column_text(statement, 0);
        htmlStr=[NSString stringWithUTF8String:goods_info];
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return htmlStr;
}

-(NSMutableArray *)selectRecommandList:(int)goodsId type:(int)typeId{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT goods_id,goods_name,goods_price,goods_logo,type_id FROM tb_goods WHERE type_id=%i AND goods_id!=%i",typeId,goodsId];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询所有用户时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int goods_id = sqlite3_column_int(statement, 0);
        char *goods_name=(char *)sqlite3_column_text(statement, 1);
        double goods_price=sqlite3_column_double(statement, 2);
        char *goods_logo=(char *)sqlite3_column_text(statement, 3);
        int type_id = sqlite3_column_int(statement, 4);
        
        GoodsInfo *goods=[[GoodsInfo alloc] init];
        goods.goods_id=goods_id;
        goods.goods_name=[NSString stringWithUTF8String:goods_name];
        goods.goods_price=goods_price;
        goods.goods_logo=[NSString stringWithUTF8String:goods_logo];
        goods.type_id=type_id;
        [mutArray addObject:goods];
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return mutArray;
}

-(NSMutableArray *)selectGoodsList:(NSString *)searchParam type:(int)typeId market:(int)marketId sort:(BOOL)sortType{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=@"";
    NSString *sortStr=sortType?@"DESC":@"ASC";
    if (searchParam!=nil) {
        sqlStr=[NSString stringWithFormat:@"SELECT goods_id,goods_name,goods_price,goods_logo,type_id FROM tb_goods WHERE goods_name LIKE '%%%@%%' ORDER BY goods_price %@",searchParam,sortStr];
    }
    if (typeId>0) {
        sqlStr=[NSString stringWithFormat:@"SELECT goods_id,goods_name,goods_price,goods_logo,type_id FROM tb_goods WHERE type_id=%i ORDER BY goods_price %@",typeId,sortStr];
    }
    if (marketId>0) {
        sqlStr=[NSString stringWithFormat:@"SELECT goods_id,goods_name,goods_price,goods_logo,type_id FROM tb_goods WHERE market_id=%i ORDER BY goods_price %@",marketId,sortStr];
    }
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询所有用户时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int goods_id = sqlite3_column_int(statement, 0);
        char *goods_name=(char *)sqlite3_column_text(statement, 1);
        double goods_price=sqlite3_column_double(statement, 2);
        char *goods_logo=(char *)sqlite3_column_text(statement, 3);
        int type_id = sqlite3_column_int(statement, 4);
        
        GoodsInfo *goods=[[GoodsInfo alloc] init];
        goods.goods_id=goods_id;
        goods.goods_name=[NSString stringWithUTF8String:goods_name];
        goods.goods_price=goods_price;
        goods.goods_logo=[NSString stringWithUTF8String:goods_logo];
        goods.type_id=type_id;
        [mutArray addObject:goods];
        
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
