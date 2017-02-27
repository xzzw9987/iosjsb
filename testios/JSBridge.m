//
//  JSBridge.m
//  testios
//
//  Created by xinzhongzhu on 17/2/17.
//  Copyright © 2017年 xinzhongzhu. All rights reserved.
//

#import "JSBridge.h"
#define getSelf(instance, whichClass) id __self = [[instance value]toObjectOfClass:whichClass]

@interface JSBridge() {
    JSContext* _context ;
}
@end

@implementation JSBridge

-(instancetype)initWithJSContext:(JSContext *)context {
    if(self = [super init]) {
        _context = context;
        
        Class myClass = [self class];
        
        JSManagedValue* selfValue =
        [JSManagedValue
         managedValueWithValue:[JSValue valueWithObject:self inContext:_context]
         andOwner:_context.virtualMachine];
        
        
        
        
        _context[@"log"] = ^(id message) {
            getSelf(selfValue, myClass);
            [__self performSelector:@selector(log:) withObject:message];
        };
        
        _context[@"requireNativeClass"] = ^(NSString* className) {
            return @{
                     @"type": @"class",
                     @"value": className
                     };
        };
        
        _context[@"nativeApply"] = ^(id target, NSString* methodName, NSArray* args) {
            getSelf(selfValue, myClass);
            return [__self
                    apply:target
                    methodName:methodName
                    args:args];
        };
        
        [self test];
    }
    return self ;
}

-(void)test {
    [_context
     evaluateScript:@"try { log(nativeApply(requireNativeClass('NSObject'),'alloc', []) ) } catch (e) {log(e.toString());} "
     ];
}



-(id)apply:(id)descriptor
methodName:(NSString*)methodName
      args:(NSArray*)args {
    id target = descriptor[@"value"];
    NSLog(@"%@", target);
    NSLog(@"%s", object_getClassName(object_getClass(target)));
    NSMethodSignature* signature = nil;
    if([descriptor[@"type"] isEqual: @"class"]) {
        signature = [NSClassFromString(descriptor[@"value"]) methodSignatureForSelector:NSSelectorFromString(methodName)] ;
        NSLog(@"%@", signature);
    } else {
        signature = [target instanceMethodSignatureForSelector:NSSelectorFromString(methodName)];
    }
    
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature] ;
    invocation.target =  NSClassFromString(descriptor[@"value"]);
    invocation.selector = NSSelectorFromString(methodName);
    for(int i = 0 ; i < [args count]; i ++) {
        id val = args[i];
        [invocation setArgument:&val atIndex:i + 2];
    }
    [invocation invoke];
    NSString* returnType = [NSString stringWithUTF8String:[signature methodReturnType]];
    NSLog(@"%@", returnType);
    
    NSValue* value;
    [invocation getReturnValue:&value];
    
    // NSLog(@"%@", a);
    return @1;
}

-(void)log:(id)message {
    
    NSLog(@"Logging %@", message);
}

@end
