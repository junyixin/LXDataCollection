//
//  LXDataUploadHelper.m
//  LXDataCollection
//
//  Created by junyixin on 2017/10/31.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import "LXDataUploadHelper.h"
#import "LXJSONHelper.h"

@implementation LXDataUploadHelper

static LXDataUploadHelper *instance = nil;

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
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

- (void)upload:(NSDictionary *)params completion:(LXDataUploadHelperCompleteHandler)completion failure:(LXDataUploadHelperFailHandler)failure {
    
    //这里上传数据请求也可根据项目封装的网络请求来进行
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"request URL"]];
    NSString *requestBody = [LXJSONHelper objectToJSON:params pretty:YES];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *responseObject = nil;
        if (data) {
            responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
        
        //根据错误信息使用相应的回调
    }];
    
    [task resume];
}

@end
