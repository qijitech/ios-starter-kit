//
// Created by Hammer on 3/31/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKLoadMoreEmptyTableViewCell.h"
#import "SKErrorResponseModel.h"
#import <Masonry/Masonry.h>

@interface SKLoadMoreEmptyTableViewCell ()
@property(nonatomic, strong) UILabel *label;
@property BOOL didSetupConstraints;
@end

@implementation SKLoadMoreEmptyTableViewCell

- (void)setupViews {
  self.label = [UILabel new];
  self.label.text = @"没有更多数据";
  [self.contentView addSubview:self.label];
}

+ (NSString *)cellIdentifier {
  static NSString *const kCellIdentifier = @"SKLoadMoreEmptyTableViewCell";
  return kCellIdentifier;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {

    self.didSetupConstraints = YES;

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.contentView.mas_centerX);
      make.centerY.equalTo(self.contentView.mas_centerY);
    }];
  }
  [super updateConstraints];
}

- (void)setError:(NSError *)error {
  _error = error;
  if (error) {
    self.label.text = [SKErrorResponseModel buildMessageWithNetworkError:error];
  }
  [self updateConstraintsIfNeeded];
  [self setNeedsUpdateConstraints];
}

- (void)configureCellWithData:(id)entity {
  [super configureCellWithData:entity];
}


@end