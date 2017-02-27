//
//  ViewController.m
//  testios
//
//  Created by xinzhongzhu on 17/2/8.
//  Copyright © 2017年 xinzhongzhu. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "TController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController* controller = [[TController alloc]initWithNibName:@"TView" bundle:[NSBundle mainBundle]];
    /* do something evil */
    
    // this will make controller react to touch event
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    [controller.view setBackgroundColor:[UIColor redColor]];
    //        [self presentViewController:controller animated:YES completion:^{}] ;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)becomeFirstResponder {
    return YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touch View conttroller");
};

@end
