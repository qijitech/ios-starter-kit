//
// Created by Hammer on 1/25/16.
//

#import "SKView.h"

@interface SKView ()
@property(nonatomic, assign) BOOL didSetupConstraints;
@end


@implementation SKView

- (instancetype)init {
  if (self = [super init]) {
    [self setupViews];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupViews];
    }
    return self;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    self.didSetupConstraints = YES;
    [self updateConstraintsInternal];
  }
  [super updateConstraints];
}

//- (void)layoutSubviews {
//  [super layoutSubviews];

  // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
  // need to use to set the preferredMaxLayoutWidth below.
//  [self setNeedsLayout];
//  [self layoutIfNeeded];
//}

// Initialization code
- (void)setupViews {
  // sub class implement
}

- (void)updateConstraintsInternal {
  // sub class implement
}

- (void)configureWithData:(id)entity {
  // Make sure the constraints have been added to this cell, since it may have just been created from scratch
  [self updateConstraintsIfNeeded];
  [self setNeedsUpdateConstraints];
}

@end
