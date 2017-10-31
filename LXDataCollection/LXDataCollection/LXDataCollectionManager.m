//
//  LXDataCollectionManager.m
//  LXDataCollection
//
//  Created by junyixin on 2017/10/30.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import "LXDataCollectionManager.h"

@import UIKit;

@interface LXDataCollectionManager()

/**
 文件名
 */
@property (nonatomic, strong) NSString *fileName;

@end

@implementation LXDataCollectionManager

static LXDataCollectionManager *instance = nil;

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        instance.fileName = [[self class] obtainFileName];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

+ (void)addEvent:(NSString *)eventName {
    [self addEvent:eventName attributes:nil];
}

+ (void)addEvent:(NSString *)eventName attributes:(NSDictionary *)attributes {
    //
}

+ (void)save {
    //
}

+ (void)upload {
    //
}

#pragma mark - private method

+ (NSString *)obtainFileName {
    NSDate *sendDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm";
    NSString *sendTimeStr = [dateFormatter stringFromDate:sendDate];
    
    return [NSString stringWithFormat:@"%@%@", @"test", sendTimeStr];
}

@end
