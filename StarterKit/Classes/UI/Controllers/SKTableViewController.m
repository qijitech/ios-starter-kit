//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "SKTableViewController.h"
#import "AMTumblrHud.h"
#import "SKTableViewCell.h"
#import "SKErrorResponseModel.h"
#import "SKFetchedResultsDataSource.h"
#import "SKFetchedResultsDataSourceBuilder.h"
#import "SKTableViewControllerBuilder.h"
#import <libextobjc/EXTScope.h>
#import <Overcoat/OVCResponse.h>
#import "UIScrollView+UzysAnimatedGifLoadMore.h"
#import <HexColors/HexColors.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "SKManaged.h"
#import <RKDropdownAlert/RKDropdownAlert.h>

@interface SKTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic, strong) AMTumblrHud *shimmerHUD;

@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, strong) NSArray *cellMetadata;
@property(nonatomic, strong) SKPaginator *paginator;
@property(nonatomic, strong) AnyPromise *(^paginateBlock)(NSDictionary *parameters);

// optional
@property(nonatomic, copy) TGRDataSourceDequeueReusableCellBlock dequeueReusableCellBlock;
@property(nonatomic, copy) TGRDataSourceCellBlock configureCellBlock;
@property(nonatomic, copy) NSPredicate *predicate;

@end

@implementation SKTableViewController

- (void)createWithBuilder:(SKTableViewControllerBuilderBlock)block {
  NSParameterAssert(block);
  SKTableViewControllerBuilder *builder = [[SKTableViewControllerBuilder alloc] init];
  block(builder);
  [self initWithBuilder:builder];
}

- (void)initWithBuilder:(SKTableViewControllerBuilder *)builder {
  NSParameterAssert(builder);
  NSParameterAssert(builder.entityName);
  NSParameterAssert(builder.modelOfClass);
  NSParameterAssert(builder.cellMetadata);
  NSParameterAssert(builder.paginator);

  NSParameterAssert(builder.dequeueReusableCellBlock);
  NSParameterAssert(builder.configureCellBlock);

  _entityName = builder.entityName;
  _modelOfClass = builder.modelOfClass;
  _paginator = builder.paginator;
  _paginator.delegate = self;
  _cellMetadata = builder.cellMetadata;
  _predicate = builder.predicate;

  _dequeueReusableCellBlock = builder.dequeueReusableCellBlock;
  _configureCellBlock = builder.configureCellBlock;

  // for core data entity name
  if ([_paginator isKindOfClass:[SKKeyPaginator class]]) {
    ((SKKeyPaginator *) _paginator).entityName = builder.entityName;
  }

  _paginateBlock = builder.paginateBlock;
  _httpSessionManager = [[SKManagedHTTPSessionManager alloc] initWithManagedObjectContext:[SKManaged sharedInstance].managedObjectContext];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self loadData];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  if ([self isMovingFromParentViewController]) {
    [self cancelAllRequests];
  }
}

- (void)cancelAllRequests {
  [self.httpSessionManager invalidateSessionCancelingTasks:YES];
  _httpSessionManager = nil;
}

- (void)setupTableView {
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.emptyDataSetSource = self;
  self.tableView.emptyDataSetDelegate = self;

  for (Class clazz in self.cellMetadata) {
    [self.tableView registerClass:clazz
           forCellReuseIdentifier:[clazz cellIdentifier]];
  }

  self.tableView.backgroundColor = [UIColor clearColor];
  [self setupDataSource];
  [self setupRefreshControl];
  [self setupLoadMore];
}

- (void)setupDataSource {
  @weakify(self);
  self.dataSource = [SKFetchedResultsDataSource createWithBuilder:^(SKFetchedResultsDataSourceBuilder *builder) {
    @strongify(self);
    builder.modelOfClass = [self modelOfClass];
    builder.entityName = [self entityName];
    builder.predicate = [self predicate];
    builder.dequeueReusableCellBlock = self.dequeueReusableCellBlock;
    builder.configureCellBlock = self.configureCellBlock;
  }];
}

- (void)setupLoadMore {
  @weakify(self);
  [self.tableView addLoadMoreActionHandler:^{
        @strongify(self);
        [self loadMoreData];
      } ProgressImagesGifName:@"Frameworks/StarterKit.framework/StarterKit.bundle/spinner_dropbox@2x.gif"
                      LoadingImagesGifName:@"Frameworks/StarterKit.framework/StarterKit.bundle/Preloader_10@2x.gif"
                   ProgressScrollThreshold:60];
}

- (void)setupRefreshControl {
  self.refreshControl = [UIRefreshControl new];
  self.refreshControl.backgroundColor = [UIColor clearColor];
  [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

- (void)setupShimmerHUD {
  AMTumblrHud *shimmerHUD = [[AMTumblrHud alloc] initWithFrame:CGRectZero];
  shimmerHUD.hudColor = [UIColor redColor];
  [self.view addSubview:shimmerHUD];
  [shimmerHUD mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self.view);
    make.size.mas_equalTo(CGSizeMake(55, 20));
  }];
  self.shimmerHUD = shimmerHUD;
}

- (void)showShimmerHUD {
  [self setupShimmerHUD];
  [self.shimmerHUD showAnimated:YES];
  [self.tableView reloadEmptyDataSet];
}

- (void)hideShimmerHUD {
  if (_shimmerHUD) {
    [self.shimmerHUD hide];
    _shimmerHUD = nil;
  }
}

- (void)shouldShowShimmerHUD {
  if (self.paginator.isRefresh &&
      !self.paginator.hasDataLoaded &&
      [self.dataSource.fetchedResultsController.fetchedObjects count] <= 0) {
    [self showShimmerHUD];
    return;
  }
  [self hideShimmerHUD];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  id item = [self.dataSource itemAtIndexPath:indexPath];
  NSString *cellIdentifier = self.dequeueReusableCellBlock(item);
  // @weakify(self);
  return [tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath
    configuration:^(SKTableViewCell *cell) {
      // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
      // @strongify(self);
      [cell configureCellWithData:item];
  }];
}


# pragma mark - SKPaginatorDelegate

- (void)networkOnStart:(BOOL)isRefresh {
  if (isRefresh) {
    [self shouldShowShimmerHUD];
  }
}

- (AnyPromise *)paginate:(NSDictionary *)parameters {
  if (self.paginateBlock) {
    return self.paginateBlock(parameters);
  }
  return nil;
}

#pragma mark - Load data

- (void)refreshData {
  AnyPromise *promise = [self.paginator refresh];
  if (promise) {
    @weakify(self);
    promise.then(^(NSArray *result) {
      if (!result || result.count <= 0) {
        [RKDropdownAlert title:@"" message:@"没有最新数据"];
      }
    }).catch(^(NSError *error) {
      @strongify(self);
      [self setupNetworkError:error isRefresh:YES];
    }).finally(^{
      @strongify(self);
      [self endRefresh];
    });
    return;
  }
  self.paginator.loading = NO;
  self.paginator.refresh = NO;
  [self.tableView reloadEmptyDataSet];
  [self shouldShowShimmerHUD];
}

- (void)endRefresh {
  [self.refreshControl endRefreshing];
  [self.tableView reloadEmptyDataSet];
  [self shouldShowShimmerHUD];
}

- (void)loadData {
  AnyPromise *promise = [self.paginator refresh];
  if (promise) {
    @weakify(self);
    promise.then(^(NSArray *result) {
      // Left Blank
    }).catch(^(NSError *error) {
      @strongify(self);
      [self setupNetworkError:error isRefresh:NO];
    }).finally(^{
      @strongify(self);
      [self.tableView reloadEmptyDataSet];
      [self shouldShowShimmerHUD];
    });
    return;
  }
  self.paginator.loading = NO;
  self.paginator.refresh = NO;
  [self.tableView reloadEmptyDataSet];
  [self shouldShowShimmerHUD];
}

- (void)loadMoreData {
  AnyPromise *promise = [self.paginator loadMore];
  if (promise) {
    @weakify(self);
    promise.then(^(NSArray *result) {
      if (!result || result.count <= 0) {
        [RKDropdownAlert title:@"" message:@"没有更多数据"];
      }
    }).catch(^(NSError *error) {
      @strongify(self);
      [self setupNetworkError:error isRefresh:NO];
    }).finally(^{
      @strongify(self);
      [self.tableView stopLoadMoreAnimation];
    });
    return;
  }
}

- (void)setupNetworkError:(NSError *)error isRefresh:(BOOL)isRefresh {
  NSDictionary *userInfo = [error userInfo];
  if (userInfo[@"NSUnderlyingError"]) {
    [RKDropdownAlert title:@"" message:userInfo[@"NSLocalizedDescription"]];
    return;
  }
  OVCResponse *response = userInfo[@"OVCResponse"];
  SKErrorResponseModel *errorModel = response.result;
  [RKDropdownAlert title:@"" message:errorModel.message];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
  NSMutableDictionary *attributes = [NSMutableDictionary new];

  NSString *text = nil;
  UIFont *font = nil;
  UIColor *textColor = nil;

  text = @"No Photos";
  font = [UIFont boldSystemFontOfSize:17.0];
  textColor = [UIColor hx_colorWithHexString:@"545454"];

  if (!text) {
    return nil;
  }

  if (font) [attributes setObject:font forKey:NSFontAttributeName];
  if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];

  return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
  NSString *text = nil;
  UIFont *font = nil;
  UIColor *textColor = nil;

  NSMutableDictionary *attributes = [NSMutableDictionary new];

  NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
  paragraph.lineBreakMode = NSLineBreakByWordWrapping;
  paragraph.alignment = NSTextAlignmentCenter;

  text = @"Get started by uploading a photo.";
  font = [UIFont boldSystemFontOfSize:15.0];
  textColor = [UIColor hx_colorWithHexString:@"545454"];

  if (!text) {
    return nil;
  }

  if (font) [attributes setObject:font forKey:NSFontAttributeName];
  if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
  if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];

  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];

  return attributedString;

}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  NSString *imageName = @"Frameworks/StarterKit.framework/StarterKit.bundle/placeholder";

  return [UIImage imageNamed:imageName];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
  animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
  animation.duration = 0.25;
  animation.cumulative = YES;
  animation.repeatCount = MAXFLOAT;

  return animation;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
  NSString *text = nil;
  UIFont *font = nil;
  UIColor *textColor = nil;

  if (!text) {
    return nil;
  }

  NSMutableDictionary *attributes = [NSMutableDictionary new];
  if (font) [attributes setObject:font forKey:NSFontAttributeName];
  if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];

  return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
  NSString *imageName = @"Frameworks/StarterKit.framework/StarterKit.bundle/button_background_kickstarter";

  if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
  if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];

  UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
  UIEdgeInsets rectInsets = UIEdgeInsetsZero;

  return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
  return 0.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
  return 9.0;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
  return !self.paginator.isLoading;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
  return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
  return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
  return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
  [self refreshData];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
  [self refreshData];
}


@end