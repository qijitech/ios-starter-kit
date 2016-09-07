//
// Created by 杨玉刚 on 9/8/16.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SKLocalizableType) {
  SKLocalizableTypeEnglish,
  SKLocalizableTypeSimplifiedChinese,
  SKLocalizableTypeTraditionalChinese,
  SKLocalizableTypeThai,
  SKLocalizableTypeJapanese,
  SKLocalizableTypeKorean,
};

@interface SKLocalizableUtils : NSObject

+ (NSString *)getPreferredLanguagesString;

+ (SKLocalizableType)getPreferredLanguagesType;

@end