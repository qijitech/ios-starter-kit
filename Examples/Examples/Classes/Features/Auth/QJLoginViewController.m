//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJLoginViewController.h"

#import <StarterKit/SKHTTPSessionManager.h>
#import <StarterKit/SKAccountManager.h>
#import <HexColors/HexColors.h>
#import <Masonry/Masonry.h>
#import "QJLoginMobileView.h"
#import "QJLoginThirdPartyView.h"
#import "QJHTTPSessionManager.h"

@interface QJLoginViewController () <QJMobileViewDelegate, QJLoginThirdPartyViewDelegate, SKAccountManagerDelegate>
@property(nonatomic) BOOL didSetupConstraints;
@property(nonatomic, strong) SKHTTPSessionManager *sessionManager;
@property(nonatomic, strong) QJLoginMobileView *mobileView;
@property(nonatomic, strong) QJLoginThirdPartyView *thirdPartyView;
@property(nonatomic, strong) NSString *currentMobile;
@property(nonatomic, getter=isThirdPartyLogin) BOOL thirdPartyLogin;

@end

@implementation QJLoginViewController

#pragma mark - initialization

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor hx_colorWithHexString:@"#fafafa"];
  [self setupViews];
  [self.view updateConstraintsIfNeeded];
  [self.view setNeedsUpdateConstraints];
}

- (void)setupViews {
  [self.view addSubview:self.mobileView];
  [self.view addSubview:self.thirdPartyView];
}

- (void)updateViewConstraints {
  if (!self.didSetupConstraints) {
    self.didSetupConstraints = YES;
    UIView *superView = self.view;
    [self.mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(superView);
      make.leading.mas_equalTo(superView.mas_leading);
      make.trailing.mas_equalTo(superView.mas_trailing);
      make.bottom.mas_equalTo(self.thirdPartyView.mas_top);
      make.height.equalTo(self.thirdPartyView).multipliedBy(2.5);
    }];

    [self.thirdPartyView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.mobileView.mas_bottom);
      make.leading.mas_equalTo(superView.mas_leading);
      make.trailing.mas_equalTo(superView.mas_trailing);
      make.bottom.mas_equalTo(self.mas_bottomLayoutGuideBottom);
    }];
  }
  [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

#pragma mark - private API

#pragma mark - QJMobileViewDelegate

- (void)didNextButtonTapped:(NSString *)mobile {
  // TODO
}

#pragma mark - QJLoginThirdPartyViewDelegate

- (void)onQQButtonTapped {
  // TODO
}

- (void)onWechatButtonTapped {
  // TODO
}

- (void)onWeiboButtonTapped {
  // TODO
}

- (AnyPromise *)signin:(NSDictionary *)parameters {
  // TODO
  return nil;
}

#pragma mark - lazyload

- (QJLoginMobileView *)mobileView {
  if (!_mobileView) {
    _mobileView = [QJLoginMobileView new];
    _mobileView.delegate = self;
  }
  return _mobileView;
}

- (QJLoginThirdPartyView *)thirdPartyView {
  if (!_thirdPartyView) {
    _thirdPartyView = [QJLoginThirdPartyView new];
    _thirdPartyView.delegate = self;
  }
  return _thirdPartyView;
}

- (SKHTTPSessionManager *)sessionManager {
  if (!_sessionManager) _sessionManager = [QJHTTPSessionManager defaultSessionManager];
  return _sessionManager;
}

@end