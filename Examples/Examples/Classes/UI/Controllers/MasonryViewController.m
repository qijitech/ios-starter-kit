//
// Created by Hammer on 1/25/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <MMPlaceHolder/MMPlaceHolder.h>
#import "MasonryViewController.h"


@implementation MasonryViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UIView *sv = [UIView new];
  [sv showPlaceHolder];
  sv.backgroundColor = [UIColor blackColor];
  [self.view addSubview:sv];
  [sv mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
    make.size.mas_equalTo(CGSizeMake(360, 300));
  }];


  UIView *sv11 = [UIView new];
  UIView *sv12 = [UIView new];
  UIView *sv13 = [UIView new];
  UIView *sv21 = [UIView new];
  UIView *sv31 = [UIView new];

  sv11.backgroundColor = [UIColor redColor];
  sv12.backgroundColor = [UIColor redColor];
  sv13.backgroundColor = [UIColor redColor];
  sv21.backgroundColor = [UIColor redColor];
  sv31.backgroundColor = [UIColor redColor];

  [sv addSubview:sv11];
  [sv addSubview:sv12];
  [sv addSubview:sv13];
  [sv addSubview:sv21];
  [sv addSubview:sv31];

  //给予不同的大小 测试效果

  [sv11 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(@[sv12,sv13]);
    make.centerX.equalTo(@[sv21,sv31]);
    make.size.mas_equalTo(CGSizeMake(40, 40));
  }];

  [sv12 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(70, 20));
  }];

  [sv13 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(50, 50));
  }];

  [sv21 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(50, 20));
  }];

  [sv31 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(40, 60));
  }];

  [sv distributeSpacingHorizontallyWith:@[sv11,sv12,sv13]];
  [sv distributeSpacingVerticallyWith:@[sv11,sv21,sv31]];

  [sv showPlaceHolderWithAllSubviews];
  [sv hidePlaceHolder];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  // make constraints
}

- (void)updateViewConstraints {
  [super updateViewConstraints];
}

@end