//
// Created by 杨玉刚 on 3/24/16.
//

#import "SKArrayDataSource.h"
#import "SKArrayDataSourceBuilder.h"

@interface SKArrayDataSource()
@property (copy, nonatomic) NSMutableArray *data;
@end

@implementation SKArrayDataSource


+ (instancetype)createWithBuilder:(SKArrayDataSourceBuilderBlock)block {
  NSParameterAssert(block);
  SKArrayDataSourceBuilder *builder = [[SKArrayDataSourceBuilder alloc] init];
  block(builder);
  return [builder build];
}

- (instancetype)initWithBuilder:(SKArrayDataSourceBuilder *)builder {
  NSParameterAssert(builder);
  NSParameterAssert(builder.dequeueReusableCellBlock);
  NSParameterAssert(builder.configureCellBlock);

  _data = [NSMutableArray new];
  if (self = [super initWithItems:_data dequeueReusableCellBlock:builder.dequeueReusableCellBlock
               configureCellBlock:builder.configureCellBlock]) {
  }
  return self;
}

- (void)addItems:(NSArray *)data isRefresh:(BOOL)isRefresh {
  if (isRefresh && data && data.count > 0) {
    [self.data removeAllObjects];
  }
  [self.data addObjectsFromArray:data];
  [self updateData:self.data];
}

@end