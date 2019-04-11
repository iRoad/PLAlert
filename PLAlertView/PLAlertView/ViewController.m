//
//  ViewController.m
//  PLAlertView
//
//  Created by 李建平 on 2019/4/11.
//  Copyright © 2019 李建平. All rights reserved.
//

#import "ViewController.h"
#import "PLAlert/PLCustomAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [PLCustomAlertView alertWithType:PLCAlertTypeSuccess title:@"Title" cancelTitle:@"Yes" tapButtonHandler:nil];
}


@end
