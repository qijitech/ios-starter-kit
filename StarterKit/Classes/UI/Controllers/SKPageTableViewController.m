//
// Created by 杨玉刚 on 3/24/16.
//

#import "SKPageTableViewController.h"
#import "SKTableViewControllerBuilder.h"
#import "SKPagedPaginator.h"

@implementation SKPageTableViewController

- (void)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  builder.paginator = [[SKPagedPaginator alloc] init];
  builder.canRefresh = YES;
  builder.canLoadMore = YES;
  block(builder);
  [self initWithBuilder:builder];
}

@end