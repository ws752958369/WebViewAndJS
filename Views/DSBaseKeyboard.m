//
//  DSBaseKeyboard.m
//  DSFramework
//
//  Created by DomSheldon on 15/12/25.
//  Copyright © 2015年 Derek. All rights reserved.
//

#import "DSBaseKeyboard.h"

@implementation DSBaseKeyboard

- (UIColor *)kbBackgroundColor {
    if (!_kbBackgroundColor) {
        _kbBackgroundColor = [UIColor colorWithRed:210 / 255.0 green:213 / 255.0 blue:218 / 255.0 alpha:1.0];
    }
    return _kbBackgroundColor;
}

- (UIColor *)kbButtonSelectedColor {
    if (!_kbButtonSelectedColor) {
        _kbButtonSelectedColor = [UIColor lightGrayColor];//[UIColor colorWithRed:0 / 255.0 green:158 / 255.0 blue:226 / 255.0 alpha:1.0];
    }
    return _kbButtonSelectedColor;
}
- (UIColor *)kbButtonColor {
    if (!_kbButtonColor) {
        _kbButtonColor = [UIColor colorWithRed:30 / 255.0 green:77 / 255.0 blue:136 / 255.0 alpha:1.0];
    }
    return _kbButtonSelectedColor;
}
- (void)getDSKeyboardInputWithInput:(DSKeyboardInput)kbInput {}

@end
