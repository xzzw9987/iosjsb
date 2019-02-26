//
//  JSBridge.m
//  testios
//
//  Created by xinzhongzhu on 17/2/17.
//  Copyright © 2017年 xinzhongzhu. All rights reserved.
//

#import "JSBridge.h"
#import "Test.h"
#define getSelf(instance, whichClass) id __self = [[instance value]toObjectOfClass:whichClass]

@interface JSBridge() {
    JSContext* _context ;
    UIView* _view;
}
@end

typedef id(^Blk)(void);

NSString* convertMethodName(NSString *methodName) {
    return [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
}

typedef enum TargetType {
    TargetType_Clazz,
    TargetType_Instance,
    TargetType_Nothing
} TargetType;

TargetType targetType(id target) {
    Class clz = object_getClass(target);
    if (nil == clz) return TargetType_Nothing;
    if (class_isMetaClass(clz)) {
        return TargetType_Clazz;
    }
    else {
        return TargetType_Instance;
    }
}

@implementation JSBridge

-(instancetype)initWithJSContext:(JSContext *)context
                            view:(UIView *)view {
    if(self = [super init]) {
        _context = context;
        _view = view;
        __weak __typeof__(self) weakSelf = self;
        
        _context[@"log"] = ^(id message) {
            __strong __typeof__(weakSelf) self = weakSelf;
            [self performSelector:@selector(log:) withObject:message];
        };
        
        _context[@"_requireNativeClass"] = ^(NSString* className) {
            return objc_getClass([className UTF8String]);
        };
        
        _context[@"_bridge_isMethod"] = ^(id target, NSString *prop) {
            Method method;
            switch (targetType(target)) {
                case TargetType_Clazz:;
                    method = class_getClassMethod(target, NSSelectorFromString(convertMethodName(prop)));
                    if (method) {
                        return YES;
                    }
                    return NO;
                    break;
                case TargetType_Instance:;
                    method = class_getInstanceMethod(object_getClass(target), NSSelectorFromString(convertMethodName(prop)));
                    if (method) {
                        return YES;
                    }
                    return NO;
                    break;
                default:;
                    return NO;
                    break;
            }
        };
        
        _context[@"_bridge_getMethod"] = ^(id target, NSString *prop) {
            NSInvocation *invocation;
            Blk retBlock;
            TargetType type = targetType(target);
            if (type == TargetType_Clazz || type == TargetType_Instance) {
                invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:NSSelectorFromString(convertMethodName(prop))]];
                invocation.selector = NSSelectorFromString(convertMethodName(prop));
                invocation.target = target;
                [invocation retainArguments];
                retBlock = ^() {
                    [[JSContext currentArguments]
                     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                         [invocation setArgument:&obj atIndex:2 + idx];
                     }];
                    
                    __weak id ret = nil;
                    [invocation invoke];
                    [invocation getReturnValue:&ret];
                    return ret;
                };
                return retBlock;
            }
            else {
                retBlock = ^() {
                    return @"";
                };
                return retBlock;
            }
        };
        
        _context[@"_bridge_isProp"] = ^(id target, NSString *prop) {
            TargetType type = targetType(target);
            if (type == TargetType_Instance) {
                objc_property_t p = class_getProperty(object_getClass(target), [prop UTF8String]);
                if (p) return YES;
                return NO;
            }
            return NO;
        };
        
        _context[@"_bridge_getProp"] = ^(id target, NSString *prop) {
            TargetType type = targetType(target);
            id ret;
            if (type == TargetType_Instance) {
                return [target valueForKey:prop];
            }
            return ret;
        };
        
        _context[@"_bridge_set"] = ^(id target, NSString *prop, id value) {
            TargetType type = targetType(target);
            if (type == TargetType_Instance) {
                @try {
                    [target setValue:value forKey:prop];
                } @catch (NSException *exception) {
                    NSLog(@"error");
                }
            }
            return value;
        };
        
        _context[@"_view"] = _view;
        
        NSError *error = nil;
        NSString* setupJs =
        [NSString
         stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"setup" ofType:@"js"] encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            [_context evaluateScript:setupJs];
        }
    }
    return self ;
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
    
    NSLog(@"[Logging] %@", message);
}


@end
