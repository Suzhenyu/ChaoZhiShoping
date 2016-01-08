//
//  DBAddress.h
//  SQLite（购物）
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class AddressInfo;
@interface DBAddress : NSObject
{
    sqlite3 *_database;
}
+(DBAddress *)shareDBAddress;
-(AddressInfo *)selectAddressById:(int)address_id;
-(AddressInfo *)selectDefaultByUserId:(NSString *)user_id;
-(NSMutableArray *)selectListByUserId:(NSString *)user_id;
-(BOOL)deleteById:(int)address_id;
-(BOOL)updateAddressData:(AddressInfo *)addressInfo;
-(BOOL)insertAddressData:(AddressInfo *)addressInfo userId:(NSString *)user_id;
@end
