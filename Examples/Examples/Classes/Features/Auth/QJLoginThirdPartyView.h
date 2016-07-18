//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QJLoginThirdPartyViewDelegate <NSObject>
@required
- (void)onQQButtonTapped;

- (void)onWechatButtonTapped;

- (void)onWeiboButtonTapped;
@end

@interface QJLoginThirdPartyView : UIView

@property(nonatomic, weak) id <QJLoginThirdPartyViewDelegate> delegate;

@end