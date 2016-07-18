//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "QJFeedPhotoView.h"

#define kPhotoPickerScreenWidth [UIScreen mainScreen].bounds.size.width

static NSUInteger const kMaxPhoto = 9;
static CGFloat const kPhotoViewLeftMargin = 10;
static CGFloat const kPhotoViewRightMargin = 10;
static CGFloat const kPhotoViewTopMargin = 10;
static CGFloat const kPhotoViewBottomMargin = 10;

static CGFloat const kPhotoSpace = 5;
static NSUInteger const kPhotoColumns = 3;

@interface QJFeedPhotoView ()

@property(nonatomic) BOOL didSetupConstraints;
@property(nonatomic, strong) NSArray *imageViews;

@end

@implementation QJFeedPhotoView

- (instancetype)init {
  if (self = [super init]) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
  _maxPhoto = kMaxPhoto;
  _photoViewLeftMargin = kPhotoViewLeftMargin;
  _photoViewRightMargin = kPhotoViewRightMargin;
  _photoViewTopMargin = kPhotoViewTopMargin;
  _photoViewBottomMargin = kPhotoViewBottomMargin;
  _photoSpace = kPhotoSpace;
  _columns = kPhotoColumns;
  [self initializeImageViews];
  [self setupViews];
}

- (void)initializeImageViews {
  NSMutableArray *localImageViews = [[NSMutableArray alloc] initWithCapacity:self.maxPhoto];
  for (NSUInteger index = 0; index < self.maxPhoto; ++index) {
    UIImageView *imageView = [UIImageView new];
    imageView.hidden = YES;
    imageView.userInteractionEnabled = YES;
    localImageViews[index] = imageView;
  }
  _imageViews = [NSArray arrayWithArray:localImageViews];
}

- (void)setMaxPhotoPicker:(NSUInteger)maxPhotoPicker {
  if (_maxPhoto != maxPhotoPicker) {
    _maxPhoto = maxPhotoPicker;
    [self initializeImageViews];
  }
}

- (CGFloat)photoWidth {
  if (_photoWidth <= 0) {
    _photoWidth = (kPhotoPickerScreenWidth - _photoViewLeftMargin - _photoViewRightMargin - (_columns - 1) * _photoSpace) / _columns;
  }
  return _photoWidth;
}

- (CGFloat)photoHeight {
  if (_photoHeight <= 0) {
    _photoHeight = self.photoWidth;
  }
  return _photoHeight;
}

- (void)updateConstraints {
  NSArray *subviews = self.subviews;
  NSUInteger count = [subviews count];

  if (!self.didSetupConstraints && count > 0) {
    self.didSetupConstraints = YES;
    NSUInteger localColumn = self.columns;
    NSUInteger rows = count % localColumn == 0 ? count / localColumn : (count / localColumn + 1);
    CGFloat localSpace = self.photoSpace;
    CGFloat itemW = self.photoWidth;
    CGFloat itemH = self.photoHeight;

    @weakify(self);
    [subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *_Nonnull stop) {
      NSUInteger columnIndex = idx % localColumn;
      NSUInteger rowIndex = idx / localColumn;
      [obj mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.mas_equalTo(self.photoViewLeftMargin + columnIndex * (localSpace + itemW));
        make.top.mas_equalTo(self.photoViewTopMargin + rowIndex * (localSpace + itemH));
        make.width.mas_equalTo(itemW);
        make.height.mas_equalTo(itemH);

        if (rowIndex == rows - 1) {
          make.bottom.mas_equalTo(-self.photoViewBottomMargin);
        }

      }];
    }];
  }
  [super updateConstraints];
}

// Initialization code
- (void)setupViews {
  // sub class implement
//  self.backgroundColor = [UIColor whiteColor];
}

- (void)configureWithData:(NSArray *)photoData {
  for (UIView *view in self.subviews) {
    [view removeFromSuperview];
  }

  _didSetupConstraints = NO;

  @weakify(self);
  [photoData enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL *stop) {
    @strongify(self)
    if (idx >= self.maxPhoto) {
      *stop = YES;
      return;
    }
    UIImageView *imageView = self.imageViews[idx];
    imageView.hidden = NO;
    [imageView sd_setImageWithURL:obj
                 placeholderImage:[UIImage imageNamed:@"placeholder_feeds_thumb"]];
    [self addSubview:imageView];
  }];

  // Make sure the constraints have been added to this cell, since it may have just been created from scratch
  [self updateConstraintsIfNeeded];
  [self setNeedsUpdateConstraints];
}

@end