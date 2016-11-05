//
// Created by 杨玉刚 on 3/24/16.
//

#import "SKKeyTableViewController.h"
#import "SKTableViewControllerBuilder.h"
#import "SKKeyPaginator.h"

@implementation SKKeyTableViewController

- (void)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  builder.paginator = [[SKKeyPaginator alloc] init];
  builder.canRefresh = YES;
  builder.canLoadMore = YES;
  block(builder);
  [self initWithBuilder:builder];
}

@end