//
//  LXJSONHelper.m
//  LXDataCollection
//
//  Created by junyixin on 2017/10/31.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import "LXJSONHelper.h"

@implementation LXJSONHelper

+ (id)stringToObject:(NSString *)string {
    return [self stringToObject:string error:nil];
}

+ (id)stringToObject:(NSString *)string error:(NSError *)error {
    if (!string || [string isEqualToString:@""]) return nil;
    
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
}

+ (NSString *)objectToJSON:(id)object pretty:(BOOL)pretty {
    return [self objectToJSON:object pretty:pretty error:nil];
}

+ (NSString *)objectToJSON:(id)object pretty:(BOOL)pretty error:(NSError *)error {
    NSString *result = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!error && [JSONData length] > 0) {
        result = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    }
    
    if (!pretty) {
        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    return result;
}

@end
