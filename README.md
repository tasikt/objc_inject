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
run `autohook.rb target_file` to generate real-codes. 
the generated codes will be inserted between blocks:  
>//-BEGIN-HOOK-GEN-CODES  
//-END-HOOK-GEN-CODES  

checkout `main.m` file and `make` to see what happened :D
