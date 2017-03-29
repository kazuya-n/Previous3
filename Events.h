//
//  Events.h
//  Previous3
//
//  Created by 野村和也 on 2014/06/15.
//  Copyright (c) 2014年 野村和也. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Events : NSObject<NSCoding>
@property NSString *title;
@property NSDate *date;
@property NSString *memo;
@end
