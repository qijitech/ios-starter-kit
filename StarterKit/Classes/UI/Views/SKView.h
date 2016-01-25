//
// Created by Hammer on 1/25/16.
//

#import <UIKit/UIKit.h>
#import <Overcoat/OVCUtilities.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKView
OVCGenerics(Model) : UIView

- (void)updateConstraintsInternal;

- (void)setupViews;

- (void)configureWithData:(OVC_NULLABLE OVCGenericType(Model, id))entity;

@end

NS_ASSUME_NONNULL_END