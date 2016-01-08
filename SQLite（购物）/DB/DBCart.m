//
//  DBCart.m
//  SQLite（购物）
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBCart.h"
#import "MyFilePlist.h"
#import "GoodsInfo.h"

static DBCart *singleInstance=nil;
@implementation DBCart

+(DBCart *)shareDBCart{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}

-(BOOL)deleteAll{
    if (![self openSQLite]) {
        return NO;
    }
    
    NSString *sqlStr=@"DELETE FROM tb_cart";
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_cart删除数据失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(BOOL)deleteByGoodsId:(int)goods_id{
    if (![self openSQLite]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"DELETE FROM tb_cart WHERE goods_id=%i",goods_id];
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_cart删除数据失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(BOOL)updateNumByGoodsId:(int)goods_id count:(int)num{
    if (![self openSQLite]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"UPDATE tb_cart SET num=%i WHERE goods_id=%i",num,goods_id];
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_user更新数据失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(NSMutableArray *)selectCartGoodsList{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    /*
     SELECT goods_id,goods_name,goods_price,goods_logo,(SELECT num FROM tb_cart WHERE goods_id=tb_goods.goods_id) AS num FROM tb_goods WHERE goods_id IN (SELECT goods_id FROM tb_cart)
     */
    NSString *sqlStr=@"SELECT tb_goods.goods_id,tb_goods.goods_name,tb_goods.goods_price,tb_goods.goods_logo,tb_goods.type_id,num FROM tb_cart LEFT JOIN tb_goods ON tb_cart.goods_id=tb_goods.goods_id";
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询购物车时，statement准备失败");
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
        int goods_num = sqlite3_column_int(statement, 5);
        
        GoodsInfo *goods=[[GoodsInfo alloc] init];
        goods.goods_id=goods_id;
        goods.goods_name=[NSString stringWithUTF8String:goods_name];
        goods.goods_price=goods_price;
        goods.goods_logo=[NSString stringWithUTF8String:goods_logo];
        goods.type_id=type_id;
        goods.goods_num=goods_num;
        [mutArray addObject:goods];
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return mutArray;
}

-(int)selectCartCount{
    if (![self openSQLite]) {
        return NO;
    }
    
    int num=0;
    /*
     检测该商品是否存在，如果存在则修改购物车数量
     */
    sqlite3_stmt *statement;
    NSString *existsSqlStr=@"SELECT count(*) FROM tb_cart";
    int existsSuccess = sqlite3_prepare_v2(_database, [existsSqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (existsSuccess != SQLITE_OK) {
        NSLog(@"查询tb_cart数量时，statement准备失败");
        return NO;
    }
    //只要查到有数据，就代表商品存在
    //存在则修改数量，不存在则添加数据
    if (sqlite3_step(statement) == SQLITE_ROW) {
        num = sqlite3_column_int(statement, 0);
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return num;
}

-(BOOL)insertData:(int)goods_id{
    if (![self openSQLite]) {
        return NO;
    }
    
    /*
     检测该商品是否存在，如果存在则修改购物车数量
     */
    sqlite3_stmt *statement;
    NSString *existsSqlStr=[NSString stringWithFormat:@"SELECT num FROM tb_cart WHERE goods_id=%i",goods_id];
    int existsSuccess = sqlite3_prepare_v2(_database, [existsSqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (existsSuccess != SQLITE_OK) {
        NSLog(@"tb_cart检测商品是否存在时，statement准备失败");
        return NO;
    }
    //只要查到有数据，就代表商品存在
    //存在则修改数量，不存在则添加数据
    if (sqlite3_step(statement) == SQLITE_ROW) {
        int num = sqlite3_column_int(statement, 0);
        
        /*
         修改购物车数量
         */
        char *error;
        num++;
        NSString *sqlStr=[NSString stringWithFormat:@"UPDATE tb_cart SET num=%i WHERE goods_id=%i",num,goods_id];
        //执行sql语句
        int success=sqlite3_exec(_database, [sqlStr UTF8String], nil, nil, &error);
        if (success!=SQLITE_OK) {
            NSLog(@"给tb_cart修改数量失败");
            NSLog(@"错误信息：%s",error);
            return NO;
        }
        
    }else{
        /*
         添加到购物车
         */
        char *error;
        NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_cart (goods_id) VALUES"
                          "(%i)",goods_id];
        //执行sql语句
        int success=sqlite3_exec(_database, [sqlStr UTF8String], nil, nil, &error);
        if (success!=SQLITE_OK) {
            NSLog(@"给tb_cart添加数据失败");
            NSLog(@"错误信息：%s",error);
            return NO;
        }
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
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
