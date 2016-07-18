//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "QJFeedContentView.h"
#import "QJPost.h"

@interface QJFeedContentView ()

@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, getter=isBlankContent) BOOL blankContent;

@end

@implementation QJFeedContentView

- (void)setupViews {
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  self.contentLabel = [UILabel new];
  self.contentLabel.textColor = [UIColor blackColor];
  self.contentLabel.font = [UIFont systemFontOfSize:16];
  self.contentLabel.numberOfLines = 0;
  self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
  [self addSubview:self.contentLabel];
}

- (void)updateConstraintsInternal {
  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.and.right.equalTo(self);
    make.top.and.bottom.equalTo(self);
    if (!self.isBlankContent) {
      make.height.greaterThanOrEqualTo(@(18));
    }
  }];
}

- (void)configureWithData:(QJPost *)entity {
  _post = entity;
  self.contentLabel.text = entity.content;
  self.blankContent = !entity.content.length;
  [super configureWithData:entity];
}

@end