//
//  DBImg.m
//  SQLite（购物）
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "DBImg.h"
#import "MyFilePlist.h"
#import "XPhoto.h"

static DBImg *singleInstance=nil;
@implementation DBImg

+(DBImg *)shareDBImg{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}

-(NSMutableArray *)selectImgsByGoodsId:(int)goodsId{
    NSMutableArray *mutArray=[NSMutableArray array];
    
    if (![self openSQLite]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT img_name FROM tb_img WHERE goods_id=%i",goodsId];
    int success = sqlite3_prepare_v2(_database, [sqlStr UTF8String], -1, &statement, nil);
    //如果result的值是SQLITE_OK，则表明准备好statement
    if (success != SQLITE_OK) {
        NSLog(@"查询历史记录时，statement准备失败");
        return nil;
    }
    //这个就是依次将每行的数据存在statement中，然后根据每行的字段取出数据
    while (sqlite3_step(statement) == SQLITE_ROW) {
        XPhoto *xPhoto=[[XPhoto alloc] init];
        char* history_value    = (char*)sqlite3_column_text(statement, 0);
        
        NSString *str = [NSString stringWithUTF8String:history_value];
        UIImage *img=[UIImage imageNamed:str];
        xPhoto.image=img;
        
        [mutArray addObject:xPhoto];
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
