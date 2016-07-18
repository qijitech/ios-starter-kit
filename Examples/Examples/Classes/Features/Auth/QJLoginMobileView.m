//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <BFPaperButton/BFPaperButton.h>
#import <Masonry/Masonry.h>
#import <HexColors/HexColors.h>
#import "QJMobileTextField.h"
#import "QJLoginMobileView.h"
#import "QJConstants.h"
#import "UIColor+QJ.h"

@interface QJLoginMobileView ()
@property(nonatomic) BOOL didSetupConstraints;
@property(nonatomic, strong) UIImageView *logoImageView;
@property(nonatomic, strong) UILabel *appNameLabel;
@property(nonatomic, strong) UILabel *agreeLabel;
@property(nonatomic, strong) BFPaperButton *declarationButton;
@property(nonatomic, strong) QJMobileTextField *mobileTextField;
@property(nonatomic, strong) BFPaperButton *nextButton;

@end

@implementation QJLoginMobileView

- (instancetype)init {
  if (self = [super init]) {
    [self setupViews];
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)setupViews {
  [self addSubview:self.logoImageView];
  [self addSubview:self.appNameLabel];
  [self addSubview:self.agreeLabel];
  [self addSubview:self.declarationButton];
  [self addSubview:self.mobileTextField];
  [self addSubview:self.nextButton];
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    self.didSetupConstraints = YES;

    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.mas_centerX);
      make.topMargin.mas_equalTo(85);
      make.size.mas_equalTo(CGSizeMake(80, 80));
    }];

    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.mas_centerX);
      make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(12);
    }];

    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.mas_centerX);
      make.width.mas_equalTo(self.declarationButton);
      make.top.mas_equalTo(self.appNameLabel.mas_bottom).offset(12);
    }];

    [self.declarationButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.agreeLabel.mas_right);
      make.width.mas_equalTo(135);
      make.top.mas_equalTo(self.appNameLabel.mas_bottom).offset(12);
      make.height.mas_equalTo(self.agreeLabel);
    }];

    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.mas_centerX);
      make.left.mas_equalTo(self).offset(20);
      make.right.mas_equalTo(self).offset(-20);
      make.top.mas_equalTo(self.declarationButton.mas_bottom).offset(12);
      make.height.mas_equalTo(@(kNextBtnHeight));
    }];

    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.mas_centerX);
      make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(60);
      make.height.mas_equalTo(@(kNextBtnHeight));
      make.width.mas_equalTo(@(kNextBtnWidth));
    }];
  }
  [super updateConstraints];
}

- (UIImageView *)logoImageView {
  if (!_logoImageView) {
    _logoImageView = [UIImageView new];
    _logoImageView.image = [UIImage imageNamed:@"ic_auth_logo.pdf"];
  }
  return _logoImageView;
}

- (UILabel *)appNameLabel {
  if (!_appNameLabel) {
    _appNameLabel = [UILabel new];
    _appNameLabel.text = @"喵喵附近";
    _appNameLabel.textColor = [UIColor hx_colorWithHexString:@"#ec3356"];
    _appNameLabel.textAlignment = NSTextAlignmentCenter;
    _appNameLabel.font = [UIFont boldSystemFontOfSize:24];
  }
  return _appNameLabel;
}

- (UILabel *)agreeLabel {
  if (!_agreeLabel) {
    _agreeLabel = [UILabel new];
    _agreeLabel.font = [UIFont systemFontOfSize:12];
    _agreeLabel.text = @"点击登录，即表示你同意";
    _agreeLabel.textColor = [UIColor lightGrayColor];
    _agreeLabel.textAlignment = NSTextAlignmentRight;
  }
  return _agreeLabel;
}

- (BFPaperButton *)declarationButton {
  if (!_declarationButton) {
    _declarationButton = [[BFPaperButton alloc] init];
    _declarationButton.layer.masksToBounds = YES;
    _declarationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _declarationButton.shadowColor = [UIColor clearColor];
    [_declarationButton setTitleFont:[UIFont systemFontOfSize:12]];
    [_declarationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_declarationButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_declarationButton setTitle:@"《法律声明及隐私政策》" forState:UIControlStateNormal];
  }
  return _declarationButton;
}

- (QJMobileTextField *)mobileTextField {
  if (!_mobileTextField) {
    _mobileTextField = [QJMobileTextField new];
    _mobileTextField.placeholder = @"输入您的手机号";
    UIImageView *icon = [UIImageView new];
    icon.image = [UIImage imageNamed:@"ic_auth_mobile"];
    icon.bounds = CGRectMake(0, 0, 22, 22);
    UIView *lineView = [[UIView alloc] init];
    [_mobileTextField addSubview:lineView];
    lineView.backgroundColor = [UIColor hx_colorWithHexString:@"#DCDCDC"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.equalTo(_mobileTextField.mas_width);
      make.height.equalTo(@1);
      make.left.equalTo(_mobileTextField.mas_left);
      make.bottom.equalTo(_mobileTextField.mas_bottom);
    }];
    _mobileTextField.leftView = icon;
    _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobileTextField.borderStyle = UITextBorderStyleLine;
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_mobileTextField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
  }
  return _mobileTextField;
}

- (BFPaperButton *)nextButton {
  if (!_nextButton) {
    _nextButton = [[BFPaperButton alloc] init];
    _nextButton.layer.masksToBounds = YES;
    _nextButton.layer.cornerRadius = kNextBtnHeight * 0.5;
    _nextButton.shadowColor = [UIColor clearColor];
    [_nextButton setTitleFont:[UIFont systemFontOfSize:17]];
    _nextButton.backgroundColor = [UIColor qj_loginButtonDisableColor];
    _nextButton.enabled = NO; //登录按钮默认不能点击
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextButton setTitle:@"无需注册，快速登录" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(handleTapDidNextButton:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _nextButton;
}

- (void)textValueChanged:(QJMobileTextField *)textField {
  if (textField.text.length > 11) {
    textField.text = [textField.text substringToIndex:11];
  }
  BOOL isDisableLoginButton = textField.text.length == 11;
  self.nextButton.enabled = isDisableLoginButton;
  self.nextButton.backgroundColor = isDisableLoginButton ? [UIColor qj_primaryColor] : [UIColor qj_loginButtonDisableColor];
}

- (void)handleTapDidNextButton:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(didNextButtonTapped:)]) {
    [self.delegate didNextButtonTapped:self.mobileTextField.text];
  }
}
@end