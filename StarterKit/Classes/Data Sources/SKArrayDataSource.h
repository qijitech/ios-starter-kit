//
// Created by 杨玉刚 on 3/24/16.
//

#import <Foundation/Foundation.h>
#import <TGRDataSource_qijitech/TGRArrayDataSource.h>

@class SKArrayDataSourceBuilder;

typedef void (^SKArrayDataSourceBuilderBlock)(SKArrayDataSourceBuilder *builder);

@interface SKArrayDataSource : TGRArrayDataSource

+ (instancetype)createWithBuilder:(SKArrayDataSourceBuilderBlock)block;
- (instancetype)initWithBuilder:(SKArrayDataSourceBuilder *)builder;

- (void)addItems:(NSArray *)data isRefresh:(BOOL)isRefresh;

@end