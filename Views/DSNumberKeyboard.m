//
//  DSNumberKeyboard.m
//  DSFramework
//
//  Created by DomSheldon on 15/12/23.
//  Copyright © 2015年 Derek. All rights reserved.
//

#import "DSNumberKeyboard.h"

#define kNumberMarginH  10
#define kNumberMarginV  10
#define kColCount       3
#define kRowCount       4

@implementation DSNumberKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.kbBackgroundColor;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    NSString *btnTitle = [NSString string];
    int j = 0;
    NSArray *numberArr = [self randomNumberArray];
    CGFloat btnW = (self.bounds.size.width - 4) / kColCount;
    CGFloat btnH = (self.bounds.size.height - 5) / kRowCount;
    for (int i = 0; i < 12; i++) {
        int row = i / kColCount;
        int col = i % kColCount;
        CGFloat x = 1 + col * (1 + btnW);
        CGFloat y = 1 + row * (1 + btnH);
        UIButton *btn;
        if (11 != i) {
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
        
        if (9 == i) {
            btnTitle = @"ABC";
            [btn setBackgroundColor:[UIColor colorWithRed:172 / 255.0 green:179 / 255.0 blue:191 / 255.0 alpha:1.0]];
        } else if (11 == i) {
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [btn setImage:[self bundleLoadWithOriginName:@"delete"] forState:UIControlStateNormal];
            btnTitle = @"";
            [btn setBackgroundColor:[UIColor colorWithRed:172 / 255.0 green:179 / 255.0 blue:191 / 255.0 alpha:1.0]];
        } else {
            btnTitle = numberArr[j++];
        }
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(numberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
- (UIImage *)bundleLoadWithOriginName:(NSString*)name{
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SecurityKeyBoard" ofType:@"bundle"];
    NSString *imageName = nil;
    imageName = [name stringByAppendingString:@"@2x.jpg"];
    return [UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:imageName]];
    
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

- (void)numberBtnClick:(UIButton *)btn {
    NSString *text = [NSString string];
    if (129 == btn.tag) {
        text = @"ABC";
    } else if (131 == btn.tag) {
        text = @"删除";
    } else {
        text = btn.titleLabel.text;
    }
    if (self.kbInput) {
        self.kbInput(text);
    }
}

- (void)getDSKeyboardInputWithInput:(DSKeyboardInput)kbInput {
    self.kbInput = kbInput;
}

@end
