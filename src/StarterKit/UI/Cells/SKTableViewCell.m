//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKTableViewCell.h"

@interface SKTableViewCell ()
@property(nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation SKTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self setupViews];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    self.didSetupConstraints = YES;
    [self updateConstraintsInternal];
  }
  [super updateConstraints];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
  // need to use to set the preferredMaxLayoutWidth below.
  [self.contentView setNeedsLayout];
  [self.contentView layoutIfNeeded];
}

// Initialization code
- (void)setupViews {
  // sub class implement
}

- (void)updateConstraintsInternal {
  // sub class implement
}

- (void)configureCellWithData:(id)entity {
  // Make sure the constraints have been added to this cell, since it may have just been created from scratch
  [self updateConstraintsIfNeeded];
  [self setNeedsUpdateConstraints];
}

@end