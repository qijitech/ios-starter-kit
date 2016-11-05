//
// Created by 杨玉刚 on 11/5/16.
//

#import "SKPaginator.h"

@interface SKKeyPaginator : SKPaginator
@property(nonatomic, strong) NSPredicate *predicate;
@property(nonatomic, copy) NSString *entityName;
@property(nonatomic, strong) NSArray<NSSortDescriptor *> *sortDescriptors;
@end