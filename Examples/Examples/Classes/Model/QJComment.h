//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJModel.h"

@class QJUserInfo;

@interface QJComment : QJModel

@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) NSNumber *createdAt;
@property(nonatomic, strong) QJComment *parent;
@property(nonatomic, strong) QJUserInfo *userInfo;

@end