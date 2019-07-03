//
//  DSNumberBoard.h
//  CustomedKeyboardDemo
//
//  Created by 杨晨 on 2019/2/25.
//  Copyright © 2019 HouBank. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DSBaseKeyboard.h"
typedef void(^DSKeyboardOutput)(NSString *fakePassword);
typedef void(^DSKeyboardLogin)(NSString *password);

@interface DSNumberBoard : DSBaseKeyboard
@property (nonatomic, copy) DSKeyboardOutput outputBlock;
@property (nonatomic, copy) DSKeyboardLogin loginBlock;

- (void)setupSubviews;

+ (instancetype)keyboardWithTextField:(UITextField *)tf withTitle:(NSString *)title;
- (instancetype)initWithTextField:(UITextField *)tf withTitle:(NSString *)title;
- (void)dsKeyboardTextChangedOutputBlock:(DSKeyboardOutput)output loginBlock:(DSKeyboardLogin)login;
- (void)clear;
- (void)setupSubviews;
@end


