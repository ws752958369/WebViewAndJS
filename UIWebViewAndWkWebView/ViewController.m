//
//  ViewController.m
//  UIWebViewAndWkWebView
//
//  Created by wangsheng on 2019/3/4.
//  Copyright © 2019 wangsheng. All rights reserved.
//

#import "ViewController.h"
#import "WSUIWebViewController.h"
#import "WSWKWebViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake((self.view.bounds.size.width-120)/2.0, 120, 120, 40);
    [btn1 setTitle:@"UIWebView" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(gotoUIWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake((self.view.bounds.size.width-120)/2.0, 240, 120, 40);
    [btn2 setTitle:@"WKWebView" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(gotoWKWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)gotoUIWebView
{
    WSUIWebViewController *webViewController = [WSUIWebViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)gotoWKWebView
{
    WSWKWebViewController *webViewController = [WSWKWebViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self presentViewController:nav animated:YES completion:nil];
}


@end
