//
//  LXJSONHelper.h
//  LXDataCollection
//
//  Created by junyixin on 2017/10/31.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXJSONHelper : NSObject

//JSON字符串转Object
+ (id)stringToObject:(NSString *)string;
+ (id)stringToObject:(NSString *)string error:(NSError *)error;

//Object转JSON字符串
+ (NSString *)objectToJSON:(id)object pretty:(BOOL)pretty;
+ (NSString *)objectToJSON:(id)object pretty:(BOOL)pretty error:(NSError *)error;

@end
