//
//  DBUser.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBUser.h"
#import "UserInfo.h"
#import "MyFilePlist.h"

static DBUser *singleInstance=nil;
@implementation DBUser

+(DBUser *)shareDBUser{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[DBUser alloc] init];
        }
    }
    return singleInstance;
}

-(BOOL)updateUserData:(UserInfo *)userInfo{
    if (![self openSQLite]) {
        return nil;
    }
    //user_name,user_pwd,user_head,user_balance
    NSString *sqlStr=[NSString stringWithFormat:@"UPDATE tb_user SET user_name='%@',"
                      "user_pwd='%@',user_head='%@',user_balance=%.2f WHERE user_id='%@'",userInfo.user_name,userInfo.user_pwd,userInfo.user_head,userInfo.user_balance,userInfo.user_id];
    
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

-(UserInfo *)loginBySearchUser:(NSString *)loginName pwd:(NSString *)loginPwd{
    UserInfo *userInfo=nil;
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_user WHERE user_name='%@' AND user_pwd='%@'",loginName,loginPwd];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询所有用户时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    if (sqlite3_step(statement) == SQLITE_ROW) {
        char* user_id    = (char*)sqlite3_column_text(statement, 0);
        char* user_name    = (char*)sqlite3_column_text(statement, 1);
        char* user_pwd    = (char*)sqlite3_column_text(statement, 2);
        char* user_head    = (char*)sqlite3_column_text(statement, 3);
        double user_balance    = sqlite3_column_double(statement, 4);
        
        userInfo=[[UserInfo alloc] init];
        if(userInfo)
            userInfo.user_id = [NSString stringWithUTF8String:user_id];
        if(user_name)
            userInfo.user_name = [NSString stringWithUTF8String:user_name];
        if(user_pwd)
            userInfo.user_pwd = [NSString stringWithUTF8String:user_pwd];
        if(user_head)
            userInfo.user_head = [NSString stringWithUTF8String:user_head];
        if(user_balance)
            userInfo.user_balance = user_balance;
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return userInfo;
}

-(BOOL)insertData:(UserInfo *)userInfo{
    if (![self openSQLite]) {
        return NO;
    }
    
    /*
     检测用户名是否存在
     */
    sqlite3_stmt *statement;
    NSString *existsSqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_user WHERE user_name='%@'",userInfo.user_name];
    int existsSuccess = sqlite3_prepare_v2(_database, [existsSqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (existsSuccess != SQLITE_OK) {
        NSLog(@"检测用户是否存在时，statement准备失败");
        return NO;
    }
    //只要查到有数据，就代表用户存在
    if (sqlite3_step(statement) == SQLITE_ROW) {
        return NO;
    }
    
    /*
     注册用户
     */
    //用于接收执行sql语句错误的信息
    char *error;
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_user"
                      "(user_id,user_name,user_pwd,user_head,user_balance) VALUES"
                      "('%@','%@','%@','%@',%.2f)",userInfo.user_id,userInfo.user_name,userInfo.user_pwd,
                      userInfo.user_head,userInfo.user_balance];
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"给tb_user添加数据失败");
        NSLog(@"错误信息：%s",error);
        return NO;
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
