//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <BFPaperButton/BFPaperButton.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "QJFeedUserView.h"
#import "QJConstants.h"
#import "QJPost.h"
#import "UIColor+QJ.h"
#import "QJUserInfo.h"
#import "QJCategory.h"

@interface QJFeedUserView ()
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *displayNameLabel;
@property(nonatomic, strong) UILabel *hintLabel;
@property(nonatomic, strong) BFPaperButton *categoryLabel;
@property(nonatomic, strong) UILabel *createdAtLabel;

@property(nonatomic, strong)UITapGestureRecognizer *tapAvatar;
@end

@implementation QJFeedUserView

- (void)setupViews {
  [self addSubview:self.avatarImageView];
  [self addSubview:self.displayNameLabel];
  [self addSubview:self.hintLabel];
  [self addSubview:self.categoryLabel];
  [self addSubview:self.createdAtLabel];
}

- (void)updateConstraintsInternal {
  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(kAvatarWidth, kAvatarWidth));
    make.left.top.and.bottom.equalTo(self);
  }];

  [self.displayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.avatarImageView);
    make.left.equalTo(self.avatarImageView.mas_right).with.offset(kPaddingEdge);
  }];

  [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.displayNameLabel);
    make.left.equalTo(self.displayNameLabel.mas_right).with.offset(kInlinePaddingEdge);
  }];

  [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.hintLabel);
    make.left.equalTo(self.hintLabel.mas_right).with.offset(kInlinePaddingEdge);
  }];

  [self.createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self);
    make.right.equalTo(self);
  }];
}

- (UIImageView *)avatarImageView {
  if (!_avatarImageView) {
    _avatarImageView = [UIImageView new];
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = kAvatarWidth / 2;
    _avatarImageView.image = [UIImage imageNamed:@"placeholder_avatar"];
    _tapAvatar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapDidAvatar)];
    [_avatarImageView addGestureRecognizer:_tapAvatar];
  }
  return _avatarImageView;
}

- (UILabel *)displayNameLabel {
  if (!_displayNameLabel) {
    _displayNameLabel = [UILabel new];
    _displayNameLabel.textColor = [UIColor qj_textColorPrimary];
    _displayNameLabel.font = [UIFont systemFontOfSize:18];
    _displayNameLabel.numberOfLines = 1;
    _displayNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  }
  return _displayNameLabel;
}

- (UILabel *)hintLabel {
  if (!_hintLabel) {
    _hintLabel = [UILabel new];
    _hintLabel.textColor = [UIColor qj_textGrayColor];
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.numberOfLines = 1;
    _hintLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _hintLabel.text = @"发布了一个";
  }
  return _hintLabel;
}

- (BFPaperButton *)categoryLabel {
  if (!_categoryLabel) {
    _categoryLabel = [BFPaperButton new];
    _categoryLabel.layer.masksToBounds = YES;
    _categoryLabel.layer.cornerRadius = 5;
    _categoryLabel.shadowColor = [UIColor clearColor];
    [_categoryLabel setTitleFont:[UIFont systemFontOfSize:12]];
    _categoryLabel.contentEdgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    _categoryLabel.backgroundColor = [UIColor qj_accentColor];
    _categoryLabel.userInteractionEnabled = NO; //登录按钮默认不能点击
    [_categoryLabel setTitleColor:[UIColor qj_textColorPrimaryInverse] forState:UIControlStateNormal];
    [_categoryLabel setTitleColor:[UIColor qj_textColorPrimaryInverse] forState:UIControlStateHighlighted];
    [_categoryLabel setTitleColor:[UIColor qj_textColorPrimaryInverse] forState:UIControlStateSelected];
  }
  return _categoryLabel;
}

- (UILabel *)createdAtLabel {
  if (!_createdAtLabel) {
    _createdAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createdAtLabel.text = @"13分钟";
    _createdAtLabel.font = [UIFont boldSystemFontOfSize:14];
    _createdAtLabel.textColor = [UIColor qj_textGrayColor];
  }
  return _createdAtLabel;
}

- (void)configureWithData:(QJPost *)entity {
  _post = entity;
  [self.avatarImageView
      sd_setImageWithURL:[entity.userInfo toURL:kAvatarWidth height:kAvatarWidth]
        placeholderImage:[UIImage imageNamed:@"placeholder_avatar"]];

  [self.categoryLabel setTitle:entity.category.name forState:UIControlStateNormal];
  self.displayNameLabel.text = entity.userInfo.nickname;
  self.createdAtLabel.text = [self updateTimeWithSecend:entity.createdAt.integerValue];
  [super configureWithData:entity];
}

- (NSString *)updateTimeWithSecend:(NSInteger )time {
  NSString *fromPublishedTime = nil;
  NSInteger deltaTime = (NSInteger)[[NSDate date] timeIntervalSince1970] - time;
  NSInteger minites = 60;
  NSInteger hours = minites * 60;
  NSInteger days = hours * 24;
  NSInteger months = days * 30;
  NSInteger years = months * 12;

  if (deltaTime < hours) {
    fromPublishedTime = [NSString stringWithFormat:@"%ld分钟前",deltaTime / minites];
    if (deltaTime / minites < 1)  fromPublishedTime = @"刚刚";
  } else if (deltaTime < days) {
    fromPublishedTime = [NSString stringWithFormat:@"%ld小时前",deltaTime / hours];
  } else if (deltaTime < months) {
    fromPublishedTime = [NSString stringWithFormat:@"%ld天前",deltaTime / days];
  } else if (deltaTime < years) {
    fromPublishedTime = [NSString stringWithFormat:@"%ld月前",deltaTime / months];
  } else {
    fromPublishedTime = [NSString stringWithFormat:@"%ld年前",deltaTime / years];
  }
  return fromPublishedTime;
}

- (void)handleTapDidAvatar {
  if (self.delegate && [self.delegate respondsToSelector:@selector(didAvatarTapped:)]) {
    [self.delegate didAvatarTapped:_post.userInfo];
  }
}
@end