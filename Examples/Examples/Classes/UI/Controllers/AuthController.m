//
// Created by Hammer on 1/31/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKNetworkConfig.h>
#import "AuthController.h"

#import "SKHTTPSessionManager+Auth.h"

@interface AuthController ()
@property(nonatomic, strong) SKHTTPSessionManager *sessionManager;
@end

@implementation AuthController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.sessionManager = [[SKHTTPSessionManager alloc] initWithBaseURL:
      [NSURL URLWithString:[SKNetworkConfig sharedInstance].baseUrl]];

  NSDictionary *parameters = @{@"phone": @"18612184602", @"password":@"123456"};
  [self.sessionManager login:parameters].then(^(OVCResponse *response) {
    NSLog(@"=====%@", response);
  }).catch (^(NSError *error) {
    NSLog(@"=====%@", error);
  }) .finally (^ {
    NSLog(@"=====finally");
  });
}

@end