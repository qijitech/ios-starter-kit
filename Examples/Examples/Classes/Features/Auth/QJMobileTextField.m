//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "QJMobileTextField.h"

@implementation QJMobileTextField

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 40, 2);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 40, 2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 40, 2);
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
  CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end