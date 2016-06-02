//
// Created by Hammer on 1/31/16.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/AnyPromise.h>

@class SKAccountModel;

@protocol SKAccountManagerDelegate <NSObject>
@optional
// 登录
- (AnyPromise *)signin:(NSDictionary *)parameters;

// 注册
- (AnyPromise *)signup:(NSDictionary *)parameters;
@end

@interface SKAccountManager : NSObject

@property(nonatomic, weak) id <SKAccountManagerDelegate> delegate;
@property(nonatomic, assign, getter=isRequesting) BOOL request;
@property (nonatomic, strong, readonly) SKAccountModel *currentAccount;

+ (SKAccountManager *)defaultAccountManager;

// 登录
- (AnyPromise *)signin:(NSDictionary *)parameters;

// 注册
- (AnyPromise *)signup:(NSDictionary *)parameters;

- (BOOL)updateAccount:(SKAccountModel *)accountModel;

- (BOOL)isLoggedIn;

- (BOOL)logout;

- (NSString *)token;

@end