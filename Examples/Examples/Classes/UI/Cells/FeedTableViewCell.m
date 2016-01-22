//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "FeedTableViewCell.h"

#import "Feed.h"
#import "User.h"

static CGFloat const kAvatarWidth = 40;
static CGFloat const kPaddingEdge = 10;

@interface FeedTableViewCell ()

@property(nonatomic, strong) UILabel *usernameLabel;
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *contentLabel;

@end

@implementation FeedTableViewCell


# pragma mark system method

- (void)setFrame:(CGRect)frame {
  frame.size.height -= kPaddingEdge;
  [super setFrame:frame];
}

# pragma mark parent method

- (void)updateConstraintsInternal {
  [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.avatarImageView.mas_right).offset(kPaddingEdge);
    make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
    make.right.mas_equalTo(self.contentView.mas_right).offset(-kPaddingEdge);
  }];

  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(kPaddingEdge, kPaddingEdge, 0, 0));
    make.size.mas_equalTo(CGSizeMake(kAvatarWidth, kAvatarWidth));
  }];

  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(kPaddingEdge / 2);
    make.left.mas_equalTo(self.contentView.mas_left).offset(kPaddingEdge);
    make.right.mas_equalTo(self.contentView.mas_right).offset(-kPaddingEdge);
    //
    make.bottom.equalTo(self.contentView.mas_bottom).offset(-kPaddingEdge);
  }];
}

+ (NSString *)cellIdentifier {
  static NSString *const kCellIdentifier = @"FeedTableViewCell";
  return kCellIdentifier;
}

- (void)configureCellWithData:(Feed *)entity {
  self.entity = entity;
  self.usernameLabel.text = entity.user.nickname;
  self.contentLabel.text = self.entity.content;

  [super configureCellWithData:entity];
}

// Initialization code
- (void)setupViews {
  [self.contentView addSubview:self.usernameLabel];
  [self.contentView addSubview:self.avatarImageView];
  [self.contentView addSubview:self.contentLabel];

  // Fix the bug in iOS7 - initial constraints warning
  // self.contentView.bounds = [UIScreen mainScreen].bounds;
}

# pragma mark Private views getter method

- (UILabel *)usernameLabel {
  if (!_usernameLabel) {
    _usernameLabel = [[self class] labelShortWithColor:[UIColor brownColor] font:20];
  }
  return _usernameLabel;
}

- (UIImageView *)avatarImageView {
  if (!_avatarImageView) {
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = kAvatarWidth / 2;
    _avatarImageView.image = [UIImage imageNamed:@"avatar"];

  }
  return _avatarImageView;
}

- (UILabel *)contentLabel {
  if (!_contentLabel) {
    _contentLabel = [[self class] labelLongWithColor:[UIColor blackColor] font:16];
  }
  return _contentLabel;
}

+ (UILabel *)labelShortWithColor:(UIColor *)color font:(CGFloat)font {
  UILabel *label = [[UILabel alloc] init];
  label.textColor = color;
  label.font = [UIFont systemFontOfSize:font];
  label.numberOfLines = 1;
  label.lineBreakMode = NSLineBreakByTruncatingTail;
  return label;
}

+ (UILabel *)labelLongWithColor:(UIColor *)color font:(CGFloat)font {
  UILabel *label = [[UILabel alloc] init];
  label.textColor = color;
  label.font = [UIFont systemFontOfSize:font];
  label.numberOfLines = 0;
  label.lineBreakMode = NSLineBreakByWordWrapping;
  return label;
}

@end