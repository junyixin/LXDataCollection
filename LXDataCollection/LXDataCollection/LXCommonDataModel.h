//
//  LXCommonDataModel.h
//  LXDataCollection
//
//  Created by junyixin on 2017/10/30.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXDeviceInfo: NSObject

+ (instancetype)obtainDeviceInfo;

/**
 运营商
 */
@property (nonatomic, strong) NSString *carrier;

/**
 App版本号
 */
@property (nonatomic, strong) NSString *version;

/**
 App build编号
 */
@property (nonatomic, strong) NSString *build;

/**
 设备类型(0:Android  1:iOS  2:PC)
 */
@property (nonatomic, strong) NSString *deviceType;

/**
 设备型号(eg:iPhone7)
 */
@property (nonatomic, strong) NSString *model;

/**
 手机品牌
 */
@property (nonatomic, strong) NSString *brand;

/**
 系统版本
 */
@property (nonatomic, strong) NSString *osVersion;

/**
 网络类型
 */
@property (nonatomic, strong) NSString *networkType;

/**
 UUID
 */
@property (nonatomic, strong) NSString *uuid;

/**
 IDFA
 */
@property (nonatomic, strong) NSString *adid;

/**
 渠道
 */
@property (nonatomic, strong) NSString *channel;

@end

@interface LXCommonDataModel : NSObject

/**
 设备信息
 */
@property (nonatomic, strong) LXDeviceInfo *deviceInfo;

/**
 用户ID
 */
@property (nonatomic, strong) NSString *userId;

/**
 事件ID
 */
@property (nonatomic, strong) NSString *eventId;

/**
 标识属性
 */
@property (nonatomic, strong) NSDictionary *attributes;

/**
 事件时间
 */
@property (nonatomic, strong) NSString *eventTime;

@end
