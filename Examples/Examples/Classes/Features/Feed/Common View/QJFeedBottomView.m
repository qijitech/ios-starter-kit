//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJFeedBottomView.h"
#import <Masonry/Masonry.h>
#import "QJConstants.h"
#import "UIColor+QJ.h"
#import "QJPost.h"

@interface QJFeedBottomView ()
@property(nonatomic, strong) UIImageView *locationImageView;
@property(nonatomic, strong) UILabel *locationLabel;

@property(nonatomic, strong) UIImageView *viewsImageView;
@property(nonatomic, strong) UILabel *viewsLabel;

@property(nonatomic, strong) UIImageView *commentsImageView;
@property(nonatomic, strong) UILabel *commentsLabel;
@end

@implementation QJFeedBottomView

- (void)setupViews {

  [self addSubview:self.locationImageView];
  [self addSubview:self.locationLabel];

  [self addSubview:self.viewsImageView];
  [self addSubview:self.viewsLabel];
  [self addSubview:self.commentsImageView];
  [self addSubview:self.commentsLabel];
}

- (void)updateConstraintsInternal {
  if (!_shouldHideLocation) {
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(self);
    }];

    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self.locationImageView);
      make.left.equalTo(self.locationImageView.mas_right).with.offset(kInlinePaddingEdge);
    }];
  }

  [self.commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.top.and.bottom.equalTo(self);
  }];

  [self.commentsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.commentsLabel);
    make.right.equalTo(self.commentsLabel.mas_left).with.offset(-kInlinePaddingEdge);
  }];

  [self.viewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.commentsImageView);
    make.right.equalTo(self.commentsImageView.mas_left).with.offset(-kPaddingEdge);
  }];

  [self.viewsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.viewsLabel);
    make.right.equalTo(self.viewsLabel.mas_left).with.offset(-kInlinePaddingEdge);
  }];
}

- (void)configureWithData:(QJPost *)entity {
  _post = entity;
  self.commentsLabel.text = [NSString stringWithFormat:@"%d次", [entity.countComments intValue]];
  self.viewsLabel.text = [NSString stringWithFormat:@"%d次", [entity.countViews intValue]];
//  NSString *distance = [MMLocationManager getDistanceFromPublishedLatitude:entity.lat longitude:entity.lng];
//  self.locationLabel.text = distance.length ? [NSString stringWithFormat:@"%@公里", distance] : @"正在获取位置...";
  [super configureWithData:entity];
}

- (UIImageView *)locationImageView {
  if (!_locationImageView) {
    _locationImageView = [UIImageView new];
    _locationImageView.image = [UIImage imageNamed:@"feed_location"];
  }
  return _locationImageView;
}

- (UILabel *)locationLabel {
  if (!_locationLabel) {
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _locationLabel.text = @"13.0公里";
    _locationLabel.font = [UIFont boldSystemFontOfSize:14];
    _locationLabel.textColor = [UIColor qj_textGrayColor];
  }
  return _locationLabel;
}

- (UIImageView *)viewsImageView {
  if (!_viewsImageView) {
    _viewsImageView = [UIImageView new];
    _viewsImageView.image = [UIImage imageNamed:@"feed_views"];
  }
  return _viewsImageView;
}

- (UILabel *)viewsLabel {
  if (!_viewsLabel) {
    _viewsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _viewsLabel.text = @"13次";
    _viewsLabel.font = [UIFont boldSystemFontOfSize:14];
    _viewsLabel.textColor = [UIColor qj_textGrayColor];
  }
  return _viewsLabel;
}

- (UIImageView *)commentsImageView {
  if (!_commentsImageView) {
    _commentsImageView = [UIImageView new];
    _commentsImageView.image = [UIImage imageNamed:@"feed_comments"];
  }
  return _commentsImageView;
}

- (UILabel *)commentsLabel {
  if (!_commentsLabel) {
    _commentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentsLabel.text = @"13次";
    _commentsLabel.font = [UIFont boldSystemFontOfSize:14];
    _commentsLabel.textColor = [UIColor qj_textGrayColor];
  }
  return _commentsLabel;
}

@end