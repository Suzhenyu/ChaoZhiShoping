//
//  DBSearchHistory.h
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBSearchHistory : NSObject
{
    sqlite3 *_database;
}
+(DBSearchHistory *)shareDBSearchHistory;
-(BOOL)deleteAllHistory;
-(NSMutableArray *)selectAllHistory;
-(BOOL)insertData:(NSString *)searchValue;
@end
