//
//  LXDataCollectionManager.m
//  LXDataCollection
//
//  Created by junyixin on 2017/10/30.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import "LXDataCollectionManager.h"
#import "LXCommonDataModel.h"
#import "LXJSONHelper.h"

@import UIKit;

#define LOCALCACHEFILENAME      @"filename"
#define LXARCHIVEMAXCOUNT       10

@interface LXDataCollectionManager()

/**
 事件数组
 */
@property (nonatomic, strong) NSMutableArray *actions;

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
    LXCommonDataModel *model = [[LXCommonDataModel alloc] init];
    model.deviceInfo = [LXDeviceInfo obtainDeviceInfo];
    model.userId = @"";
    model.eventId = eventName;
    model.attributes = attributes;
    model.eventTime = [NSString stringWithFormat:@"%0.f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    //转为JSON字符串
    NSString *actionStr = [LXJSONHelper objectToJSON:model pretty:YES];
    [self addAction:actionStr];
}

+ (void)save {
    LXDataCollectionManager *manager = [LXDataCollectionManager shareManager];
    NSMutableArray *oldArr = [self unArchiveRecords:manager.fileName];
    [oldArr addObjectsFromArray:manager.actions];
    [manager.actions removeAllObjects];
    [LXDataCollectionManager archiveData:oldArr archiveName:manager.fileName archiveKey:@""];
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
    
    return [NSString stringWithFormat:@"%@%@", LOCALCACHEFILENAME, sendTimeStr];
}

+ (void)addAction:(NSString *)action {
    if (!action || [action isEqualToString:@""]) return;
    
    //add action to actions
    LXDataCollectionManager *manager = [LXDataCollectionManager shareManager];
    [manager.actions addObject:action];
    
    //当本地数据缓存到一定数量后进行上传
    if (manager.actions.count >= LXARCHIVEMAXCOUNT) {
        [self upload];
    }
}

#pragma mark - 文件处理

+ (NSMutableArray *)unArchiveRecords:(NSString *)fileName {
    NSMutableArray *statisticsArr = [LXDataCollectionManager unArchiveData:fileName archiveKey:@""];
    return statisticsArr ? statisticsArr : [NSMutableArray array];
}

+ (BOOL)archiveData:(id)archiveData archiveName:(NSString *)archiveName archiveKey:(NSString *)archiveKey {
    NSString *homePath = [self obtainDataArchivePath:archiveName];
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:archiveData forKey:archiveKey];
    [archiver finishEncoding];
    
    return [data writeToFile:homePath atomically:YES];
}

+ (id)unArchiveData:(NSString *)fileName archiveKey:(NSString *)archiveKey {
    NSString *homePath = [self obtainDataArchivePath:fileName];
    
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:homePath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unArchiver decodeObjectForKey:archiveKey];
}

+ (NSString *)obtainDataArchivePath:(NSString *)archiveName {
    NSString *fileDir = [self obtainDataArchiveDir];
    NSString *filePath = [fileDir stringByAppendingPathComponent:archiveName];
    
    return filePath;
}

+ (NSString *)obtainDataArchiveDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileDir = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"junyixin"] stringByAppendingPathComponent:@"Statistics"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    
    if (!isDirExist) {
        BOOL createDir = [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (!createDir) {
            NSLog(@"create file directory failed.");
        }
    }
    
    return fileDir;
}

#pragma mark - init object

- (NSMutableArray *)actions {
    if (!_actions) {
        _actions = [NSMutableArray array];
    }
    
    return _actions;
}

@end
