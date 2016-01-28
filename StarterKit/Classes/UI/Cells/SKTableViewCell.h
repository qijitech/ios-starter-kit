//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Overcoat/OVCUtilities.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKTableViewCell
OVCGenerics(Model) : UITableViewCell

- (void)setupViews;
//- (void)updateConstraintsInternal;

- (void)configureCellWithData:(OVC_NULLABLE OVCGenericType(Model, id))entity;

+ (NSString * OVC__NONNULL)cellIdentifier;

@end

NS_ASSUME_NONNULL_END