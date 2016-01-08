//
//  DBComment.m
//  SQLite（购物）
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBComment.h"
#import "MyFilePlist.h"
#import "CommentInfo.h"

static DBComment *singleInstance=nil;
@implementation DBComment

+(DBComment *)shareDBComment{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}

-(NSMutableArray *)selectListByUserId:(NSString *)user_id{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT comment_time,comment_content,goods_logo,goods_name,goods_price FROM tb_comment INNER JOIN tb_goods ON tb_comment.goods_id=tb_goods.goods_id WHERE user_id='%@' ORDER BY comment_time DESC",user_id];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询商品评论时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    while (sqlite3_step(statement) == SQLITE_ROW) {
        char *comment_time=(char *)sqlite3_column_text(statement, 0);
        char *comment_content=(char *)sqlite3_column_text(statement, 1);
        char *goods_logo=(char *)sqlite3_column_text(statement, 2);
        char *goods_name=(char *)sqlite3_column_text(statement, 3);
        double goods_price=sqlite3_column_double(statement, 4);
        
        CommentInfo *comment=[[CommentInfo alloc] init];
        if (comment_time) {
            comment.comment_time=[NSString stringWithUTF8String:comment_time];
        }
        if (comment_content) {
            comment.comment_content=[NSString stringWithUTF8String:comment_content];
        }
        if (goods_logo) {
            comment.goods_logo=[NSString stringWithUTF8String:goods_logo];
        }
        if (goods_name) {
            comment.goods_name=[NSString stringWithUTF8String:goods_name];
        }
        comment.goods_price=goods_price;
        [mutArray addObject:comment];
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return mutArray;
}

-(BOOL)insertCommendData:(CommentInfo *)commentInfo userId:(NSString *)user_id{
    if (![self openSQLite]) {
        return NO;
    }
    //user_name,user_pwd,user_head,user_balance
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_comment(user_id,comment_time,comment_content,goods_id) VALUES ('%@','%@','%@',%i)",user_id,commentInfo.comment_time,commentInfo.comment_content,commentInfo.goods_id];
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_address添加数据失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(int)selectCountByGoodsId:(int)goods_id{
    if (![self openSQLite]) {
        return NO;
    }
    
    int num=0;
    sqlite3_stmt *statement;
    NSString *existsSqlStr=[NSString stringWithFormat:@"SELECT count(*) FROM tb_comment WHERE goods_id=%i",goods_id];
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

-(NSMutableArray *)selectListByGoodsID:(int)goods_id{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT comment_id,user_head,user_name,comment_time,comment_content FROM tb_comment INNER JOIN tb_user ON tb_comment.user_id=tb_user.user_id WHERE goods_id=%i ORDER BY comment_time DESC",goods_id];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询商品评论时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int comment_id = sqlite3_column_int(statement, 0);
        char *user_head=(char *)sqlite3_column_text(statement, 1);
        char *user_name=(char *)sqlite3_column_text(statement, 2);
        char *comment_time=(char *)sqlite3_column_text(statement, 3);
        char *comment_content=(char *)sqlite3_column_text(statement, 4);
        
        CommentInfo *comment=[[CommentInfo alloc] init];
        if (comment_id) {
            comment.comment_id=comment_id;
        }
        if (user_head) {
            comment.user_head=[NSString stringWithUTF8String:user_head];
        }
        if (user_name) {
            comment.user_name=[NSString stringWithUTF8String:user_name];
        }
        if (comment_time) {
            comment.comment_time=[NSString stringWithUTF8String:comment_time];
        }
        if (comment_content) {
            comment.comment_content=[NSString stringWithUTF8String:comment_content];
        }
        [mutArray addObject:comment];
        
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
