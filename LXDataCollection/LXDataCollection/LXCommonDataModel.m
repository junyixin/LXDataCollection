//
//  LXCommonDataModel.m
//  LXDataCollection
//
//  Created by junyixin on 2017/10/30.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import "LXCommonDataModel.h"
#import "sys/utsname.h"

@import UIKit;
@import AdSupport;
@import CoreTelephony;

@implementation LXDeviceInfo

+ (instancetype)obtainDeviceInfo {
    LXDeviceInfo *deviceInfo = [LXDeviceInfo new];
    UIDevice *device = [UIDevice currentDevice];
    
    deviceInfo.osVersion = device.systemVersion;
    deviceInfo.brand = device.model;
    deviceInfo.deviceType = @"1";
    deviceInfo.uuid = device.identifierForVendor.UUIDString;
    deviceInfo.adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    deviceInfo.channel = @"App Store";
    deviceInfo.carrier = [self currentCarrierInfo];
    deviceInfo.version = [self currentAppVersion];
    deviceInfo.build = [self currentAppBuildCode];
    deviceInfo.model = [self currentDeviceVersion];
    deviceInfo.networkType = [self currentNetworkType];
    
    return deviceInfo;
}

#pragma mark - private method

+ (NSString *)currentAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)currentAppBuildCode {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)currentCarrierInfo {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    
    return [carrier carrierName];
}

+ (NSString *)currentDeviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //参考指标,维基百科：https://www.theiphonewiki.com/wiki/Models
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    return @"";
}

+ (NSString *)currentNetworkType {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    //通过状态栏获取网络状态
    NSString *state = nil;
    int networkType = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    state = @"unknow";
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return state;
}

@end

@implementation LXCommonDataModel

@end
