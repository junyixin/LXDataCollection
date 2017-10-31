//
//  LXDataUploadHelper.h
//  LXDataCollection
//
//  Created by junyixin on 2017/10/31.
//  Copyright © 2017年 junyixin. All rights reserved.
//

#import <Foundation/Foundation.h>

//上传完成回调
typedef void(^LXDataUploadHelperCompleteHandler)(id responseObject);
//上传失败回调
typedef void(^LXDataUploadHelperFailHandler)(NSError *error);

@interface LXDataUploadHelper : NSObject

/**
 单例方法
 */
+ (instancetype)shareHelper;

/**
 上传数据

 @param params 数据
 @param completion 完成回调
 @param failure 失败回调
 */
- (void)upload:(NSDictionary *)params completion:(LXDataUploadHelperCompleteHandler)completion failure:(LXDataUploadHelperFailHandler)failure;

@end
