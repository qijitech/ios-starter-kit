//
//  SKPageListTableViewController.m
//  Pods
//
//  Created by shuu on 2017/4/10.
//
//

#import "SKPageListTableViewController.h"
#import "SKTableViewControllerBuilder.h"
#import "SKPagedListPaginator.h"

@implementation SKPageListTableViewController

- (void)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  builder.paginator = [[SKPagedListPaginator alloc] init];
  builder.canRefresh = YES;
  builder.canLoadMore = YES;
  block(builder);
  [self initWithBuilder:builder];
}



@end
