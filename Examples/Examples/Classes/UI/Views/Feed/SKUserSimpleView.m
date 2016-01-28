//
// Created by Hammer on 1/27/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SKUserSimpleView.h"
#import "Feed.h"
#import "User.h"

static CGFloat const kAvatarWidth = 40;
static CGFloat const kPaddingEdge = 10;

@interface SKUserSimpleView ()
@property BOOL didSetupConstraints;
@property UIImageView *avatarImageView;
@property UILabel *nameLabel;
@property UILabel *createdAtLabel;
@end

@implementation SKUserSimpleView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setupViews];
  }
  return self;
}

- (void)setupViews {
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];

  // avatar
  self.avatarImageView = [[UIImageView alloc] init];
  self.avatarImageView.layer.masksToBounds = YES;
  self.avatarImageView.layer.cornerRadius = kAvatarWidth / 2;
  self.avatarImageView.image = [UIImage imageNamed:@"avatar"];

  // user name
  self.nameLabel = [UILabel new];
  self.nameLabel.textColor = [UIColor blackColor];
  self.nameLabel.font = [UIFont systemFontOfSize:18];
  self.nameLabel.numberOfLines = 1;
  self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;

  // createdAt label
  self.createdAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.createdAtLabel.text = @"4h ago";
  self.createdAtLabel.font = [UIFont boldSystemFontOfSize:14];
  self.createdAtLabel.textColor = [UIColor grayColor];

  [self addSubview:self.avatarImageView];
  [self addSubview:self.nameLabel];
  [self addSubview:self.createdAtLabel];
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {

    self.didSetupConstraints = YES;

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(kAvatarWidth, kAvatarWidth));
      make.centerY.equalTo(self);
      make.left.equalTo(self).with.offset(kPaddingEdge);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.avatarImageView);
      make.left.equalTo(self.avatarImageView.mas_right).with.offset(kPaddingEdge);
    }];

    [self.createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.avatarImageView);
      make.left.equalTo(self.avatarImageView.mas_right).with.offset(kPaddingEdge);
    }];
  }

  [super updateConstraints];
}

- (void)setFeed:(Feed *)feed {
  _feed = feed;
  User *user = feed.user;
  self.nameLabel.text = user.nickname;

  // Here we use the new provided sd_setImageWithURL: method to load the web image
  [self.avatarImageView
      sd_setImageWithURL:[user avatar]
        placeholderImage:[UIImage imageNamed:@"avatar"]];

  [self updateConstraintsIfNeeded];
  [self setNeedsUpdateConstraints];
}

@end