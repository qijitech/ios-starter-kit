//
//  QJPageListModel.m
//  Examples
//
//  Created by shuu on 2017/4/10.
//  Copyright © 2017年 奇迹空间. All rights reserved.
//

#import "QJPageListModel.h"

@implementation QJPageListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:
          @{
            @"exchDate" : @"exch_date",
            }];
}

@end
