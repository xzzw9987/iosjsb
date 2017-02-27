//
//  JSBridge.h
//  testios
//
//  Created by xinzhongzhu on 17/2/17.
//  Copyright © 2017年 xinzhongzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import "Tester.h"

@interface JSBridge : NSObject
-(instancetype)initWithJSContext:(JSContext*)context;
-(id)apply:(id)target methodName:(NSString*)methodName args:(NSArray*)args;
@end
