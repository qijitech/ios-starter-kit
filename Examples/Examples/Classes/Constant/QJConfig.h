//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJConfig : NSObject

extern NSString *const kBaseURL;
extern NSString *const kAccept;

extern NSString *const kUmengAppKey;
extern NSString *const kUmengWechatAppId;
extern NSString *const kUmengWechatAppSecret;
extern NSString *const kUmengQqAppId;
extern NSString *const kUmengQqAppSecret;
extern NSString *const kUmengWeiboAppId;
extern NSString *const kUmengWeiboAppSecret;

extern NSString *const kQiNiuBaseURL;

// open im
extern NSString *const kOpenIMDevKey;

// 高德地图
extern NSString *const kAMapAPIKey;

// Important!!!
// I don't think this method enough safe, safety is get keys from server.
extern NSString *const kScope;
extern NSString *const kAccessKey;
extern NSString *const kSecretKey;

// location cache
extern NSString *const kUserDefaultLatitude;
extern NSString *const kUserDefaultLongitude;

@end