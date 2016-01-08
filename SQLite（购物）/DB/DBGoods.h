//
//  DBGoods.h
//  SQLite（购物）
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class GoodsInfo;
@interface DBGoods : NSObject
{
    sqlite3 *_database;
}
+(DBGoods *)shareDBGoods;
-(NSString *)selectGoodsHTML:(int)goodsId;
-(NSMutableArray *)selectRecommandList:(int)goodsId type:(int)typeId;
-(NSMutableArray *)selectGoodsList:(NSString *)searchParam type:(int)typeId market:(int)marketId sort:(BOOL)sortType;
-(GoodsInfo *)selectGoodsById:(int)goodsId;
@end
