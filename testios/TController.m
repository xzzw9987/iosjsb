//
//  TController.m
//  testios
//
//  Created by xinzhongzhu on 17/2/13.
//  Copyright © 2017年 xinzhongzhu. All rights reserved.
//

#import "TController.h"
#import <objc/runtime.h>
#import "JSBridge.h"

@interface Student:NSObject {
    NSString * _id ;
}
-(NSString*)getStudentID;
-(void)change:(int*)a;
@end

@implementation Student
-(instancetype)init {
    if(self = [super init]) {
        _id = @"qwerty";
    }
    return self;
}

-(NSString*)getStudentID {
    return _id;
}


-(void)setStudentID:(NSString*)studentID {
    _id = studentID ;
}

-(NSValue*)log:(NSNumber*)a b:(NSNumber*)b {
    NSLog(@"%d", [a intValue]);
    NSLog(@"-----student's log-----");
    int x = 123;
    return [NSValue value:&x withObjCType:@encode(int)];
}

-(void)change:(int*)a {
    *a = 200;
}

@end

@interface TController() {
    Student* _student ;
}

@end

@implementation TController

-(void)loadView {
    [super loadView];
    NSLog(@"load view");
    
    /* Do something evil */
    _student = [[Student alloc]init];
    
    
    [_student addObserver:self forKeyPath:@"studentID" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:nil];
    
    [_student setValue:@"abc" forKeyPath:@"studentID"];
    
    JSBridge* bridge = [[JSBridge alloc]initWithJSContext:[[JSContext alloc]init]];
}

-(BOOL)becomeFirstResponder {
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch TController");
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    // NSLog(@"%@", [object valueForKeyPath:keyPath]);
}

NSString* Foo(){
    return @"a";
}

@end
