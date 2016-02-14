//
// Created by Hammer on 1/19/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKTableViewControllerBuilder.h"
#import "SKTableViewCell.h"
#import <libextobjc/EXTScope.h>

@implementation SKTableViewControllerBuilder

- (TGRDataSourceDequeueReusableCellBlock)dequeueReusableCellBlock {
  if (!_dequeueReusableCellBlock) {
    @weakify(self);
    _dequeueReusableCellBlock = ^NSString *(id item) {
      @strongify(self);
      Class clazz = self.cellMetadata[0];
      return [clazz cellIdentifier];
    };
  }
  return _dequeueReusableCellBlock;
}

- (TGRDataSourceCellBlock)configureCellBlock {
  if (!_configureCellBlock) {
    _configureCellBlock = ^(SKTableViewCell *cell, id item) {
      [cell configureCellWithData:item];
    };
  }
  return _configureCellBlock;
}

@end