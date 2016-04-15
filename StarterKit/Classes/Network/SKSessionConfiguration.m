//
// Created by Hammer on 2/2/16.
//

#import "SKSessionConfiguration.h"
#import "SKAccountManager.h"
#import "SKNetworkConfig.h"

@implementation SKSessionConfiguration

+ (NSDictionary *)commonHeader {
  return @{
      @"Content-Encoding" : @"gzip",
      @"version-code" : [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleVersionKey],
      @"version-name" : [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleVersionKey],
      @"device" : @"device", // 待定
      @"platform" : @"iOS",
      @"channel" : @"channel", // 待定
  };
}

- (NSURLSessionConfiguration *)defaultSessionConfiguration {
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSDictionary *headers = [[self class] commonHeader];
  NSMutableDictionary *mutableDictionary = [headers mutableCopy];

  if ([SKNetworkConfig sharedInstance].accept) {
    mutableDictionary[@"Accept"] = [SKNetworkConfig sharedInstance].accept;
  }

  SKAccountManager *manager = [SKAccountManager defaultAccountManager];
  if ([manager isLoggedIn]) {
    mutableDictionary[@"Authorization"] = [NSString stringWithFormat:@"Bearer %@", manager.token];
  } else {
    mutableDictionary[@"Authorization"] = nil;
  }
  [configuration setHTTPAdditionalHeaders:[mutableDictionary copy]];
  return configuration;
}

@end