//
// Created by Hammer on 1/31/16.
//

#import "SKHTTPSessionManager.h"
#import "SKErrorResponseModel.h"


@implementation SKHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration {
  if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {

  }
  return self;
}

+ (OVC_NULLABLE Class)errorModelClass {
  return [SKErrorResponseModel class];
}

@end