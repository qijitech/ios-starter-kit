//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QJMobileViewDelegate <NSObject>
@required
- (void)didNextButtonTapped:(NSString *)mobile;
@end

@interface QJLoginMobileView : UIView

@property(nonatomic, weak) id <QJMobileViewDelegate> delegate;

@end