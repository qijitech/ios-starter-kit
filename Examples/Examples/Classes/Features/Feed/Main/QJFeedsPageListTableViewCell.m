//
//  QJFeedsPageListTableViewCell.m
//  Examples
//
//  Created by shuu on 2017/4/10.
//  Copyright © 2017年 奇迹空间. All rights reserved.
//

#import "QJFeedsPageListTableViewCell.h"
#import <Masonry/Masonry.h>
#import "QJPageListModel.h"

@interface QJFeedsPageListTableViewCell ()
@property BOOL didSetupConstraints;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation QJFeedsPageListTableViewCell

- (void)setupViews {
  [super setupViews];
  self.backgroundColor = [UIColor whiteColor];
  [self.contentView addSubview:self.dateLabel];
}

- (void)setFrame:(CGRect)frame {
  frame.size.height -= 10;
  [super setFrame:frame];
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    self.didSetupConstraints = YES;
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.contentView);
    }];
  }
  [super updateConstraints];
}

+ (NSString *OVC__NONNULL)cellIdentifier {
  static NSString *const kCellIdentifier = @"QJFeedsPageListTableViewCell";
  return kCellIdentifier;
}

- (void)configureCellWithData:(QJPageListModel *)entity {
  self.dateLabel.text = entity.exchDate;
  [super configureCellWithData:entity];
}

- (UILabel *)dateLabel {
  if (!_dateLabel) {
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = [UIColor blackColor];
  }
  return _dateLabel;
}

@end
