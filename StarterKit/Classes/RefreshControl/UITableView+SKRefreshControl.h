//
// Created by Hammer on 12/3/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+SVInfiniteScrolling.h"

typedef void(^SKRefreshControlPullRefresh)();

typedef void(^SKRefreshControlInfiniteRefresh)();

@interface UITableView (SKRefreshControl)

- (void)sk_addPullToRefresh:(SKRefreshControlPullRefresh)pullRefresh
       andInfiniteToRefresh:(SKRefreshControlInfiniteRefresh)infiniteRefresh;

// 刷新结束，停止动画
- (void)endRefresh;

// 触发下拉刷新动作
- (void)beginPullRefresh;

// 触发加载更多动作
- (void)beginInfiniteRefresh;

@end