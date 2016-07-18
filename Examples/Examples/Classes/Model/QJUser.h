//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKAccountModel.h>

@class QJUserInfo;

@interface QJUser : SKAccountModel

@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *email;
@property(nonatomic, strong) NSArray *userToken;
@property(nonatomic, strong) QJUserInfo *userInfo;

@end