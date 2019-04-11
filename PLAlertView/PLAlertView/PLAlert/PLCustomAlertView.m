//
//  PLCustomAlertView.m
//  Panda
//
//  Created by 李建平 on 2019/3/20.
//  Copyright © 2019 李建平. All rights reserved.
//

#import "PLCustomAlertView.h"

@interface UIColor (PLAlertColor)

+ (UIColor *)colorWithHex:(NSInteger)hex;

@end

@implementation UIColor (PLAlertColor)

+ (UIColor *)colorWithHex:(NSInteger)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

@end


@interface NSString (PLAlertString)

- (CGSize)sizeWithFont:(UIFont*)font size:(CGSize)size;

@end

@implementation NSString (PLAlertString)

- (CGSize)sizeWithFont:(UIFont*)font size:(CGSize)size {
    NSDictionary*attrs =@{NSFontAttributeName:font};
    return  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs  context:nil].size;
}

@end


@interface PLCustomAlertView ()

@property (nonatomic, assign) PLCAlertType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, strong) NSArray *otherTitles;
@property (nonatomic, copy) PLCustomHandler handler;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *btnsView;

@end

@implementation PLCustomAlertView

/** alert with title, cancel title, tap idx */
+ (instancetype)alertWithType:(PLCAlertType)type
                        title:(NSString *)title
                  cancelTitle:(NSString * _Nullable)cancelTitle
             tapButtonHandler:(PLCustomHandler _Nullable)handler {
    return [self alertWithType:type
                         title:title
                       message:nil
                   cancelTitle:cancelTitle
                   otherTitles:nil
              tapButtonHandler:handler];
}

/** alert with title, cancel title, other titles, tap idx, cancel idx = 0, other form 1 */
+ (instancetype)alertWithType:(PLCAlertType)type
                        title:(NSString *)title
                      message:(NSString * _Nullable)message
                  cancelTitle:(NSString * _Nullable)cancelTitle
                  otherTitles:(NSArray * _Nullable)otherTitles
             tapButtonHandler:(PLCustomHandler _Nullable)handler {
    PLCustomAlertView *alertView = [[PLCustomAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.type = type;
    alertView.title = title;
    alertView.message = message;
    alertView.cancelTitle = cancelTitle;
    alertView.otherTitles = otherTitles;
    alertView.handler = handler;
    
    [alertView setupSubviews];
    
    return alertView;
}

- (void)setupSubviews {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    self.contentView.frame = CGRectMake((self.frame.size.width-289)/2.0, 0, 289, 0);
    
    // 图片
    BOOL imageFlag = PLCAlertTypeNormal != self.type;
    if (imageFlag) {
        self.imageView.frame = CGRectMake((self.contentView.frame.size.width-56)/2.0, 27, 56, 56);
        self.imageView.image = [UIImage imageNamed:[PLCAlertTypeImages objectForKey:(PLCAlertTypeSuccess==self.type?@"success":@"failure")]];
    }
    
    // 标题
    BOOL titleFlag = self.title.length > 0 || self.message.length>0;
    if (titleFlag) {
        self.titleLabel.text = self.title.length>0?self.title:self.message;
        
        CGFloat width = self.contentView.frame.size.width-60;
        CGFloat height = [self.titleLabel.text sizeWithFont:self.titleLabel.font size:CGSizeMake(width, MAXFLOAT)].height;
        if (imageFlag) {
            self.titleLabel.frame = CGRectMake(30, CGRectGetMaxY(self.imageView.frame)+10, width, height);
        } else {
            self.titleLabel.frame = CGRectMake(30, 27, width, height);
        }
    }
    
    // 信息
    BOOL msgFlag = self.title.length > 0 && self.message.length>0;
    if (msgFlag) {
        self.messageLabel.text = self.message;
        
        CGFloat width = self.contentView.frame.size.width-64;
        CGFloat height = [self.messageLabel.text sizeWithFont:self.messageLabel.font size:CGSizeMake(width, MAXFLOAT)].height;
        self.messageLabel.frame = CGRectMake(32, CGRectGetMaxY(self.titleLabel.frame)+5, width, height);
    }
    
    // 分割线
    if (msgFlag) {
        self.line.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame)+29,self.contentView.frame.size.width,0.5);
    } else if (titleFlag) {
        self.line.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+29,self.contentView.frame.size.width,0.5);
    } else if (imageFlag) {
        self.line.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+29,self.contentView.frame.size.width,0.5);
    } else { // 如果啥都没有 就没有必要显示了
        return;
    }
    
    {
        CGFloat height = 47;
        self.btnsView.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame), self.contentView.frame.size.width, 0);
        
        // 添加btn
        BOOL otherBtnFalg = self.otherTitles.count==0;
        
        NSString *cTitle = self.cancelTitle.length>0?self.cancelTitle:@"取消";
        [self.btnsView addSubview:[self btnWithTitle:cTitle highlight:otherBtnFalg tag:0]];
        
        // others
        if (self.otherTitles.count > 0) {
            [self.otherTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.btnsView addSubview:[self lineView]];
                [self.btnsView addSubview:[self btnWithTitle:obj highlight:YES tag:idx+1]];
            }];
        }
        
        
        // 布局btn 两个按钮+中线 3
        BOOL btnH = self.btnsView.subviews.count<=3&&self.btnsView.subviews.count > 1;
        CGFloat width = btnH?self.btnsView.frame.size.width*0.5:self.btnsView.frame.size.width;
        
        __block CGRect bframe = CGRectZero;
        [self.btnsView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                if (btnH) {
                    obj.frame = CGRectMake(CGRectGetMaxX(bframe), 0, width, height);
                } else {
                    obj.frame = CGRectMake(0, CGRectGetMaxY(bframe), width, height);
                }
            } else {
                if (btnH) {
                    obj.frame = CGRectMake(CGRectGetMaxX(bframe), (height-17)/2.0, 0.5, 17);
                } else {
                    obj.frame = CGRectMake(0, CGRectGetMaxY(bframe), width, 0.5);
                }
            }
            
            bframe = obj.frame;
        }];
        
        CGRect btnsFrame = self.btnsView.frame;
        btnsFrame.size.height = CGRectGetMaxY(bframe);
        self.btnsView.frame = btnsFrame;
    }
    
    {
        CGRect cframe = self.contentView.frame;
        cframe.size.height = CGRectGetMaxY(self.btnsView.frame);
        cframe.origin.y = (self.frame.size.height-cframe.size.height)/2.0;
        self.contentView.frame = cframe;
    }
    
    self.contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.25 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (UIButton *)btnWithTitle:(NSString *)title highlight:(BOOL)light tag:(NSUInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIColor *normalColor = light?[UIColor colorWithHex:0x2FBE6A]:[UIColor colorWithHex:0x999999];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
    [btn setTag:tag];
    
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (UIView *)lineView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    return view;
}

+ (BOOL)hideAlertView {
    PLCustomAlertView *alertView = [self alertForView:[UIApplication sharedApplication].keyWindow];
    
    if (alertView != nil) {
        alertView.alpha = 0.0f;
        [alertView removeFromSuperview];
        return YES;
    }
    return NO;
}

+ (PLCustomAlertView *)alertForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            PLCustomAlertView *alertView = (PLCustomAlertView *)subview;
            return alertView;
        }
    }
    return nil;
}

#pragma mark - action
- (void)btnOnClick:(UIButton *)sender {
    if (self.handler) {
        self.handler(sender.tag);
    }
    
    if (0 == sender.tag) {
        [PLCustomAlertView hideAlertView];
    }
}

#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = 7;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _messageLabel.textColor = [UIColor colorWithHex:0x999999];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [self lineView];
        [self.contentView addSubview:_line];
    }
    return _line;
}

- (UIView *)btnsView {
    if (!_btnsView) {
        _btnsView = [[UIView alloc] init];
        _btnsView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_btnsView];
    }
    return _btnsView;
}

@end
