//
//  DBImg.h
//  SQLite（购物）
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBImg : NSObject
{
    sqlite3 *_database;
}
+(DBImg *)shareDBImg;
-(NSMutableArray *)selectImgsByGoodsId:(int)goodsId;
@end
