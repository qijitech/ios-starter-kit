//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJView.h"

@class QJPost;
@class QJUserInfo;

@protocol QJFeedUserViewDelegate <NSObject>
@required
- (void)didAvatarTapped:(QJUserInfo *)userInfo;
@end

@interface QJFeedUserView : QJView

@property(nonatomic, strong) QJPost *post;

@property(nonatomic, weak) id <QJFeedUserViewDelegate> delegate;

@end