//
//  main.m
//  autoHook
//
//  Created by xhan on 5/14/13.
//  Copyright (c) 2013 xhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/runtime.h>
#import "DemoObj.h"

#define HOOK_SCRIPTING 0
#if HOOK_SCRIPTING
    #define HOOK_CLASS void
#endif


#if HOOK_SCRIPTING

%hook DemoObj
- (id)nothing:(id)arg{
    NSLog(@"calling hooking! nothing %@",arg);
    
    arg = %origin(arg);
    return arg;
}
- (void)test:(int*)value
{
    *value = 8888;
}

%end

#else 
//-BEGIN-HOOK-GEN-CODES
//////////////////////////////////////////////////////
// hooks for DemoObj
@interface DemoObj_HOOK_BY_XHAN : NSObject
@end
@implementation DemoObj_HOOK_BY_XHAN
static IMP _imp_nothing__,_imp_test__;
+ (void)_hookMethod:(Class)origin method:(SEL)sel target:(Class)target imp:(IMP*)imp
{
    Method methodOrigin = class_getInstanceMethod(origin, sel);
    Method methodTarget = class_getInstanceMethod(target, sel);  
	*imp = method_getImplementation(methodOrigin);
    method_exchangeImplementations(methodOrigin, methodTarget);
}
+ (void)load{
	Class klassOrigin = NSClassFromString(@"DemoObj");
	[self _hookMethod:klassOrigin method:@selector(nothing:) target:self imp:&_imp_nothing__];
	[self _hookMethod:klassOrigin method:@selector(test:) target:self imp:&_imp_test__];
}
- (id)nothing:(id)arg{
    NSLog(@"calling hooking! nothing %@",arg);
    
    arg = _imp_nothing__(self,_cmd,arg);
    return arg;
}
- (void)test:(int*)value
{
    *value = 8888;
}
@end
//-END-HOOK-GEN-CODES
#endif



int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        DemoObj*obj = [DemoObj new];
		NSLog(@"calling obj -nothing:");
        [obj nothing:@"123"];
		NSLog(@"end calling");
			
		// some other tests
        [obj another:nil and:nil];        
        int a = 100;
        [obj test:&a];		
        NSLog(@"a %d",a);

        
    }
    return 0;
}

