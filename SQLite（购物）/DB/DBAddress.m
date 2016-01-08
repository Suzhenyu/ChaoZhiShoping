//
//  DBAddress.m
//  SQLite（购物）
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBAddress.h"
#import "MyFilePlist.h"
#import "AddressInfo.h"

static DBAddress *singleInstance=nil;
@implementation DBAddress

+(DBAddress *)shareDBAddress{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[DBAddress alloc] init];
        }
    }
    return singleInstance;
}

-(BOOL)insertAddressData:(AddressInfo *)addressInfo userId:(NSString *)user_id{
    if (![self openSQLite]) {
        return NO;
    }
    //user_name,user_pwd,user_head,user_balance
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_address(name,phone,province,street,user_id,isdefault,city,district) VALUES ('%@','%@','%@','%@','%@',%i,'%@','%@')",addressInfo.name,addressInfo.phone,addressInfo.province,addressInfo.street,user_id,addressInfo.isdefault,addressInfo.city,addressInfo.district];
    
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

-(BOOL)updateAddressData:(AddressInfo *)addressInfo{
    if (![self openSQLite]) {
        return NO;
    }
    //user_name,user_pwd,user_head,user_balance
    NSString *sqlStr=[NSString stringWithFormat:@"UPDATE tb_address SET name='%@',"
                      "phone='%@',province='%@',city='%@',district='%@',street='%@',isdefault=%i WHERE address_id=%i",addressInfo.name,addressInfo.phone,addressInfo.province,addressInfo.city,addressInfo.district,addressInfo.street,addressInfo.isdefault,addressInfo.address_id];
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_address更新数据失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(BOOL)deleteById:(int)address_id{
    if (![self openSQLite]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"DELETE FROM tb_address WHERE address_id=%i",address_id];
    
    char *error;
    //执行sql语句
    int success=sqlite3_exec(_database, [sqlStr UTF8String], NULL, NULL, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"tb_address删除数据失败");
        return NO;
    }
    
    //关闭数据库
    sqlite3_close(_database);
    
    return YES;
}

-(AddressInfo *)selectAddressById:(int)address_id{
    AddressInfo *addressInfo=nil;
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT address_id,name,phone,province,city,district,street FROM tb_address WHERE address_id=%i",address_id];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"通过id查询地址信息时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    if (sqlite3_step(statement) == SQLITE_ROW) {
        int address_id=sqlite3_column_int(statement, 0);
        char *name=(char *)sqlite3_column_text(statement, 1);
        char *phone=(char *)sqlite3_column_text(statement, 2);
        char *province=(char *)sqlite3_column_text(statement, 3);
        char *city=(char *)sqlite3_column_text(statement, 4);
        char *district=(char *)sqlite3_column_text(statement, 5);
        char *street=(char *)sqlite3_column_text(statement, 6);
        
        addressInfo=[[AddressInfo alloc] init];
        addressInfo.address_id=address_id;
        if (name) {
            addressInfo.name=[NSString stringWithUTF8String:name];
        }
        if (phone) {
            addressInfo.phone=[NSString stringWithUTF8String:phone];
        }
        if (province) {
            addressInfo.province=[NSString stringWithUTF8String:province];
        }
        if (city) {
            addressInfo.city=[NSString stringWithUTF8String:city];
        }
        if (district) {
            addressInfo.district=[NSString stringWithUTF8String:district];
        }
        if (street) {
            addressInfo.street=[NSString stringWithUTF8String:street];
        }
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return addressInfo;
}

-(AddressInfo *)selectDefaultByUserId:(NSString *)user_id{
    AddressInfo *addressInfo=nil;
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT address_id,name,phone,province,city,district,street FROM tb_address WHERE user_id='%@' AND isdefault=1",user_id];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询默认收获地址时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    if (sqlite3_step(statement) == SQLITE_ROW) {
        int address_id=sqlite3_column_int(statement, 0);
        char *name=(char *)sqlite3_column_text(statement, 1);
        char *phone=(char *)sqlite3_column_text(statement, 2);
        char *province=(char *)sqlite3_column_text(statement, 3);
        char *city=(char *)sqlite3_column_text(statement, 4);
        char *district=(char *)sqlite3_column_text(statement, 5);
        char *street=(char *)sqlite3_column_text(statement, 6);
        
        addressInfo=[[AddressInfo alloc] init];
        addressInfo.address_id=address_id;
        if (name) {
            addressInfo.name=[NSString stringWithUTF8String:name];
        }
        if (phone) {
            addressInfo.phone=[NSString stringWithUTF8String:phone];
        }
        if (province) {
            addressInfo.province=[NSString stringWithUTF8String:province];
        }
        if (city) {
            addressInfo.city=[NSString stringWithUTF8String:city];
        }
        if (district) {
            addressInfo.district=[NSString stringWithUTF8String:district];
        }
        if (street) {
            addressInfo.street=[NSString stringWithUTF8String:street];
        }
        
    }
    
    //关闭数据库句柄
    sqlite3_finalize(statement);
    //关闭数据库
    sqlite3_close(_database);
    
    return addressInfo;
}

-(NSMutableArray *)selectListByUserId:(NSString *)user_id{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT address_id,name,phone,province,street,isdefault,city,district FROM tb_address WHERE user_id='%@' ORDER BY address_id DESC",user_id];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询收获地址时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    //因为我们只查询一条数据，所以不需要循环
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int address_id = sqlite3_column_int(statement, 0);
        char *name=(char *)sqlite3_column_text(statement, 1);
        char *phone=(char *)sqlite3_column_text(statement, 2);
        char *province=(char *)sqlite3_column_text(statement, 3);
        char *street=(char *)sqlite3_column_text(statement, 4);
        int isdefault = sqlite3_column_int(statement, 5);
        char *city=(char *)sqlite3_column_text(statement, 6);
        char *district=(char *)sqlite3_column_text(statement, 7);
        
        AddressInfo *address=[[AddressInfo alloc] init];
        address.address_id=address_id;
        if (name) {
            address.name=[NSString stringWithUTF8String:name];
        }
        if (phone) {
            address.phone=[NSString stringWithUTF8String:phone];
        }
        if (province) {
            address.province=[NSString stringWithUTF8String:province];
        }
        if (street) {
            address.street=[NSString stringWithUTF8String:street];
        }
        address.isdefault=isdefault;
        if (city) {
            address.city=[NSString stringWithUTF8String:city];
        }
        if (district) {
            address.district=[NSString stringWithUTF8String:district];
        }
        [mutArray addObject:address];
        
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
