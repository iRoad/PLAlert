//
//  PLCustomAlertView.h
//  Panda
//
//  Created by 李建平 on 2019/3/20.
//  Copyright © 2019 李建平. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PLCAlertType) {
    PLCAlertTypeNormal,
    PLCAlertTypeSuccess,
    PLCAlertTypeFailure
};

/// default images for different type
#define PLCAlertTypeImages @{@"success":@"success", @"failure":@"failure"}

typedef void (^PLCustomHandler)(NSInteger clickButtonIndex);

@interface PLCustomAlertView : UIView

/** alert with title, cancel title, tap idx */
+ (instancetype)alertWithType:(PLCAlertType)type
                        title:(NSString *)title
                  cancelTitle:(NSString * _Nullable)cancelTitle
             tapButtonHandler:(PLCustomHandler _Nullable)handler;

/** alert with title, cancel title, other titles, tap idx, cancel idx = 0, other form 1 */
+ (instancetype)alertWithType:(PLCAlertType)type
                        title:(NSString * _Nullable)title
                      message:(NSString * _Nullable)message
                  cancelTitle:(NSString * _Nullable)cancelTitle
                  otherTitles:(NSArray * _Nullable)otherTitles
             tapButtonHandler:(PLCustomHandler _Nullable)handler;

@end

NS_ASSUME_NONNULL_END
