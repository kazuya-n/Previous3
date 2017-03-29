//
//  DateFormatString.m
//  Previous3
//
//  Created by 野村和也 on 2014/07/16.
//  Copyright (c) 2014年 野村和也. All rights reserved.
//

#import "DateFormatString.h"

@implementation DateFormatString
-(NSString*)dateFormat24:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"HH mm ss"];
    dateFormatter.dateFormat = @"MM月dd日 HH:mm";
    NSString *dateString=[dateFormatter stringFromDate:date];
    return dateString;
}

@end
