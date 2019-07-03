//
//  DSNumberBoard.m
//  CustomedKeyboardDemo
//
//  Created by 杨晨 on 2019/2/25.
//  Copyright © 2019 HouBank. All rights reserved.
//

#import "DSNumberBoard.h"
#define kColCount       3
#define kRowCount       4
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
@interface DSNumberBoard ()
{
    BOOL xmax;
}
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, copy) NSString *output;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) UITextField *tf;
@end


@implementation DSNumberBoard

- (void)setupSubviews{
    NSString *btnTitle = [NSString string];
    int j = 0;
    NSArray *numberArr = [self randomNumberArray];
    CGFloat btnW = (self.bounds.size.width - 4) / kColCount;
    CGFloat btnH = (250 - 5 - 40) / kRowCount;
    for (int i = 0; i < 12; i++) {
        int row = i / kColCount;
        int col = i % kColCount;
        CGFloat x = 1 + col * (1 + btnW);
        CGFloat y = 1 + row * (1 + btnH) + 40;
        
        UIButton *btn;
        if (2 != i) {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
        }else{
            btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.tintColor = [UIColor blackColor];
        }
        btn.frame = CGRectMake(x, y, btnW, btnH);
        btn.tag = 120 + i;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:self.kbButtonSelectedColor forState:UIControlStateHighlighted];
        
        if (11 == i) {
            btnTitle = @"确定";
            btn.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:btnTitle forState:UIControlStateNormal];
        } else if (2 == i) {
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [btn setImage:[self bundleLoadWithOriginName:@"delete"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithRed:172 / 255.0 green:179 / 255.0 blue:191 / 255.0 alpha:1.0]];
        } else {
            btnTitle = numberArr[j++];
            [btn setTitle:btnTitle forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(numberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    
    
    
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    toolBar.barTintColor = [UIColor colorWithRed:235 / 255.0 green:237 / 255.0 blue:239 / 255.0 alpha:1.0];
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
            [btn addTarget:self action:@selector(resignKeyboard) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        btn.tag = 100 + i;
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:space];
        [items addObject:buttonItem];
        
    }
    [toolBar setItems:items animated:YES];
    //[self addSubview:toolBar];
}

- (NSArray *)randomNumberArray {
    NSArray *tempArr = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    return [tempArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int seed = arc4random() % 2;
        if (seed) {
            return [obj2 compare:obj1 options:0];
        } else {
            return ![obj2 compare:obj1 options:0];
        }
    }];
}
- (UIImage *)bundleLoadWithOriginName:(NSString*)name{
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SecurityKeyBoard" ofType:@"bundle"];
    NSString *imageName = nil;
    imageName = [name stringByAppendingString:@"@2x.jpg"];
    return [UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:imageName]];
    
}
- (void)numberBtnClick:(UIButton *)btn {
    NSString *text = [NSString string];
    text = btn.titleLabel.text;
    if ([text isEqualToString:@"确定"]) {
        [self resignKeyboard];
        return;
    }else if (122 == btn.tag){//删除按钮
        if (self.output.length >= 2) {
            self.output = [self.output substringToIndex:self.tf.text.length - 1];
        } else {
            self.output = nil;
        }
    }else{
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



- (NSString *)output {
    if (!_output) {
        _output = [NSString string];
    }
    return _output;
}
- (void)dsKeyboardTextChangedOutputBlock:(DSKeyboardOutput)output loginBlock:(DSKeyboardLogin)login {
    self.outputBlock = output;
    self.loginBlock = login;
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
        self.frame = CGRectMake(0, 0, kScreenWidth, 250 - 40);
        if (@available(iOS 11.0, *)) {
            CGFloat a =  [[UIApplication sharedApplication]delegate].window.safeAreaInsets.bottom;
            //如果是iPhoneX以上的机型
            if (a > 0) {
                self.frame = CGRectMake(0, 0, kScreenWidth, 250 + 70 - 40);
                xmax = YES;
            }
        }
        self.backgroundColor = self.kbBackgroundColor;
        [self setupSubviews];
    }
    return self;
}

- (void)resignKeyboard{
    if (self.loginBlock) {
        self.loginBlock(self.output);
    }
    [self.tf resignFirstResponder];
}

- (void)clear {
    self.output = nil;
}
- (void)dealloc {
    self.output = nil;
}
@end
