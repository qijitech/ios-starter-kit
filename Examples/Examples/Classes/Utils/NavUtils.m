//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "NavUtils.h"
#import "QJLoginViewController.h"


@implementation NavUtils

+ (void)navLoginCtrl:(UINavigationController *)controller {
  QJLoginViewController *loginCtrl = [QJLoginViewController new];
  [controller pushViewController:loginCtrl animated:YES];
}

@end