//
// Created by Hammer on 2/2/16.
//

#import "SKSessionConfiguration.h"
#import "SKAccountManager.h"
#import "SKNetworkConfig.h"


@implementation SKSessionConfiguration

+ (NSURLSessionConfiguration *)defaultSessionConfiguration {
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

  NSString *token = [SKAccountManager defaultAccountManager].token;
  NSString *Authorization = [NSString stringWithFormat:@"Bearer %@", token];
  NSDictionary *HTTPAdditionalHeaders = @{
      @"Content-Encoding" : @"gzip",
      @"version-code" : [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
      @"version-name" : [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey],
      @"device" : @"device", // 待定
      @"platform" : @"iOS",
      @"channel" : @"channel", // 待定
      @"Authorization" : Authorization,
      @"Accept" : [SKNetworkConfig sharedInstance].accept,
  };
  [configuration setHTTPAdditionalHeaders:HTTPAdditionalHeaders];

  return configuration;
}


@end