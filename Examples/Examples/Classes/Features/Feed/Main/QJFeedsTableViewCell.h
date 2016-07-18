//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKTableViewCell.h>

@protocol QJFeedUserViewDelegate;

@interface QJFeedsTableViewCell : SKTableViewCell

@property(nonatomic, weak) id <QJFeedUserViewDelegate> delegate;

@end