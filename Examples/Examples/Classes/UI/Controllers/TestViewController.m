//
// Created by Hammer on 1/27/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "TestViewController.h"
#import "SKPictureView.h"
#import "Image.h"
#import <Masonry/Masonry.h>

@interface TestViewController ()
@property(nonatomic, strong) SKPictureView *pictureView;
@end

@implementation TestViewController

- (instancetype)init {
  self = [super init];

  if (self) {
    self.pictureView = [[SKPictureView alloc] initWithFrame:CGRectZero];
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  NSMutableArray *temp = [NSMutableArray new];
  Image *image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];

  image = [Image new];
  image.url = [NSURL URLWithString:@"http://lorempixel.com/200/300/?36691"];
  [temp addObject:image];


  [self.view addSubview:self.pictureView];

  self.pictureView.data = [temp copy];

  [self.view setNeedsUpdateConstraints];
}

#pragma mark UIContentContainer protocol methods

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  // make constraints
  [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(100);
    make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(10, 10, 10, 10));
  }];
}

- (void)updateViewConstraints {
  [super updateViewConstraints];
}


@end