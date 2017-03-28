//
// Created by Hammer on 1/31/16.
//

#import <libextobjc/EXTScope.h>
#import <Overcoat/OVCResponse.h>
#import "SKAccountManager.h"
#import "SKAccountModel.h"

static NSString *kAccountDefaultsKey = @"Account";

@interface SKAccountManager ()
@property(nonatomic, strong) SKAccountModel *currentAccount;
@end

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
    _currentAccount = [self restoreAccount];
  }
  return self;
}

- (AnyPromise *)signin:(NSDictionary *)parameters {
  if (self.delegate && [self.delegate respondsToSelector:@selector(signin:)]) {
    self.request = YES;
    AnyPromise *promise = [self.delegate signin:parameters];
    return [self handleAnyPromise:promise];
  }
  return nil;
}

- (AnyPromise *)signup:(NSDictionary *)parameters {
  if (self.delegate && [self.delegate respondsToSelector:@selector(signup:)]) {
    self.request = YES;
    AnyPromise *promise = [self.delegate signup:parameters];
    return [self handleAnyPromise:promise];
  }
  return nil;
}

- (BOOL)updateAccount:(SKAccountModel *)accountModel {
  return [self storeAccount:accountModel];
}

- (BOOL)isLoggedIn {
  if (self.currentAccount) {
    return self.currentAccount.token != nil;
  }
  return NO;
}

- (BOOL)logout {
  _currentAccount = nil;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:kAccountDefaultsKey];
  return [defaults synchronize];
}

- (NSString *)token {
  if (![self isLoggedIn]) return nil;
  return [self currentAccount].token;
}

- (SKAccountModel *)currentAccount {
  if (!_currentAccount) {
    _currentAccount = [self restoreAccount];
  }
  return _currentAccount;
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
        [self storeAccount:account];
      }
      return account;
    }).always(^{
      self.request = NO;
    });
  }
  self.request = NO;
  return nil;
}

- (SKAccountModel *)restoreAccount {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *data = [defaults objectForKey:kAccountDefaultsKey];
  return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (BOOL)storeAccount:(SKAccountModel *)accountModel {
  _currentAccount = accountModel;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accountModel];
  [defaults setObject:data forKey:kAccountDefaultsKey];
  return [defaults synchronize];
}

@end
