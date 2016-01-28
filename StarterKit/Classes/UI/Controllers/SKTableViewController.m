//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <UzysAnimatedGifPullToRefresh/UIScrollView+UzysAnimatedGifPullToRefresh.h>
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
#import <UzysAnimatedGifLoadMore/UIScrollView+UzysAnimatedGifLoadMore.h>
#import <Toast/UIView+Toast.h>
#import <HexColors/HexColors.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "SKManaged.h"

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)

@interface SKTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic, strong) AMTumblrHud *shimmerHUD;

@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) Class modelOfClass;
@property(nonatomic, strong) NSArray *cellMetadata;
@property(nonatomic, strong) SKPaginator *paginator;
@property(nonatomic, strong) AnyPromise *(^paginateBlock)(NSDictionary *parameters);
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

  _entityName = builder.entityName;
  _modelOfClass = builder.modelOfClass;
  _paginator = builder.paginator;
  _paginator.delegate = self;
  _cellMetadata = builder.cellMetadata;

  // for core data entity name
  if ([_paginator isKindOfClass:[SKKeyPaginator class]]) {
    ((SKKeyPaginator *) _paginator).entityName = builder.entityName;
  }
  _paginateBlock = builder.paginateBlock;
  _httpSessionManager = [[SKManagedHTTPSessionManager alloc]
      initWithManagedObjectContext:[SKManaged sharedInstance].managedObjectContext];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView triggerPullToRefresh];
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

  for (Class clazz in self.cellMetadata) {
    [self.tableView registerClass:clazz
           forCellReuseIdentifier:[clazz cellIdentifier]];
  }

  self.tableView.backgroundColor = [UIColor clearColor];

  self.tableView.emptyDataSetSource = self;
  self.tableView.emptyDataSetDelegate = self;

  @weakify(self);
  self.dataSource = [SKFetchedResultsDataSource createWithBuilder:^(SKFetchedResultsDataSourceBuilder *builder) {
    @strongify(self);
    builder.modelOfClass = [self modelOfClass];
    builder.entityName = [self entityName];
    builder.dequeueReusableCellBlock = ^NSString *(id item) {
      return [self cellIdentifier:item];
    };
    builder.configureCellBlock = ^(SKTableViewCell *cell, id item) {
      [cell configureCellWithData:item];
    };
  }];

  [self.tableView addLoadMoreActionHandler:^{
        @strongify(self);
        [self loadMoreData];
      } ProgressImagesGifName:@"Frameworks/StarterKit.framework/StarterKit.bundle/spinner_dropbox@2x.gif"
                      LoadingImagesGifName:@"Frameworks/StarterKit.framework/StarterKit.bundle/Preloader_10@2x.gif"
                   ProgressScrollThreshold:60];

  [self.tableView addPullToRefreshActionHandler:^{
        @strongify(self);
        [self refreshData];
      } ProgressImagesGifName:@"Frameworks/StarterKit.framework/StarterKit.bundle/spinner_dropbox@2x.gif"
                           LoadingImagesGifName:@"Frameworks/StarterKit.framework/StarterKit.bundle/Preloader_10@2x.gif"
                        ProgressScrollThreshold:60
  ];


  // If you did not change scrollview inset, you don't need code below.
  if (IS_IOS7) {
    [self.tableView addTopInsetInPortrait:64 TopInsetInLandscape:52];
  } else if (IS_IOS8) {
    CGFloat landscapeTopInset = 32.0;
    if (IS_IPHONE6PLUS) {
      landscapeTopInset = 44.0;
    }
    [self.tableView addTopInsetInPortrait:64 TopInsetInLandscape:landscapeTopInset];
  }
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

- (void)shoudShowShimmerHUD {
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
  @weakify(self);
  return [tableView fd_heightForCellWithIdentifier:[self cellIdentifier:item]
                                  cacheByIndexPath:indexPath
                                     configuration:^(SKTableViewCell *cell) {
    // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
    @strongify(self);
    [cell configureCellWithData:item];
  }];
}

- (NSString *)cellIdentifier:(id)data {
  for (Class clazz in self.cellMetadata) {
    return [clazz cellIdentifier];
  }
}

# pragma mark - SKPaginatorDelegate

- (void)networkOnStart:(BOOL)isRefresh {
  if (isRefresh) {
    [self shoudShowShimmerHUD];
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
    promise.catch(^(NSError *error) {
      [self setupNetworkError:error isRefresh:YES];
    }).finally(^{
      [self endRefresh];
    });
    return;
  }
  self.paginator.loading = NO;
  self.paginator.refresh = NO;
  [self endRefresh];
}

- (void)endRefresh {
  [self.tableView stopPullToRefreshAnimation];
  [self.tableView reloadEmptyDataSet];
  [self shoudShowShimmerHUD];
}

- (void)loadMoreData {
  AnyPromise *promise = [self.paginator loadMore];
  if (promise) {
    @weakify(self);
    promise.catch(^(NSError *error) {
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
  OVCResponse *response = userInfo[@"OVCResponse"];
  SKErrorResponseModel *errorModel = response.result;
  [self.navigationController.view makeToast:errorModel.message];
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