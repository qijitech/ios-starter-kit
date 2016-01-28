//
// Created by Hammer on 1/27/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKFeedTableViewCell.h"
#import <Masonry/Masonry.h>
#import "SKUserSimpleView.h"
#import "SKFeedContentView.h"
#import "Feed.h"

@interface SKFeedTableViewCell ()
@property BOOL didSetupConstraints;
@property SKUserSimpleView *headerView;
@property SKFeedContentView *feedContentView;
@end

@implementation SKFeedTableViewCell

- (void)setFrame:(CGRect)frame {
  frame.size.height -= 1;
  [super setFrame:frame];
}

- (void)configureCellWithData:(Feed *)entity {
  self.headerView.feed = entity;
  self.feedContentView.feed = entity;
  [super configureCellWithData:entity];
}

+ (NSString *OVC__NONNULL)cellIdentifier {
  static NSString *const kCellIdentifier = @"SKFeedTableViewCell";
  return kCellIdentifier;
}

- (void)setupViews {
  self.headerView = [[SKUserSimpleView alloc] initWithFrame:CGRectZero];
  self.feedContentView = [[SKFeedContentView alloc] initWithFrame:CGRectZero];

  [self.contentView addSubview:self.headerView];
  [self.contentView addSubview:self.feedContentView];
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
      make.left.right.and.bottom.equalTo(self.contentView);
    }];
  }
  [super updateConstraints];
}

@end