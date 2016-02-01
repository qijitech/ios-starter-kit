//
// Created by Hammer on 1/31/16.
//

#import <PromiseKit/PromiseKit.h>
#import <libextobjc/EXTScope.h>
#import <Overcoat/OVCResponse.h>
#import "SKAccountManager.h"
#import "SKAccountModel.h"

@implementation SKAccountManager

+ (SKAccountManager *)defaultAccountManager {
  static SKAccountManager *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[SKAccountManager alloc] init];
  });
  return _sharedInstance;
}

- (instancetype)init {
  if (self = [super init]) {

  }
  return self;
}

- (AnyPromise *)login:(NSDictionary *)parameters {
  if (self.delegate && [self.delegate respondsToSelector:@selector(login:)]) {
    self.request = YES;
    AnyPromise *promise = [self.delegate login:parameters];
    return [self handleAnyPromise:promise];
  }
  return nil;
}

- (AnyPromise *)register:(NSDictionary *)parameters {
  if (self.delegate && [self.delegate respondsToSelector:@selector(register:)]) {
    self.request = YES;
    AnyPromise *promise = [self.delegate register:parameters];
    return [self handleAnyPromise:promise];
  }
  return nil;
}

- (BOOL)isLoggedIn {
  return NO;
}

- (void)logout {
}

#pragma mark - Private properties

- (AnyPromise *)handleAnyPromise:(AnyPromise *)promise {
  if (promise) {
    @weakify(self);
    return promise.then(^(OVCResponse *response) {
      @strongify(self);
      SKAccountModel *account = response.result;
      if (account) {
        // save account
      }
      return account;
    }).finally(^{
      self.request = NO;
    });
  }
  self.request = NO;
  return nil;
}

@end