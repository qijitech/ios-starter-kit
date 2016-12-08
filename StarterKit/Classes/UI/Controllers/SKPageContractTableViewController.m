//
//  SKPageContractTableViewController.m
//
//  Created by shuu on 2016/12/5.
//

#import "SKPageContractTableViewController.h"
#import "SKTableViewControllerBuilder.h"
#import "SKPagedContractPaginator.h"
#import "SKPaginatorContractModel.h"

@interface SKPageContractTableViewController ()

@end

@implementation SKPageContractTableViewController

- (void)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  builder.paginator = [[SKPagedContractPaginator alloc] init];
  builder.canRefresh = YES;
  builder.canLoadMore = YES;
  block(builder);
  [self initWithBuilder:builder];
}

- (SKPaginatorContractModel *)contractModel {
  SKPagedContractPaginator *pagedContractPaginator = (SKPagedContractPaginator *)self.paginator;
  SKPaginatorContractModel *contractModel = pagedContractPaginator.contractData;
  NSString *propertyName = pagedContractPaginator.resultKeyValue;
  if (pagedContractPaginator.subResultKeyValue) {
    propertyName = [pagedContractPaginator.subResultKeyValue stringByAppendingString:propertyName];
  }
  NSString *codeModelPropertyName = [propertyName substringFromIndex:1];
  NSString *firstPropertyNameChar = [[propertyName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
  propertyName = [NSString stringWithFormat:@"set%@%@:", firstPropertyNameChar, codeModelPropertyName];
  SEL selectedItem = NSSelectorFromString(propertyName);
  IMP imp = [contractModel methodForSelector:selectedItem];
  void (*setter)(id, SEL, id);
  setter = (void (*)(id, SEL, id))imp;
  if (setter) {
    setter(contractModel, selectedItem, self.items.copy);
  }
  return contractModel;
}

@end
