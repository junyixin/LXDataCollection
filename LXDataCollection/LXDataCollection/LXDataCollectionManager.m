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
#import "LXDataUploadHelper.h"

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
    [self save];
    
    //获取所有需要上传的数据
    NSString *rootPath = [self obtainDataArchiveDir];
    NSArray *files = [self obtainAllFileByPath:rootPath];
    
    for (NSString *fileName in files) {
        //是否是备份文件
        if ([fileName isEqualToString:@"backup"]) continue;
        //
    }
}

#pragma mark - private method

+ (void)uploadFile:(NSString *)fileName recursionCount:(NSInteger)recursionCount {
    if (recursionCount <= 0 || recursionCount > 3) {
        return;
    }
    
    //获取所有的事件记录
    NSMutableArray *uploadRecords = [self unArchiveRecords:fileName];
    if (uploadRecords.count <= 0) return;
    
    LXDataUploadHelper *helper = [LXDataUploadHelper shareHelper];
    NSString *uploadTime = [NSString stringWithFormat:@"%0.f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    NSDictionary *params = @{
                             @"uploadTime":uploadTime,
                             @"records":uploadRecords
                             };
    __block NSInteger iCount = recursionCount;
    [helper upload:params completion:^(id responseObject) {
        //上传完成功删除文件
    } failure:^(NSError *error) {
        //再次上传
        iCount -= 1;
        [self uploadFile:fileName recursionCount:iCount];
    }];
}

+ (NSArray *)obtainAllFileByPath:(NSString *)path {
    NSMutableArray *array = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *tempArr = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *fileName in tempArr) {
        BOOL flag = YES;
        NSString *fullPath = [path stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fileName];
            }
        }
    }
    
    return array;
}

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
