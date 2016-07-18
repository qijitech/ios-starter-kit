//
// Created by 杨玉刚 on 7/18/16.
// Copyright (c) 2016 奇迹空间. All rights reserved.
//

#import "UIColor+QJ.h"
#import <HexColors/HexColors.h>

@implementation UIColor (QJ)

+ (UIColor *)qj_backgroundColor {
  return [UIColor hx_colorWithHexString:@"#f7f6f6"];
}

+ (UIColor *)qj_primaryColor {
  return [UIColor hx_colorWithHexString:@"#ec3258"];
}

+ (UIColor *)qj_accentColor {
  return [UIColor hx_colorWithHexString:@"#ffb063"];
}

+ (UIColor *)qj_textColorPrimary {
  return [UIColor hx_colorWithHexString:@"#1a1a1a"];
}

+ (UIColor *)qj_textColorPrimaryInverse {
  return [UIColor hx_colorWithHexString:@"#fffefe"];
}

+ (UIColor *)qj_textColorSecondary {
  return [UIColor hx_colorWithHexString:@"#1a1a1a"];
}

+ (UIColor *)qj_textGrayColor {
  return [UIColor hx_colorWithHexString:@"#9b9b9b"];
}

+ (UIColor *)qj_commentCellBackgroundColor {
  return [UIColor hx_colorWithHexString:@"#fafafa"];
}

+ (UIColor *)qj_loginButtonDisableColor {
  return [UIColor hx_colorWithHexString:@"#dcdcdc"];
}

+ (UIColor *)qj_cellSeparatorColor {
  return [UIColor hx_colorWithHexString:@"#f7f7f7"];
}


@end