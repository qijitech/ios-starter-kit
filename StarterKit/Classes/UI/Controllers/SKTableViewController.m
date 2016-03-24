//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKTableViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <libextobjc/EXTScope.h>
#import <HexColors/HexColors.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "SKTableViewCell.h"
#import "SKErrorResponseModel.h"
#import "SKFetchedResultsDataSource.h"
#import "SKFetchedResultsDataSourceBuilder.h"
#import "SKTableViewControllerBuilder.h"
#import "SKManaged.h"
#import "SKLoadMoreTableViewCell.h"
#import "SKToastUtil.h"

static CGFloat const kIndicatorViewSize = 40.F;
#define kShowHideAnimateDuration 0.2

@interface SKTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic, strong) DGActivityIndicatorView *indicatorView;

@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, strong) NSMutableArray *cellMetadata;
@property(nonatomic, strong) SKPaginator *paginator;
@property(nonatomic, strong) AnyPromise *(^paginateBlock)(NSDictionary *parameters);

// optional
@property(nonatomic, copy) NSString *cellReuseIdentifier;
@property(nonatomic, copy) TGRDataSourceDequeueReusableCellBlock dequeueReusableCellBlock;
@property(nonatomic, copy) TGRDataSourceCellBlock configureCellBlock;
@property(nonatomic, copy) NSPredicate *predicate;

@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) UIColor *subtitleColor;
@property(nonatomic, strong) UIFont *subtitleFont;

@property(nonatomic, assign) BOOL canRefresh;
@property(nonatomic, assign) BOOL canLoadMore;
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

  NSParameterAssert(builder.configureCellBlock);

  _entityName = builder.entityName;
  _modelOfClass = builder.modelOfClass;
  _paginator = builder.paginator;
  _paginator.delegate = self;
  _cellMetadata = [builder.cellMetadata mutableCopy];

  [self.cellMetadata addObject:[SKLoadMoreTableViewCell class]];
    
  _predicate = builder.predicate;
  
  _cellReuseIdentifier = builder.cellReuseIdentifier;
  _dequeueReusableCellBlock = builder.dequeueReusableCellBlock;
  _configureCellBlock = builder.configureCellBlock;

  _titleColor = builder.titleColor;
  _subtitleColor = builder.subtitleColor;

  _canRefresh = builder.canRefresh;
  _canLoadMore = builder.canLoadMore;

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

  if (self.refreshControl && self.refreshControl.isRefreshing) {
    [self updateView:YES];
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
  self.tableView.backgroundColor = [UIColor clearColor];

  [self registerClassCellReuseIdentifier];

  [self setupDataSource];

  if (_canRefresh) {
    [self setupRefreshControl];
  }
}

- (void)registerClassCellReuseIdentifier {
  for (Class clazz in self.cellMetadata) {
    [self.tableView registerClass:clazz
           forCellReuseIdentifier:[clazz cellIdentifier]];
  }
}

- (void)setupDataSource {
  @weakify(self);
  self.dataSource = [SKFetchedResultsDataSource createWithBuilder:^(SKFetchedResultsDataSourceBuilder *builder) {
    @strongify(self);
    builder.modelOfClass = [self modelOfClass];
    builder.entityName = [self entityName];
    builder.predicate = [self predicate];
    builder.dequeueReusableCellBlock = ^NSString *(id item, NSIndexPath *indexPath) {
      NSUInteger numbers = [self numberOfObjects:indexPath];
      if (self.canLoadMore && self.paginator.hasMorePages && indexPath.item == numbers - 1) {
        return [SKLoadMoreTableViewCell cellIdentifier];
      }
      if (self.cellReuseIdentifier) {
        return self.cellReuseIdentifier;
      }
      return self.dequeueReusableCellBlock(item, indexPath);
    };
    builder.configureCellBlock = self.configureCellBlock;
  }];
}

- (void)setupRefreshControl {
  self.refreshControl = [UIRefreshControl new];
  self.refreshControl.backgroundColor = [UIColor clearColor];
  [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - IndicatorView Methods

- (void)setupIndicatorView {
  self.indicatorView = [[DGActivityIndicatorView alloc]
                        initWithType:DGActivityIndicatorAnimationTypeBallScale
                           tintColor:[UIColor redColor]
                                size:kIndicatorViewSize];
  [self.view addSubview:self.indicatorView];
  [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self.view);
  }];
}

- (void)showIndicatorView {
  [self setupIndicatorView];
  [self.indicatorView startAnimating];
  [self.tableView reloadEmptyDataSet];
}

- (void)hideIndicatorView {
  if (_indicatorView) {
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    _indicatorView = nil;
  }
}

- (void)shouldShowIndicatorView {
  if (self.paginator.isRefresh &&
      !self.paginator.hasDataLoaded &&
      [self.dataSource.fetchedResultsController.fetchedObjects count] <= 0) {
    [self showIndicatorView];
    return;
  }
  [self hideIndicatorView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSUInteger numbers = [self numberOfObjectsWithSection:section];
  if (_canLoadMore && self.paginator.hasMorePages) {
    return numbers + 1;
  }
  return numbers;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  id<NSFetchedResultsSectionInfo> sectionInfo = self.dataSource.fetchedResultsController.sections[indexPath.section];
  NSUInteger numbers = [sectionInfo numberOfObjects];
  if (_canLoadMore && self.paginator.hasMorePages && indexPath.item == numbers - 1) {
    [self loadMoreData];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  id item = [self.dataSource itemAtIndexPath:indexPath];
  NSString *cellIdentifier = self.dequeueReusableCellBlock(item, indexPath);
  if (_canLoadMore && self.paginator.hasMorePages) {
    NSUInteger numbers = [self numberOfObjects:indexPath];
    if (indexPath.item == numbers - 1) {
      return 80;
    }
  }
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
    [self shouldShowIndicatorView];
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
        [SKToastUtil toastWithText:@"没有最新数据"];
      }
    }).catch(^(NSError *error) {
      @strongify(self);
      [self buildNetworkError:error isRefresh:YES];
    }).finally(^{
      @strongify(self);
      [self updateView:YES];
    });
    return;
  }
  [self updateView:YES];
}

- (void)loadData {
  AnyPromise *promise = [self.paginator refresh];
  if (promise) {
    @weakify(self);
    promise.then(^(NSArray *result) {
      // Left Blank
    }).catch(^(NSError *error) {
      @strongify(self);
      [self buildNetworkError:error isRefresh:NO];
    }).finally(^{
      @strongify(self);
      [self updateView:NO];
    });
    return;
  }
  [self updateView:NO];
}

- (void)loadMoreData {
  AnyPromise *promise = [self.paginator loadMore];
  if (promise) {
    @weakify(self);
    promise.then(^(NSArray *result) {
      if (!result || result.count <= 0) {
        [SKToastUtil toastWithText:@"没有更多数据"];
      }
    }).catch(^(NSError *error) {
      @strongify(self);
      [self buildNetworkError:error isRefresh:NO];
    }).finally(^{
      @strongify(self);
      [self updateView:NO];
    });
    return;
  }
  [self updateView:NO];
}

- (void)updateView:(BOOL)isRefresh {
  if (isRefresh && _canRefresh) {
    [self.refreshControl endRefreshing];
  }
  self.paginator.loading = NO;
  self.paginator.refresh = NO;
  [self.tableView reloadEmptyDataSet];
  [self shouldShowIndicatorView];
}

- (void)buildNetworkError:(NSError *)error isRefresh:(BOOL)isRefresh {
  [SKToastUtil toastWithText:[SKErrorResponseModel buildMessageWithNetworkError:error]];
}

- (NSUInteger)numberOfObjects:(NSIndexPath *)indexPath {
  id<NSFetchedResultsSectionInfo> sectionInfo = self.dataSource.fetchedResultsController.sections[indexPath.section];
  return [sectionInfo numberOfObjects];
}

- (NSUInteger)numberOfObjectsWithSection:(NSInteger )section {
  id<NSFetchedResultsSectionInfo> sectionInfo = self.dataSource.fetchedResultsController.sections[section];
  return [sectionInfo numberOfObjects];
}

#pragma mark - Empty Methods

NSString * const kStarterKitEmptyTitle = @"Nothing Here";
NSString * const kStarterKitEmptySubtitle = @"We couldn't find anything. Tap the button to take your first image";
NSString * const kStarterKitErrorTitle = @"No Connection";
NSString * const kStarterKitErrorSubtitle = @"We could not establish a connection with our servers. Please try again when you are connected to the internet.";

- (NSString *)emptyImage {
  if (self.paginator.hasError) {
    return  @"Frameworks/StarterKit.framework/StarterKit.bundle/ic_starter_network_error";
  }
  return  @"Frameworks/StarterKit.framework/StarterKit.bundle/ic_starter_empty";
}

- (NSString *)emptyTitle {
  return self.paginator.hasError ? kStarterKitErrorTitle : kStarterKitEmptyTitle;
}

- (NSString *)emptySubtitle {
  return self.paginator.hasError ? kStarterKitErrorSubtitle : kStarterKitEmptySubtitle;
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
  NSMutableDictionary *attributes = [NSMutableDictionary new];
  NSString *text = [self emptyTitle];
  UIFont *font = self.titleFont ? self.titleFont : [UIFont boldSystemFontOfSize:17.0];
  UIColor *textColor = self.titleColor ? self.titleColor : [UIColor hx_colorWithHexString:@"545454"];
  if (font) [attributes setObject:font forKey:NSFontAttributeName];
  if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
  return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
  NSString *text = self.emptySubtitle;
  UIFont *font = self.subtitleFont ? self.subtitleFont : [UIFont boldSystemFontOfSize:15.0];
  UIColor *textColor = self.subtitleColor ? self.subtitleColor : [UIColor hx_colorWithHexString:@"545454"];
  NSMutableDictionary *attributes = [NSMutableDictionary new];
  NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
  paragraph.lineBreakMode = NSLineBreakByWordWrapping;
  paragraph.alignment = NSTextAlignmentCenter;
  if (font) [attributes setObject:font forKey:NSFontAttributeName];
  if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
  if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
  return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
  return [UIImage imageNamed:self.emptyImage];
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
  return NO;
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