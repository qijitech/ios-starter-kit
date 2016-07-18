//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJModel.h"

@interface QJUserInfo : QJModel <NSCoding>

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *avatar;

@property(nonatomic, strong) NSNumber *wallet;
@property(nonatomic, strong) NSNumber *gender;
@property(nonatomic, strong) NSNumber *yearOfBirth;
@property(nonatomic, strong) NSNumber *monthOfBirth;
@property(nonatomic, strong) NSNumber *dayOfBirth;
@property(nonatomic, strong) NSNumber *countReport;
@property(nonatomic, strong) NSNumber *countRead;
@property(nonatomic, strong) NSNumber *countPost;

- (NSURL *)toURL:(NSInteger)width height:(NSInteger)height;

@end