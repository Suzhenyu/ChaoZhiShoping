//
//  MarketInfo.h
//  SQLite（购物）
//
//  Created by apple on 15/8/23.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketInfo : NSObject

//市场id
@property (nonatomic,assign) int market_id;
//市场标题
@property (nonatomic,copy) NSString *market_value;
//市场下对应的商品数组
@property (nonatomic,strong) NSMutableArray *goodsArray;

@end
