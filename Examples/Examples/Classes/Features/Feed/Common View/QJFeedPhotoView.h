//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJFeedPhotoView : UIView

@property(nonatomic) NSUInteger maxPhoto;

@property(nonatomic) CGFloat photoWidth;
@property(nonatomic) CGFloat photoHeight;
@property(nonatomic) NSUInteger columns;

@property(nonatomic) CGFloat photoViewLeftMargin;
@property(nonatomic) CGFloat photoViewRightMargin;
@property(nonatomic) CGFloat photoViewBottomMargin;
@property(nonatomic) CGFloat photoViewTopMargin;
@property(nonatomic) CGFloat photoSpace;

- (void)configureWithData:(NSArray *)photoData;

@end