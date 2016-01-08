//
//  MyFilePlist.m
//  备忘录（属性列表）
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "MyFilePlist.h"

@implementation MyFilePlist

+(NSString *)documentFilePathStr:(NSString *)fromFileName{
    //获取Document目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[paths objectAtIndex:0];
    //读取名为memoList.plist的属性文件
    NSString *str=[NSString stringWithFormat:@"%@/%@",documentPath,fromFileName];
    return str;
}

@end
