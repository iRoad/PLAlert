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
    
    self.view.backgroundColor = [UIColor redColor];
}
- (IBAction)buttonOnClick:(UIButton *)sender {
    if (0 == sender.tag) {
        [PLCustomAlertView alertWithType:PLCAlertTypeNormal title:@"Title" message:nil cancelTitle:@"Cancel" otherTitles:@[@"OK"] tapButtonHandler:^(NSInteger clickButtonIndex) {
            NSLog(@"clickIDX:(%@)", @(clickButtonIndex));
        }];
    } else if (1 == sender.tag) {
        [PLCustomAlertView alertWithType:PLCAlertTypeSuccess title:@"Title" message:@"message" cancelTitle:@"Cancel" otherTitles:@[@"First", @"Second"] tapButtonHandler:^(NSInteger clickButtonIndex) {
            NSLog(@"clickIDX:(%@)", @(clickButtonIndex));
        }];
    } else if (2 == sender.tag) {
        [PLCustomAlertView alertWithType:PLCAlertTypeFailure title:@"title" cancelTitle:nil tapButtonHandler:^(NSInteger clickButtonIndex) {
            NSLog(@"clickIDX:(%@)", @(clickButtonIndex));
        }];
    } else if (3 == sender.tag) {
        [PLCustomAlertView alertWithType:PLCAlertTypeNormal title:@"Title" message:@"message" cancelTitle:@"Cancel" otherTitles:nil tapButtonHandler:^(NSInteger clickButtonIndex) {
            NSLog(@"clickIDX:(%@)", @(clickButtonIndex));
        }];
    } else if (4 == sender.tag) {
        [PLCustomAlertView alertWithType:PLCAlertTypeNormal title:nil message:@"message" cancelTitle:@"Cancel" otherTitles:@[@"OK"] tapButtonHandler:^(NSInteger clickButtonIndex) {
            NSLog(@"clickIDX:(%@)", @(clickButtonIndex));
        }];
    }
}


@end
