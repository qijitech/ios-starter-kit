//
// Created by Hammer on 12/3/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+SKRefreshControl.h"

static const void *kSKRefreshControlKey = @"qijitech.SKRefreshControlKey";

@interface UITableView ()
@property(nonatomic, copy) SKRefreshControlPullRefresh pullToRefresh;
@end

@implementation UITableView (SKRefreshControl)

- (UIRefreshControl *)sk_refreshControl {
  UIRefreshControl *control = objc_getAssociatedObject(self, &kSKRefreshControlKey);

  if (control == nil) {
    control = [[UIRefreshControl alloc] init];
    control.tintColor = [UIColor grayColor];
    [self addSubview:control];
    objc_setAssociatedObject(self, &kSKRefreshControlKey, control, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }

  return control;
}

- (SKRefreshControlPullRefresh)pullToRefresh {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setPullToRefresh:(SKRefreshControlPullRefresh)pullToRefresh {
  objc_setAssociatedObject(self, @selector(pullToRefresh), pullToRefresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - init

- (void)sk_addPullToRefresh:(SKRefreshControlPullRefresh)pullRefresh
       andInfiniteToRefresh:(SKRefreshControlInfiniteRefresh)infiniteRefresh {
  if (pullRefresh) {
    self.pullToRefresh = pullRefresh;
    [self.sk_refreshControl addTarget:self
                               action:@selector(refresh:)
                     forControlEvents:UIControlEventValueChanged];
  }

  if (infiniteRefresh) {
    [self addInfiniteScrollingWithActionHandler:infiniteRefresh];
  }
}

- (void)refresh:(UIRefreshControl *)control {
  if (!control.isRefreshing) {
    [control beginRefreshing];
  }
  self.pullToRefresh();
}

#pragma mark - 刷新结束

- (void)endRefresh {
  if (self.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
    [self.infiniteScrollingView stopAnimating];
    [self.infiniteScrollingView resetScrollViewContentInset];
    self.infiniteScrollingView.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self.infiniteScrollingView setScrollViewContentInsetForInfiniteScrolling];
      self.infiniteScrollingView.enabled = YES;
    });
  } else {
    if (self.sk_refreshControl.isRefreshing) {
      [self.sk_refreshControl endRefreshing];
    }
  }
}


- (void)beginPullRefresh {
  [self refresh:self.sk_refreshControl];
}

- (void)beginInfiniteRefresh {
  [self triggerInfiniteScrolling];
}

@end
