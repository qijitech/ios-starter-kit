//
// Created by Hammer on 1/31/16.
//

#import "SKHTTPSessionManager.h"
#import "SKErrorResponseModel.h"
#import "SKSessionConfiguration.h"
#import "SKNetworkConfig.h"

@implementation SKHTTPSessionManager

- (instancetype)init {

  if (self = [super initWithBaseURL:[NSURL URLWithString:[SKNetworkConfig sharedInstance].baseUrl]
               sessionConfiguration:[[SKSessionConfiguration new] defaultSessionConfiguration]]) {

  }
  return self;
}

+ (OVC_NULLABLE Class)errorModelClass {
  return [SKErrorResponseModel class];
}

@end