//
//  Tester.m
//  testios
//
//  Created by xinzhongzhu on 17/2/21.
//  Copyright © 2017年 xinzhongzhu. All rights reserved.
//

#import "Tester.h"
@interface Tester(){
    int _val ;
}

@end

@implementation Tester

-(instancetype)initWithValue:(int)value {
    if(self = [super init]) {
        _val = value ;
    }
    return self ;
}
-(void)method {
    NSLog(@"Method in Tester");
    NSLog(@"Value is what ?%d", _val);
}
@end
