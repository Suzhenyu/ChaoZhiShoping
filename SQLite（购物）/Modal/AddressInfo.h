//
//  AddressInfo.h
//  SQLite（购物）
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject

@property (nonatomic,assign) int address_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *district;
@property (nonatomic,copy) NSString *street;
@property (nonatomic,assign) int isdefault;

@end
