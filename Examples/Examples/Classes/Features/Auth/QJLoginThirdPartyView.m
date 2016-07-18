//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJLoginThirdPartyView.h"
#import <BFPaperButton/BFPaperButton.h>
#import <HexColors/HexColors.h>
#import <Masonry/Masonry.h>

@interface QJLoginThirdPartyView ()
@property(nonatomic, assign) BOOL didSetupConstraints;
@property(strong, nonatomic) UIView *leftDividerView;
@property(strong, nonatomic) UIView *rightDividerView;
@property(strong, nonatomic) UILabel *textLabel;
@property(strong, nonatomic) BFPaperButton *qqBtn;
@property(strong, nonatomic) BFPaperButton *wechatBtn;
@property(strong, nonatomic) BFPaperButton *weiboBtn;
@end

@implementation QJLoginThirdPartyView

- (instancetype)init {
  if (self = [super init]) {
    [self setupViews];
    self.backgroundColor = [UIColor hx_colorWithHexString:@"#fafafa"];
  }
  return self;
}

- (void)setupViews {
  [self addSubview:self.leftDividerView];
  [self addSubview:self.textLabel];
  [self addSubview:self.rightDividerView];
  [self addSubview:self.qqBtn];
  [self addSubview:self.wechatBtn];
  [self addSubview:self.weiboBtn];
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    self.didSetupConstraints = YES;

    [self.leftDividerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.textLabel.mas_left);
      make.centerY.mas_equalTo(self.textLabel);
      make.left.mas_equalTo(self).offset(40);
      make.height.equalTo(@(1));
    }];

    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.mas_centerX);
      make.top.equalTo(self).with.offset(30);
      make.height.mas_equalTo(20);
    }];

    [self.rightDividerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.textLabel.mas_right);
      make.centerY.mas_equalTo(self.textLabel);
      make.right.mas_equalTo(self).offset(-40);
      make.height.equalTo(@(1));
    }];

    [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.wechatBtn.mas_left);
      make.left.equalTo(self);
      make.centerY.mas_equalTo(self.wechatBtn);
      make.width.equalTo(self.weiboBtn);
    }];

    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.weiboBtn.mas_left);
      make.centerX.mas_equalTo(self.mas_centerX);
      make.top.mas_equalTo(self.textLabel.mas_bottom);
      make.bottom.equalTo(self);
    }];

    [self.weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self);
      make.centerY.mas_equalTo(self.wechatBtn);
    }];
  }
  [super updateConstraints];
}

- (UIView *)leftDividerView {
  if (!_leftDividerView) {
    _leftDividerView = [UIView new];
    _leftDividerView.backgroundColor = [UIColor hx_colorWithHexString:@"#e5e5e5"];
  }
  return _leftDividerView;
}

- (UIView *)rightDividerView {
  if (!_rightDividerView) {
    _rightDividerView = [UIView new];
    _rightDividerView.backgroundColor = [UIColor hx_colorWithHexString:@"#e5e5e5"];
  }
  return _rightDividerView;
}

- (UILabel *)textLabel {
  if (!_textLabel) {
    _textLabel = [UILabel new];
    _textLabel.text = @"其他账号登录";
    _textLabel.textColor = [UIColor hx_colorWithHexString:@"#a8a8a8"];
    _textLabel.textAlignment = NSTextAlignmentCenter;
  }
  return _textLabel;
}

- (BFPaperButton *)qqBtn {
  if (!_qqBtn) {
    _qqBtn = [self setRoundBFPaperButtonWithImageName:@"ic_auth_qq" radius:55.5 / 2];
    [_qqBtn addTarget:self action:@selector(handleTapOnQqButton) forControlEvents:UIControlEventTouchUpInside];
  }
  return _qqBtn;
}

- (BFPaperButton *)wechatBtn {
  if (!_wechatBtn) {
    _wechatBtn = [self setRoundBFPaperButtonWithImageName:@"ic_auth_weixin" radius:55.5 / 2];
    [_wechatBtn addTarget:self action:@selector(handleTapOnWechatButton) forControlEvents:UIControlEventTouchUpInside];
  }
  return _wechatBtn;
}

- (BFPaperButton *)weiboBtn {
  if (!_weiboBtn) {
    _weiboBtn = [self setRoundBFPaperButtonWithImageName:@"ic_auth_weibo" radius:55.5 / 2];
    [_weiboBtn addTarget:self action:@selector(handleTapOnWeiboButton) forControlEvents:UIControlEventTouchUpInside];
  }
  return _weiboBtn;
}

- (BFPaperButton *)setRoundBFPaperButtonWithImageName:(NSString *)imageName radius:(CGFloat)radius {
  BFPaperButton *button = [[BFPaperButton alloc] initWithRaised:NO];
  button.usesSmartColor = YES;
  [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
  button.contentMode = UIViewContentModeCenter;
  button.cornerRadius = radius;
  button.rippleFromTapLocation = NO;
  button.rippleBeyondBounds = YES;
  button.tapCircleDiameter = radius * 2 * 1.3;
  button.tapCircleBurstAmount = radius * 2 * 1.3;
  return button;
}

- (void)handleTapOnQqButton {
  if (self.delegate && [self.delegate respondsToSelector:@selector(onQQButtonTapped)]) {
    [self.delegate onQQButtonTapped];
  }
}

- (void)handleTapOnWechatButton {
  if (self.delegate && [self.delegate respondsToSelector:@selector(onWechatButtonTapped)]) {
    [self.delegate onWechatButtonTapped];
  }
}

- (void)handleTapOnWeiboButton {
  if (self.delegate && [self.delegate respondsToSelector:@selector(onWeiboButtonTapped)]) {
    [self.delegate onWeiboButtonTapped];
  }
}

@end