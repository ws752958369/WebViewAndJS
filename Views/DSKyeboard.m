//
//  DSKyeboard.m
//  DSFramework
//
//  Created by DomSheldon on 15/12/23.
//  Copyright © 2015年 Derek. All rights reserved.
//

#import "DSKyeboard.h"
#import "DSNumberKeyboard.h"
#import "DSLetterKeyboard.h"
#import "DSSymbolKeyboard.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kIsIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsIPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@interface DSKyeboard ()
{
    UIButton *_selectedBtn;
    BOOL xmax;
}
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) DSNumberKeyboard *numberKB;
@property (nonatomic, strong) DSLetterKeyboard *letterKB;
@property (nonatomic, strong) DSSymbolKeyboard *symbolKB;
@property (nonatomic, copy) NSString *output;
@property (nonatomic, copy) NSString *titleStr;
@end

@implementation DSKyeboard

CGFloat _dsKeyboardH;
CGFloat _dsKeyboardToolH;

#pragma mark - lazy loading
- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _dsKeyboardToolH)];
        _toolBar.barTintColor = [UIColor colorWithRed:235 / 255.0 green:237 / 255.0 blue:239 / 255.0 alpha:1.0];
        NSMutableArray *items = [NSMutableArray array];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:space];
        NSString *btnTitleStr = [NSString stringWithFormat:@"%@",self.titleStr];
        NSArray *btnTitles = @[btnTitleStr,@"完成"];
        for (int i = 0; i < btnTitles.count; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 160, 30);
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if (i == 1) {
                btn.frame = CGRectMake(0,0, 40, 30);
                [btn setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            btn.tag = 100 + i;
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(switchToSystemKeyboard:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            //将字母键盘设置为首键盘
            UIView *aView = [self viewWithTag:(102 + 10)];
            [self bringSubviewToFront:aView];
            
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            [items addObject:space];
            [items addObject:buttonItem];
            
        }
        [_toolBar setItems:items animated:YES];
    }
    return  _toolBar;
}

- (UIView *)numberKB {
    if (!_numberKB) {
        _numberKB = [[DSNumberKeyboard alloc] init];
        if (xmax) {
            _numberKB.frame = CGRectMake(0, 0, kScreenWidth, self.frame.size.height - 70);
        }else{
            _numberKB.frame = CGRectMake(0, 0, kScreenWidth, self.frame.size.height);
        }
        _numberKB.tag = 111;
        [self addSubview:_numberKB];
    }
    return _numberKB;
}

- (UIView *)letterKB {
    if (!_letterKB) {
        _letterKB = [[DSLetterKeyboard alloc] initWithFrame:self.numberKB.frame];
        _letterKB.tag = 112;
        [self addSubview:_letterKB];
    }
    return _letterKB;
}

- (UIView *)symbolKB {
    if (!_symbolKB) {
        _symbolKB = [[DSSymbolKeyboard alloc] initWithFrame:self.numberKB.frame];
        _symbolKB.tag = 113;
        [self addSubview:_symbolKB];
    }
    return _symbolKB;
}

- (NSString *)output {
    if (!_output) {
        _output = [NSString string];
    }
    return _output;
}

#pragma mark - initialize
+ (void)initialize {
    if (self == [DSKyeboard class]) {
        if ([UIScreen mainScreen].bounds.size.height > 667) {
            _dsKeyboardH = 271.0 - 40;
            _dsKeyboardToolH = 40.0;
        } else if ([UIScreen mainScreen].bounds.size.height == 667) {
            _dsKeyboardH = 258.0 - 37;
            _dsKeyboardToolH = 37.0;
        } else {
            _dsKeyboardH = 253.0 - 33;
            _dsKeyboardToolH = 33.0;
        }
    }
}

+ (instancetype)keyboardWithTextField:(UITextField *)tf withTitle:(NSString *)title{
    return [[self alloc] initWithTextField:tf withTitle:title];
}

- (instancetype)initWithTextField:(UITextField *)tf withTitle:(NSString *)title{
    if (self = [super init]) {
        xmax = NO;
        self.tf = tf;
        self.titleStr = title;
        //保存本地
        [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"KeyBoardTitle"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.frame = CGRectMake(0, 0, kScreenWidth, _dsKeyboardH);
        if (@available(iOS 11.0, *)) {
            CGFloat a =  [[UIApplication sharedApplication]delegate].window.safeAreaInsets.bottom;
            //如果是iPhoneX以上的机型
            if (a > 0) {
                self.frame = CGRectMake(0, 0, kScreenWidth, _dsKeyboardH + 70);
                xmax = YES;
            }
        }
        [self editingData];
    }
    return self;
}

- (void)editingData {
    __weak typeof(self) weakSelf = self;
    [(DSNumberKeyboard *)self.numberKB getDSKeyboardInputWithInput:^(NSString *text){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf outputByText:text];
    }];
    [(DSLetterKeyboard *)self.letterKB getDSKeyboardInputWithInput:^(NSString *text){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf outputByText:text];
    }];
    [(DSSymbolKeyboard *)self.symbolKB getDSKeyboardInputWithInput:^(NSString *text){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf outputByText:text];
    }];
    //将字母键盘设置为首键盘
    UIView *aView = [self viewWithTag:(102 + 10)];
    [self bringSubviewToFront:aView];
    //[self addSubview:self.toolBar];
}

- (void)outputByText:(NSString *)text {
    if ([text isEqualToString:@"123"]) {
        //切换数字键盘
        //刷新数字键盘数字
        DSNumberKeyboard *aView = (DSNumberKeyboard *)[self viewWithTag:(101 + 10)];
        [aView setupSubviews];
        
        
        [self bringSubviewToFront:aView];
        return;
    }
    if ([text isEqualToString:@"ABC"]) {
        //切换字母键盘
        UIView *aView = [self viewWithTag:(102 + 10)];
        [self bringSubviewToFront:aView];
        return;
    }
    if ([text isEqualToString:@"#+="]) {
        //切换字符键盘
        UIView *aView = [self viewWithTag:(103 + 10)];
        [self bringSubviewToFront:aView];
        return;
    } else {
        if ([text isEqualToString:@"删除"]) {
            if (self.output.length >= 2) {
                self.output = [self.output substringToIndex:self.tf.text.length - 1];
            } else {
                self.output = nil;
            }
        } else if ([text isEqualToString:@"空格"]) {
            self.output = [self.output stringByAppendingString:@" "];
        } else {
            self.output = [self.output stringByAppendingString:text];
        }
        if (self.outputBlock) {
            NSString *fakePassword = [self fakePasswordWithOutput:self.output];
            self.outputBlock(fakePassword);
        }
        if (self.loginBlock) {
            self.loginBlock(self.output);
        }
    }
}

- (NSString *)fakePasswordWithOutput:(NSString *)output {
    if (output.length) {
        NSString *fakePassword = [NSString string];
        for (int i = 0; i < output.length; i++) {
            fakePassword = [fakePassword stringByAppendingString:@"•"];
        }
        return fakePassword;
    }
    return nil;
}

#pragma mark - target action
- (void)switchToSystemKeyboard:(UIButton *)btn {
    if (101 == btn.tag) {
        if (self.loginBlock) {
            self.loginBlock(self.output);
        }
        [self.tf resignFirstResponder];
    }
}

- (void)dsKeyboardTextChangedOutputBlock:(DSKeyboardOutput)output loginBlock:(DSKeyboardLogin)login {
    self.outputBlock = output;
    self.loginBlock = login;
}

- (void)clear {
    self.output = nil;
}

- (void)dealloc {
    self.output = nil;
}

@end
