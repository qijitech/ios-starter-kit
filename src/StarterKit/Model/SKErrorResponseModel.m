//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKErrorResponseModel.h"


@implementation SKErrorResponseModel

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
      @"statusCode" : @"status_code",
      @"message" : @"message",
  };
}

@end