//
// Created by Hammer on 1/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKManagedHTTPSessionManager.h"
#import "SKNetworkConfig.h"
#import "SkErrorResponseModel.h"

@implementation SKManagedHTTPSessionManager

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
  if (self = [super initWithBaseURL:[NSURL URLWithString:[SKNetworkConfig sharedInstance].baseUrl]
               managedObjectContext:context
               sessionConfiguration:NULL]) {

  }
  return self;
}

+ (OVC_NULLABLE Class)errorModelClass {
  return [SKErrorResponseModel class];
}

@end