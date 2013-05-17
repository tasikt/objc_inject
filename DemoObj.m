//
//  DemoObj.m
//  qqmusic-hook
//
//  Created by xhan on 5/14/13.
//  Copyright (c) 2013 xhan. All rights reserved.
//

#import "DemoObj.h"

@implementation DemoObj

- (id)nothing:(id)arg
{
    NSLog(@"calling origin nothing %@",arg);
    return [NSString stringWithFormat:@"_/%@\\_",arg];
}
- (void)another:(id)arg1 and:(id)arg2
{
    NSLog(@"origin another: %@ %@",arg1,arg2);
//    @selector(another:and:)
}

- (void)another:(id)arg1 and:(id)arg2 then : (id)arg3
{

}

- (void)test:(int*)value
{
    *value = 5;
}
@end
