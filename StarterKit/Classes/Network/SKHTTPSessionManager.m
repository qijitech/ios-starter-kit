//
// Created by Hammer on 1/31/16.
//

#import "SKHTTPSessionManager.h"
#import "SKErrorResponseModel.h"
#import "SKSessionConfiguration.h"

@implementation SKHTTPSessionManager

- (instancetype)initWithBaseURL:(NSString *)url {

  if (self = [super initWithBaseURL:[NSURL URLWithString:url]
               sessionConfiguration:[SKSessionConfiguration defaultSessionConfiguration]]) {

  }
  return self;
}

+ (OVC_NULLABLE Class)errorModelClass {
  return [SKErrorResponseModel class];
}

@end