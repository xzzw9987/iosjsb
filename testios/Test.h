//
//  Test.h
//  testios
//
//  Created by PXCM-0101-01-0045 on 2019/1/25.
//  Copyright © 2019 xinzhongzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Test : NSObject
@property (nonatomic, strong) NSObject *instanceProp;
+(NSObject*)hello;
+(void)staticMethodWithArg:(id)arg;
-(NSObject*)instanceMethod;
@end

NS_ASSUME_NONNULL_END
