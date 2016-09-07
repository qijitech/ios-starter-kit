//
// Created by 杨玉刚 on 9/8/16.
//

#import "SKLocalizableUtils.h"


@implementation SKLocalizableUtils

+ (NSString *)getPreferredLanguagesString {
  NSArray *supportLanguages = @[@"en", @"zh-Hans", @"zh-Hant", @"th", @"ja", @"ko"];
  SKLocalizableType preferredLanguageType = [SKLocalizableUtils getPreferredLanguagesType];
  NSString *preferredLanguageString = supportLanguages[preferredLanguageType];
  return preferredLanguageString;
}

+ (SKLocalizableType)getPreferredLanguagesType {
  NSArray *languages = [NSLocale preferredLanguages];
  NSString *preferredLanguage = languages[0];
  if ([preferredLanguage containsString:@"en-US"]) {
    return SKLocalizableTypeEnglish;
  }

  if ([preferredLanguage containsString:@"zh-Hans"]) {
    return SKLocalizableTypeSimplifiedChinese;
  }

  if ([preferredLanguage containsString:@"zh-Hant"] ||
      [preferredLanguage containsString:@"zh-HK"] ||
      [preferredLanguage containsString:@"zh-TW"]) {
    return SKLocalizableTypeTraditionalChinese;
  }
  if ([preferredLanguage containsString:@"th"]) {
    return SKLocalizableTypeThai;
  }
  if ([preferredLanguage containsString:@"ja"]) {
    return SKLocalizableTypeJapanese;
  }
  if ([preferredLanguage containsString:@"ko"]) {
    return SKLocalizableTypeKorean;
  }
  return SKLocalizableTypeEnglish;
}
@end