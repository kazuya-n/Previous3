//
//  NSString+JapaneseFormat.m
//  ToDo2
//
//  Created by 高橋 京介 on 2014/01/20.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "NSString+JapaneseFormat.h"

@implementation NSString (JapaneseFormat)

+ (instancetype)japaneseFormatDateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *japaneseLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [dateFormatter setLocale:japaneseLocale];
    [dateFormatter setDateFormat:@"yyyy/MM/dd(EEE) HH時mm分"];
    return [dateFormatter stringFromDate:date];
}

@end
