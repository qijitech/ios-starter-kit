//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "QJFeedsTableViewCell.h"
#import "QJFeedUserView.h"
#import "QJFeedBottomView.h"
#import "QJFeedContentView.h"
#import "QJPost.h"
#import "QJFeedPhotoView.h"
#import "QJConstants.h"

@interface QJFeedsTableViewCell ()
@property BOOL didSetupConstraints;
@property(nonatomic, strong) QJFeedUserView *feedUserView;
@property(nonatomic, strong) QJFeedContentView *feedContentView;
@property(nonatomic, strong) QJFeedBottomView *feedBottomView;
@property(nonatomic, strong) QJFeedPhotoView *photoPickerView;
@property(nonatomic, strong) QJPost *post;
@end

@implementation QJFeedsTableViewCell

- (void)setupViews {
  [super setupViews];
  self.backgroundColor = [UIColor whiteColor];
  self.feedUserView = [[QJFeedUserView alloc] initWithFrame:CGRectZero];
  self.feedContentView = [[QJFeedContentView alloc] initWithFrame:CGRectZero];
  self.feedBottomView = [[QJFeedBottomView alloc] initWithFrame:CGRectZero];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self.contentView addSubview:self.feedContentView];
  [self.contentView addSubview:self.feedUserView];
  [self.contentView addSubview:self.photoPickerView];
  [self.contentView addSubview:self.feedBottomView];
}

- (void)setFrame:(CGRect)frame {
  frame.size.height -= 10;
  [super setFrame:frame];
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {

    self.didSetupConstraints = YES;
    UIEdgeInsets padding = UIEdgeInsetsMake(kPaddingEdge, kPaddingEdge, kPaddingEdge, kPaddingEdge);

    [self.feedUserView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.and.right.equalTo(self.contentView).with.insets(padding);
    }];

    [self.feedContentView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.feedUserView.mas_bottom).with.insets(padding);
      make.left.and.right.equalTo(self.contentView).with.insets(padding);
    }];

    [self.photoPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.and.right.equalTo(self.contentView);
      make.top.equalTo(self.feedContentView.mas_bottom);
    }];

    [self.feedBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.photoPickerView.mas_bottom).with.insets(padding);
      make.left.right.and.bottom.equalTo(self.contentView).with.insets(padding);
    }];
  }
  [super updateConstraints];
}

+ (NSString *OVC__NONNULL)cellIdentifier {
  static NSString *const kCellIdentifier = @"QJFeedsTableViewCell";
  return kCellIdentifier;
}

- (void)configureCellWithData:(QJPost *)entity {
  _post = entity;
  [self.feedUserView configureWithData:entity];
  [self.feedContentView configureWithData:entity];

  NSUInteger imageWidth = (NSUInteger) self.photoPickerView.photoWidth;
  NSUInteger imageHeight = (NSUInteger) self.photoPickerView.photoHeight;
  [self.photoPickerView configureWithData:[entity buildPhotoArray:imageWidth height:imageHeight]];

  [self.feedBottomView configureWithData:entity];
  [super configureCellWithData:entity];
}

- (QJFeedPhotoView *)photoPickerView {
  if (!_photoPickerView) {
    _photoPickerView = [QJFeedPhotoView new];
    _photoPickerView.photoViewLeftMargin = kPaddingEdge;
    _photoPickerView.photoViewTopMargin = kPaddingEdge;
    _photoPickerView.photoViewRightMargin = kPaddingEdge;
    _photoPickerView.photoViewBottomMargin = kPaddingEdge;
    _photoPickerView.photoSpace = 5;
  }
  return _photoPickerView;
}

- (void)setDelegate:(id <QJFeedUserViewDelegate>)delegate {
  self.feedUserView.delegate = delegate;
}

@end