//
//  DBComment.h
//  SQLite（购物）
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class CommentInfo;
@interface DBComment : NSObject
{
    sqlite3 *_database;
}
+(DBComment *)shareDBComment;
-(int)selectCountByGoodsId:(int)goods_id;
-(NSMutableArray *)selectListByGoodsID:(int)goods_id;
-(NSMutableArray *)selectListByUserId:(NSString *)user_id;
-(BOOL)insertCommendData:(CommentInfo *)commentInfo userId:(NSString *)user_id;
@end
