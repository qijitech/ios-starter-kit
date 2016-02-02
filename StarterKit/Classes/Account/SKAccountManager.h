//
// Created by Hammer on 1/31/16.
//

#import <Foundation/Foundation.h>

@class AnyPromise;
@class SKAccountModel;

@protocol SKAccountManagerDelegate <NSObject>
@optional
- (AnyPromise *)login:(NSDictionary *)parameters;
- (AnyPromise *)register:(NSDictionary *)parameters;
@end

@interface SKAccountManager : NSObject

@property(nonatomic, weak) id <SKAccountManagerDelegate> delegate;
@property(nonatomic, assign, getter=isRequesting) BOOL request;
@property (nonatomic, strong, readonly) SKAccountModel *currentAccount;

+ (SKAccountManager *)defaultAccountManager;

- (AnyPromise *)login:(NSDictionary *)parameters;

- (AnyPromise *)register:(NSDictionary *)parameters;

- (BOOL)updateAccount:(SKAccountModel *)accountModel;

- (BOOL)isLoggedIn;

- (BOOL)logout;

@end