//
// Created by Hammer on 1/27/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKFeedPictureTableViewCell.h"
#import <Masonry/Masonry.h>
#import "SKUserSimpleView.h"
#import "SKFeedContentView.h"
#import "SKPictureView.h"
#import "Feed.h"

@interface SKFeedPictureTableViewCell ()
@property BOOL didSetupConstraints;
@property SKUserSimpleView *headerView;
@property SKFeedContentView *feedContentView;
@property SKPictureView *feedPictureView;
@end

@implementation SKFeedPictureTableViewCell

- (void)setFrame:(CGRect)frame {
  frame.size.height -= 1;
  [super setFrame:frame];
}

- (void)configureCellWithData:(Feed *)entity {
  self.headerView.feed = entity;
  self.feedContentView.feed = entity;
  self.feedPictureView.data = entity.images;
  [super configureCellWithData:entity];
}

+ (NSString *OVC__NONNULL)cellIdentifier {
  static NSString *const kCellIdentifier = @"SKFeedPictureTableViewCell";
  return kCellIdentifier;
}

- (void)setupViews {
  self.headerView = [[SKUserSimpleView alloc] initWithFrame:CGRectZero];
  self.feedContentView = [[SKFeedContentView alloc] initWithFrame:CGRectZero];
  self.feedPictureView = [[SKPictureView alloc] initWithFrame:CGRectZero];

  [self.contentView addSubview:self.headerView];
  [self.contentView addSubview:self.feedContentView];
  [self.contentView addSubview:self.feedPictureView];
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    self.didSetupConstraints = YES;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.and.right.equalTo(self.contentView);
      make.height.mas_equalTo(@(60));
    }];
    [self.feedContentView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.headerView.mas_bottom);
      make.left.and.right.equalTo(self.contentView);
    }];
    [self.feedPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.feedContentView.mas_bottom);
      make.height.mas_equalTo(@([self.feedPictureView height]));
      make.left.right.and.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
  }
    
  [self.feedPictureView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(@([self.feedPictureView height]));
  }];
    
  [super updateConstraints];
}

@end