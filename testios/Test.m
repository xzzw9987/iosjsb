//
//  Test.m
//  testios
//
//  Created by PXCM-0101-01-0045 on 2019/1/25.
//  Copyright © 2019 xinzhongzhu. All rights reserved.
//

#import "Test.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation Test
+(NSObject*)hello {
    return [NSNumber numberWithInteger:100];
}

+(void)staticMethodWithArg:(id)arg {

    NSLog(@"static, %d", [(JSValue*)arg toInt32]);
}

-(instancetype)init {
    if (self = [super init]) {
        self.instanceProp = [NSNumber numberWithInteger:300];
    }
    return self;
}
-(NSObject*)instanceMethod {
    return [NSNumber numberWithInteger:200];
}
@end
