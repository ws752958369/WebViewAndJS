//
//  DSKyeboard.h
//  DSFramework
//
//  Created by DomSheldon on 15/12/23.
//  Copyright © 2015年 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DSKeyboardOutput)(NSString *fakePassword);
typedef void(^DSKeyboardLogin)(NSString *password);

@interface DSKyeboard : UIView

@property (nonatomic, copy) DSKeyboardOutput outputBlock;
@property (nonatomic, copy) DSKeyboardLogin loginBlock;
+ (instancetype)keyboardWithTextField:(UITextField *)tf withTitle:(NSString *)title;
- (instancetype)initWithTextField:(UITextField *)tf withTitle:(NSString *)title;
- (void)dsKeyboardTextChangedOutputBlock:(DSKeyboardOutput)output loginBlock:(DSKeyboardLogin)login;
- (void)clear;

@end

/*
 toolBar 背景色 235 237 239
        字体 白色
        选中 蓝色
 键盘 背景色 210 213 218
 按键 背景色 白色
 按键字体色 黑色
 特殊按键 背景色 174 179 188
*/
