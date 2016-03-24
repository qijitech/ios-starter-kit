//
// Created by 杨玉刚 on 3/24/16.
//

#import "SKToastUtil.h"


@implementation SKToastUtil

+ (void)toastWithText:(NSString *)text {
  [[self class] toastWithText:text duration:1.f];
}

+ (void)toastWithText:(NSString *)text duration:(double)duration {
  [[[MDToast alloc] initWithText:text duration:duration] show];
}
@end