//
// Created by Hammer on 3/6/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "SKLoadMoreTableViewCell.h"
#import <Masonry/Masonry.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

static CGFloat const kIndicatorViewSize = 40.F;
static CGFloat const kIndicatorViewMargin = 40.F;

@interface SKLoadMoreTableViewCell ()
@property(nonatomic, strong) DGActivityIndicatorView *indicatorView;

@property BOOL didSetupConstraints;
@end

@implementation SKLoadMoreTableViewCell

- (void)setupViews {
  self.indicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallBeat
                                                           tintColor:[UIColor redColor]
                                                                size:kIndicatorViewSize];
  [self.contentView addSubview:self.indicatorView];
}

+ (NSString *)cellIdentifier {
  static NSString *const kCellIdentifier = @"SKLoadMoreTableViewCell";
  return kCellIdentifier;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {

    self.didSetupConstraints = YES;

    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(kIndicatorViewSize, kIndicatorViewSize));
      make.centerX.equalTo(self.contentView.mas_centerX).offset(kIndicatorViewSize/2);
      make.bottom.equalTo(self.contentView.mas_bottom);
      make.topMargin.mas_equalTo(kIndicatorViewMargin);
      make.bottom.mas_equalTo(kIndicatorViewMargin);

    }];
  }

  [super updateConstraints];
}

- (void)configureCellWithData:(id)entity {
  [self.indicatorView startAnimating];
  [super configureCellWithData:entity];
}


@end