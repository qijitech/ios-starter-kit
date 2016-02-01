//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//



#import <StarterKit/SKAccountModel.h>

@interface User : SKAccountModel

@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *realName;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, strong) NSURL *avatar;
@property(nonatomic, copy) NSString *token;

@end