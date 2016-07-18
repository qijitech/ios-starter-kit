//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJModel.h"

@class QJUserInfo;
@class QJCategory;

@interface QJPost : QJModel

@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) QJUserInfo *userInfo;
@property(nonatomic, strong) QJCategory *category;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, strong) NSNumber *createdAt;

@property(nonatomic, strong) NSNumber *lng;
@property(nonatomic, strong) NSNumber *lat;
@property(nonatomic, strong) NSNumber *countViews;
@property(nonatomic, strong) NSNumber *countComments;

- (NSArray *)buildPhotoArray:(NSUInteger)width height:(NSUInteger)height;

@end