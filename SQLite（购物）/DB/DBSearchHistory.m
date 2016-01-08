//
//  DBSearchHistory.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBSearchHistory.h"
#import "MyFilePlist.h"

static DBSearchHistory *singleInstance=nil;
@implementation DBSearchHistory

+(DBSearchHistory *)shareDBSearchHistory{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[DBSearchHistory alloc] init];
        }
    }
    return singleInstance;
}

-(BOOL)deleteAllHistory{
    if (![self openSQLite]) {
        return NO;
    }
    
    NSString *sqlStr=@"DELETE FROM tb_searchHistory";
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_searchHistory清除数据失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(NSMutableArray *)selectAllHistory{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=@"SELECT history_value FROM tb_searchHistory ORDER BY history_id DESC";
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询历史记录时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    while (sqlite3_step(statement) == SQLITE_ROW) {
        char* history_value    = (char*)sqlite3_column_text(statement, 0);
        
        NSString *str = [NSString stringWithUTF8String:history_value];
        [mutArray addObject:str];
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return mutArray;
}

-(BOOL)insertData:(NSString *)searchValue{
    if (![self openSQLite]) {
        return NO;
    }
    
    /*
     如果搜索的内容已存在，则先删除
     */
    char *error;
    NSString *deleteStr=[NSString stringWithFormat:@"DELETE FROM tb_searchHistory WHERE history_value='%@'",searchValue];
    //执行sql语句
    int deleteSuccess=sqlite3_exec(_database, [deleteStr UTF8String], nil, nil, &error);
    if (deleteSuccess!=SQLITE_OK) {
        NSLog(@"tb_searchHistory删除数据失败");
        NSLog(@"错误信息：%s",error);
        return NO;
    }
    
    /*
     添加到历史记录
     */
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_searchHistory (history_value) VALUES"
                      "('%@')",searchValue];
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"给tb_searchHistory添加数据失败");
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
