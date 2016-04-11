//
// Created by Hammer on 2/2/16.
//

#import <Foundation/Foundation.h>


@interface SKSessionConfiguration : NSObject

+ (NSURLSessionConfiguration *)defaultSessionConfiguration;

+ (NSURLSessionConfiguration *)updateSessionConfigurationWithToken:(NSString *)token;

@end