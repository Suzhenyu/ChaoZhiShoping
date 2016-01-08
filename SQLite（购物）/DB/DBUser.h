//
//  DBUser.h
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class UserInfo;
@interface DBUser : NSObject
{
    sqlite3 *_database;
}
+(DBUser *)shareDBUser;
-(BOOL)updateUserData:(UserInfo *)userInfo;
-(UserInfo *)loginBySearchUser:(NSString *)loginName pwd:(NSString *)loginPwd;
-(BOOL)insertData:(UserInfo *)userInfo;

@end
