//
//  DBOrder.m
//  SQLite（购物）
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBOrder.h"
#import "MyFilePlist.h"
#import "OrderInfo.h"

static DBOrder *singleInstance=nil;
@implementation DBOrder

+(DBOrder *)shareDBOrder{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[DBOrder alloc] init];
        }
    }
    return singleInstance;
}

-(BOOL)deleteById:(NSString *)order_id{
    if (![self openSQLite]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"DELETE FROM tb_order WHERE order_id='%@'",order_id];
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_order删除数据失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(BOOL)updateStatus:(int)status userId:(NSString *)user_id orderId:(NSString *)order_id{
    if (![self openSQLite]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"UPDATE tb_order SET order_status=%i"
                      " WHERE user_id='%@' AND order_id='%@'",status,user_id,order_id];
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_order更新状态失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(BOOL)updateGoodsCommentStatus:(NSString *)order_goods orderId:(NSString *)order_id{
    if (![self openSQLite]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"UPDATE tb_order SET order_goods='%@'"
                      " WHERE order_id='%@'",order_goods,order_id];
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_order更新评论状态失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(NSMutableArray *)selectListByUserId:(NSString *)user_id AndStatus:(int)order_status{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT order_id,order_price,order_time,address_id"
                      ",order_goods FROM tb_order WHERE user_id='%@' AND order_status=%i ORDER BY order_time DESC",user_id,order_status];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询订单列表时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    while (sqlite3_step(statement) == SQLITE_ROW) {
        char *order_id=(char *)sqlite3_column_text(statement, 0);
        double order_price=sqlite3_column_double(statement, 1);
        char *order_time=(char *)sqlite3_column_text(statement, 2);
        int address_id = sqlite3_column_int(statement, 3);
        char *order_goods=(char *)sqlite3_column_text(statement, 4);
        
        OrderInfo *orderInfo=[[OrderInfo alloc] init];
        if (order_id) {
            orderInfo.order_id=[NSString stringWithUTF8String:order_id];
        }
        orderInfo.order_price=order_price;
        if (order_time) {
            orderInfo.order_time=[NSString stringWithUTF8String:order_time];
        }
        orderInfo.address_id=address_id;
        if (order_goods) {
            orderInfo.order_goods=[NSString stringWithUTF8String:order_goods];
        }
        orderInfo.order_status=order_status;
        [mutArray addObject:orderInfo];
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return mutArray;
}

-(BOOL)insertData:(OrderInfo *)orderInfo userId:(NSString *)user_id{
    if (![self openSQLite]) {
        return NO;
    }
    
    //用于接收执行sql语句错误的信息
    char *error;
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_order"
                      "(order_id,order_price,order_time,order_status,address_id,order_goods,user_id)"
                      "VALUES('%@',%.2f,'%@',%i,%i,'%@','%@')",orderInfo.order_id,orderInfo.order_price,orderInfo.order_time,
                      orderInfo.order_status,orderInfo.address_id,orderInfo.order_goods,user_id];
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"给tb_order添加数据失败");
        NSLog(@"错误信息：%s",error);
        return NO;
    }
    
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
