//
//  LXDataCollectionManager.h
//  LXDataCollection
//
//  Created by junyixin on 2017/10/30.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXDataCollectionManager : NSObject

/**
 单例方法
 */
+ (instancetype)shareManager;

/**
 添加事件

 @param eventName 事件名称
 */
+ (void)addEvent:(NSString *)eventName;

/**
 添加事件

 @param eventName 事件名称
 @param attributes 标识属性
 */
+ (void)addEvent:(NSString *)eventName attributes:(NSDictionary *)attributes;

/**
 本地缓存
 */
+ (void)save;

/**
 数据上传
 */
+ (void)upload;

@end
