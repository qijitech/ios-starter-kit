//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKAbstractTableViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <libextobjc/EXTScope.h>
#import <HexColors/HexColors.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "SKErrorResponseModel.h"
#import "SKTableViewControllerBuilder.h"
#import "SKLoadMoreTableViewCell.h"
#import "SKLoadMoreEmptyTableViewCell.h"
#import "SKToastUtil.h"
#import "SKNetworkConfig.h"
#import "SKTableViewCell.h"

static CGFloat const kIndicatorViewSize = 40.F;

@interface SKAbstractTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic, strong) DGActivityIndicatorView *indicatorView;

@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, strong) NSMutableArray *cellMetadata;
@property(nonatomic, strong) SKPaginator *paginator;
@property(nonatomic, strong) AnyPromise *(^paginateBlock)(NSDictionary *parameters);

// optional
@property(nonatomic, copy) NSString *cellReuseIdentifier;
@property(nonatomic, copy) TGRDataSourceDequeueReusableCellBlock dequeueReusableCellBlock;
@property(nonatomic, copy) TGRDataSourceCellBlock configureCellBlock;

@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) UIColor *subtitleColor;
@property(nonatomic, strong) UIFont *subtitleFont;

@property(nonatomic, assign) NSUInteger loadMoreHeight;
@property(nonatomic, assign) BOOL canRefresh;
@property(nonatomic, assign) BOOL canLoadMore;
@end

@implementation SKAbstractTableViewController

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

  _modelOfClass = builder.modelOfClass;
  _paginator = builder.paginator;
  _paginator.delegate = self;
  _cellMetadata = [builder.cellMetadata mutableCopy];

  _cellReuseIdentifier = builder.cellReuseIdentifier;
  _dequeueReusableCellBlock = builder.dequeueReusableCellBlock;
  _configureCellBlock = builder.configureCellBlock;

  _titleColor = builder.titleColor;
  _titleFont = builder.titleFont;
  _subtitleColor = builder.subtitleColor;
  _subtitleFont = builder.subtitleFont;

  _canRefresh = builder.canRefresh;
  _canLoadMore = builder.canLoadMore;
  _loadMoreHeight = builder.loadMoreHeight;

  if (_canLoadMore) {
    [self.cellMetadata addObject:[SKLoadMoreTableViewCell class]];
    [self.cellMetadata addObject:[SKLoadMoreEmptyTableViewCell class]];
  }

  // for core data entity name
  if ([_paginator isKindOfClass:[SKKeyPaginator class]]) {
    ((SKKeyPaginator *) _paginator).entityName = builder.entityName;
    ((SKKeyPaginator *) _paginator).sortDescriptors = builder.sortDescriptors;
    ((SKKeyPaginator *) _paginator).predicate = builder.predicate;
  }
  _paginateBlock = builder.paginateBlock;
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

- (void)setupDataSource {
}

- (NSUInteger)numberOfObjectsWithSection:(NSInteger)section {
  return 0;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

- (NSUInteger)numberOfObjects {
  return 0;
}

- (void)cancelAllRequests {
}

- (NSNumber *)lastModelIdentifier:(NSString *)entityName
                        predicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  return nil;
}

- (NSNumber *)firstModelIdentifier:(NSString *)entityName
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray<NSDictionary *> *)sortDescriptors {
  return nil;
}

- (NSString *)buildReusableCellBlock:(NSIndexPath *)indexPath item:(id)item {
  NSUInteger numbers = [self numberOfObjectsWithSection:indexPath.section];
  if (self.canLoadMore && [self numberOfObjects] > self.paginator.pageSize && indexPath.item == numbers - 1) {
    if (self.paginator.hasError || !self.paginator.hasMorePages) {
      return [SKLoadMoreEmptyTableViewCell cellIdentifier];
    } else if (self.paginator.hasMorePages) {
      return [SKLoadMoreTableViewCell cellIdentifier];
    }
  }
  if (self.cellReuseIdentifier) {
    return self.cellReuseIdentifier;
  }
  return self.dequeueReusableCellBlock(item, indexPath);
}

- (void)buildConfigureCellBlock:(SKTableViewCell *)cell item:(id)item {
  if ([cell isKindOfClass:[SKLoadMoreEmptyTableViewCell class]]) {
    SKLoadMoreEmptyTableViewCell *loadMoreEmptyTableViewCell = (SKLoadMoreEmptyTableViewCell *)cell;
    loadMoreEmptyTableViewCell.error = self.paginator.error;
    return;
  }
  self.configureCellBlock(cell, item);
}


- (void)onDataLoaded:(NSArray *)data isRefresh:(BOOL)isRefresh {
}

- (void)registerClassCellReuseIdentifier {
  for (Class clazz in self.cellMetadata) {
    [self.tableView registerClass:clazz
           forCellReuseIdentifier:[clazz cellIdentifier]];
  }
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
      [self numberOfObjects] <= 0) {
    [self showIndicatorView];
    return;
  }
  [self hideIndicatorView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSUInteger numbers = [self numberOfObjectsWithSection:section];
  if (_canLoadMore && [self numberOfObjects] > self.paginator.pageSize) {
    return numbers + 1;
  }
  return numbers;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger numbers = [self numberOfObjectsWithSection:indexPath.section];
  if (_canLoadMore && self.paginator.hasMorePages &&
      [self numberOfObjects] > self.paginator.pageSize && indexPath.item == numbers - 1) {
    [self loadMoreData];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  id item = [self itemAtIndexPath:indexPath];
  if (_canLoadMore && [self numberOfObjects] > self.paginator.pageSize &&
      indexPath.item == ([self numberOfObjectsWithSection:indexPath.section] - 1)) {
    return self.loadMoreHeight;
  }

  NSString *cellIdentifier = self.dequeueReusableCellBlock(item, indexPath);
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
      @strongify(self);
      if (self.paginator.hasError) {
        [self buildNetworkError:self.paginator.error isRefresh:YES];
        return;
      }
      [self onDataLoaded:result isRefresh:YES];
      if (!result || result.count <= 0) {
        [SKToastUtil toastWithText:@"没有最新数据"];
      }
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
      if (self.paginator.hasError) {
        [self buildNetworkError:self.paginator.error isRefresh:YES];
        return;
      }
      [self onDataLoaded:result isRefresh:NO];
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
      if (self.paginator.hasError) {
        [self.tableView reloadData];
        [self buildNetworkError:self.paginator.error isRefresh:NO];
        return;
      }
      [self onDataLoaded:result isRefresh:NO];
      if (!result || result.count <= 0) {
        [self.tableView reloadData];
        [SKToastUtil toastWithText:@"没有更多数据"];
      }
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

#pragma mark - Empty Methods

NSString *const kStarterKitEmptyTitle = @"Nothing Here";
NSString *const kStarterKitEmptySubtitle = @"We couldn't find anything. Tap the button to take your first image";
NSString *const kStarterKitErrorTitle = @"No Connection";
NSString *const kStarterKitErrorSubtitle = @"We could not establish a connection with our servers. Please try again when you are connected to the internet.";

- (NSString *)emptyImage {
  if (self.paginator.hasError) {
    return @"Frameworks/StarterKit.framework/StarterKit.bundle/ic_starter_network_error";
  }
  return @"Frameworks/StarterKit.framework/StarterKit.bundle/ic_starter_empty";
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