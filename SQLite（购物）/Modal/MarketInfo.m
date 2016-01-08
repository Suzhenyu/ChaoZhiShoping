//
//  MarketInfo.m
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "MarketInfo.h"

@implementation MarketInfo

-(id)init{
    if (self=[super init]) {
        _goodsArray=[NSMutableArray array];
    }
    return self;
}

@end
