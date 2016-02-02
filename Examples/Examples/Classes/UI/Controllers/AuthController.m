//
// Created by Hammer on 1/31/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKNetworkConfig.h>
#import <StarterKit/SKAccountManager.h>
#import "AuthController.h"

#import "SKHTTPSessionManager+Auth.h"
#import "User.h"

@interface AuthController () <SKAccountManagerDelegate>
@property(nonatomic, strong) SKHTTPSessionManager *sessionManager;
@end

@implementation AuthController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.sessionManager = [[SKHTTPSessionManager alloc] initWithBaseURL:[SKNetworkConfig sharedInstance].baseUrl];

  NSDictionary *parameters = @{@"phone" : @"18612184602", @"password" : @"123456"};
  SKAccountManager *accountManager = [SKAccountManager defaultAccountManager];  
  accountManager.delegate = self;
  [accountManager login:parameters].then(^(User *user) {
    NSLog(@"%@", user);
  }).catch(^(NSError *error) {
    NSLog(@"=====%@", error);
  }).finally(^{
    NSLog(@"=====finally");
  });
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.sessionManager invalidateSessionCancelingTasks:YES];
  _sessionManager = nil;
}

- (AnyPromise *)login:(NSDictionary *)parameters {
  return [self.sessionManager login:parameters];
}


@end