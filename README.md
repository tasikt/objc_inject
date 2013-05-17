objc_inject
-----------
Objective-c code injection helpers.   
it provided a script to convert `THEOS/LOGOS-like` hook grammar to real codes.  

###Grammar

``` c
%hook AClass
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
```


###Demo and Usage
checkout `main.m` file and run `make` to see what happened :D
