//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJUserInfo.h"
#import "QJConfig.h"

@implementation QJUserInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:
      @{
          @"userId" : @"user_id",
          @"nickname" : @"nickname",
          @"avatar" : @"avatar",
          @"wallet" : @"wallet",
          @"gender" : @"gender",
          @"yearOfBirth" : @"year_of_birth",
          @"monthOfBirth" : @"month_of_birth",
          @"dayOfBirth" : @"day_of_birth",
          @"countReport" : @"count_report",
          @"countRead" : @"count_read",
          @"countPost" : @"count_post",
      }];
}

- (NSURL *)toURL:(NSInteger)width height:(NSInteger)height {
  if (!_avatar) {
    return nil;
  }
  if ([_avatar hasPrefix:@"http"]) {
    return [NSURL URLWithString:_avatar];
  }
  NSString *fullUrl = [NSString stringWithFormat:@"%@%@?imageView2/1/w/%ld/h/%ld", kQiNiuBaseURL, _avatar, width, height];
  return [NSURL URLWithString:fullUrl];
}

#pragma mark - NSCoding support

- (void)encodeWithCoder:(NSCoder *)encoder {
  [super encodeWithCoder:encoder];
  [encoder encodeObject:self.userId forKey:@"user_id"];
  [encoder encodeObject:self.nickname forKey:@"nickname"];
  [encoder encodeObject:self.avatar forKey:@"avatar"];
  [encoder encodeObject:self.wallet forKey:@"wallet"];
  [encoder encodeObject:self.gender forKey:@"gender"];
  [encoder encodeObject:self.yearOfBirth forKey:@"year_of_birth"];
  [encoder encodeObject:self.monthOfBirth forKey:@"month_of_birth"];
  [encoder encodeObject:self.dayOfBirth forKey:@"day_of_birth"];
  [encoder encodeObject:self.countReport forKey:@"count_report"];
  [encoder encodeObject:self.countRead forKey:@"count_read"];
  [encoder encodeObject:self.countPost forKey:@"count_post"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
  if (self = [super initWithCoder:decoder]) {
    self.userId = [decoder decodeObjectForKey:@"user_id"];
    self.nickname = [decoder decodeObjectForKey:@"nickname"];
    self.avatar = [decoder decodeObjectForKey:@"avatar"];
    self.wallet = [decoder decodeObjectForKey:@"wallet"];
    self.gender = [decoder decodeObjectForKey:@"gender"];
    self.yearOfBirth = [decoder decodeObjectForKey:@"year_of_birth"];
    self.monthOfBirth = [decoder decodeObjectForKey:@"month_of_birth"];
    self.dayOfBirth = [decoder decodeObjectForKey:@"day_of_birth"];
    self.countReport = [decoder decodeObjectForKey:@"count_report"];
    self.countRead = [decoder decodeObjectForKey:@"count_read"];
    self.countPost = [decoder decodeObjectForKey:@"count_post"];
  }
  return self;
}

@end