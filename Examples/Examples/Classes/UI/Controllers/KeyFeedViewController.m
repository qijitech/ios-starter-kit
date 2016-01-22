//
// Created by Hammer on 1/22/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <StarterKit/SKTableViewControllerBuilder.h>
#import <StarterKit/SKManaged.h>
#import "KeyFeedViewController.h"
#import "FeedTableViewCell.h"
#import "Feed.h"
#import "Network.h"

@interface KeyFeedViewController ()

@end

@implementation KeyFeedViewController

- (id)init {
  return [[self class] createWithBuilder:^(SKTableViewControllerBuilder *builder) {
    builder.cellClass = [FeedTableViewCell class];
    builder.cellIdentifier = [FeedTableViewCell cellIdentifier];
    builder.entityName = @"Feed";
    SKManaged *managed = [SKManaged sharedInstance];
    builder.httpSessionManager = [[Network alloc] initWithManagedObjectContext:managed.managedObjectContext];
    builder.modelOfClass = [Feed class];
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end