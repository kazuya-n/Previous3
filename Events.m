//
//  Events.m
//  Previous3
//
//  Created by 野村和也 on 2014/06/15.
//  Copyright (c) 2014年 野村和也. All rights reserved.
//

#import "Events.h"

@implementation Events

-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.date forKey:@"date"];
    //イベントの新要素、メモ
    [coder encodeObject:self.memo forKey:@"memo"];

}
-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.memo =[decoder decodeObjectForKey:@"memo"];
    }
    return self;
}

@end
