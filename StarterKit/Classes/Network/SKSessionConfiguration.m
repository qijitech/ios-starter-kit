//
// Created by Hammer on 2/2/16.
//

#import "SKSessionConfiguration.h"
#import "SKAccountManager.h"
#import "SKNetworkConfig.h"
#import "SKLocalizableUtils.h"
#import "UIDevice+SKDeviceModel.h"

@implementation SKSessionConfiguration

+ (NSDictionary *)commonHeader {
  return @{
      @"Content-Encoding" : @"gzip",
      @"X-Client-Build" : [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleVersionKey],
      @"X-Client-Version" : [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleVersionKey],
      @"X-Client" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
      @"X-Client-Type" : @"iOS",
      @"X-Client-Channel" : @"channel", // 待定
      @"X-Language-Code" : [SKLocalizableUtils getPreferredLanguagesString],
      @"X-Client-System" : [NSString stringWithFormat:@"%.1f", [[[UIDevice currentDevice] systemVersion] floatValue]],
      @"X-Client-Model" : [[UIDevice currentDevice] deviceModel],
  };
}

+ (NSURLSessionConfiguration *)defaultSessionConfiguration {
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
