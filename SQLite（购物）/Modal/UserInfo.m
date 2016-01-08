//
//  UserInfo.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *singleInstance=nil;
@implementation UserInfo

#pragma mark--!!!
//这里是无用代码吗？
+(UserInfo *)shareUserInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}

//存归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    //调用NSCoder的方法归档该对象的每一个属性
    [aCoder encodeObject:_user_id forKey:@"_user_id"];
    [aCoder encodeObject:_user_name forKey:@"_user_name"];
    [aCoder encodeObject:_user_pwd forKey:@"_user_pwd"];
    [aCoder encodeObject:_user_head forKey:@"_user_head"];
    [aCoder encodeDouble:_user_balance forKey:@"_user_balance"];
}
//取归档
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        //使用NSCoder的方法从归档中依次恢复该对象的每一个属性
        _user_id=[aDecoder decodeObjectForKey:@"_user_id"];
        _user_name=[[aDecoder decodeObjectForKey:@"_user_name"] copy];
        _user_pwd=[aDecoder decodeObjectForKey:@"_user_pwd"];
        _user_head=[[aDecoder decodeObjectForKey:@"_user_head"] copy];
        _user_balance=[aDecoder decodeDoubleForKey:@"_user_balance"];
    }
    return self;
}

@end
