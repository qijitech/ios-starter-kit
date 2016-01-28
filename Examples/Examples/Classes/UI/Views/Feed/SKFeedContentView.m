//
// Created by Hammer on 1/27/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKFeedContentView.h"
#import "Feed.h"
#import <Masonry/Masonry.h>

@interface SKFeedContentView ()
@property BOOL didSetupConstraints;
@property UILabel *contentLabel;
@end

@implementation SKFeedContentView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setupViews];
  }
  return self;
}

- (void)setupViews {
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];

  self.contentLabel = [UILabel new];
  self.contentLabel.textColor = [UIColor blackColor];
  self.contentLabel.font = [UIFont systemFontOfSize:16];
  self.contentLabel.numberOfLines = 0;
  self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
  [self addSubview:self.contentLabel];
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {

    self.didSetupConstraints = YES;

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.equalTo(self).with.insets(UIEdgeInsetsMake(0, 10, 10, 10));
      make.bottom.equalTo(self.mas_bottom);
    }];
  }

  [super updateConstraints];
}

- (void)setFeed:(Feed *)feed {
  _feed = feed;
  self.contentLabel.text = feed.content;

  [self updateConstraintsIfNeeded];
  [self setNeedsUpdateConstraints];
}

@end