//
// Created by Hammer on 1/27/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "SKPictureView.h"
#import "Image.h"

static CGFloat const kSpace = 4;
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SKPictureView ()
@property(nonatomic, strong) NSArray *imageViews;
@end

@implementation SKPictureView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setupViews];
  }
  return self;
}

- (void)setupViews {
}

- (void)updateConstraints {
  NSUInteger column = [self column:self.imageViews];
  CGFloat itemW = [self itemWidth];
  CGFloat itemH = [self itemHeight];

  [self.imageViews enumerateObjectsUsingBlock:^(UIImageView *_Nonnull imageView, NSUInteger idx, BOOL *_Nonnull stop) {
    NSUInteger columnIndex = idx % column;
    NSUInteger rowIndex = idx / column;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(@(rowIndex * (kSpace + itemH)));
      make.left.mas_equalTo(@(columnIndex * (kSpace + itemW)));
      make.width.mas_equalTo(@(itemW));
      make.height.mas_equalTo(@(itemH));
    }];
  }];
  [super updateConstraints];
}

- (void)setData:(NSArray *)data {
  _data = data;
  for (UIView *view in self.subviews) {
    [view removeFromSuperview];
  }
  NSMutableArray *temp = [NSMutableArray new];
  [self.data enumerateObjectsUsingBlock:^(Image *image, NSUInteger idx, BOOL *stop) {
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    imageView.hidden = NO;
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:image.url placeholderImage:[UIImage imageNamed:@"avatar"]];
    [temp addObject:imageView];
  }];
  self.imageViews = [temp copy];

  [self updateConstraintsIfNeeded];
  [self setNeedsUpdateConstraints];
}

- (NSUInteger)column:(NSArray *)data {
  NSUInteger count = data.count;
  if (count <= 3 || count > 4) {
    return 3;
  }

  if (count == 4) {
    return 2;
  }
  return 1;
}

static CGFloat const scaleFactor = 3 / 5.0;

- (CGFloat)scaleFactorWithWidth:(CGFloat)width height:(CGFloat)height {
  CGFloat scaleH = height / ScreenHeight;
  CGFloat scaleW = width / ScreenWidth;
  if (scaleH > scaleW) {
    if (height > ScreenHeight) {
      CGFloat pH = ScreenHeight * scaleFactor;
      return pH / height;
    }

    if (height > ScreenHeight / 2) {
      return 1 / 2.0;
    }
    return 1;
  }

  if (width > ScreenWidth) {
    CGFloat pH = ScreenWidth * scaleFactor;
    return pH / width;
  }

  if (width > ScreenWidth / 2) {
    return 1 / 2.0;
  }
  return 1;

}

- (CGFloat)itemWidth {
  if (self.data.count == 1) {
    for (Image *image in self.data) {
      return image.width * [self scaleFactorWithWidth:image.width height:image.height];
    }
  }
  return 80;
}

- (CGFloat)itemHeight {
  if (self.data.count == 1) {
    for (Image *image in self.data) {
      return image.height * [self scaleFactorWithWidth:image.width height:image.height];
    }
  }
  return 80;
}

- (CGFloat)height {
  NSUInteger count = self.data.count;
  NSUInteger row = count % 3 == 0 ? count / 3 : (count / 3 + 1);
  return row * [self itemHeight] + (row - 1) * kSpace;
}

- (CGFloat)width {
  NSUInteger column = [self column:self.imageViews];
  return column * [self itemWidth] + (column - 1) * kSpace;
}

@end