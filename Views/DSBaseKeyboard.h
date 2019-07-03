//
//  DSBaseKeyboard.h
//  DSFramework
//
//  Created by DomSheldon on 15/12/25.
//  Copyright © 2015年 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKeyboardButtonFont 18.0
#define kButtonCornerRadius 5.0

typedef void(^DSKeyboardInput)(NSString *text);

@interface DSBaseKeyboard : UIView

@property (nonatomic, copy) DSKeyboardInput kbInput;
@property (nonatomic, strong) UIColor *kbBackgroundColor;
@property (nonatomic, strong) UIColor *kbButtonSelectedColor;
@property (nonatomic, strong) UIColor *kbButtonColor;

- (void)getDSKeyboardInputWithInput:(DSKeyboardInput)kbInput;

@end
