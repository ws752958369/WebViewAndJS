//
//  WSUIWebViewController.m
//  UIWebViewAndWkWebView
//
//  Created by wangsheng on 2019/3/4.
//  Copyright © 2019 wangsheng. All rights reserved.
//

#import "WSUIWebViewController.h"
#import <Photos/Photos.h>
#import "TestBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "VKMsgSend.h"

static NSString *const WebJSNavigationScheme = @"webjs-navigation-objc";
static NSString *const MessageHandler = @"WSMessageHandler";

@interface WSUIWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)id objc;
@end

@implementation WSUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backDismiss)];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"photo" style:UIBarButtonItemStylePlain target:self action:@selector(openLibrary)];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,64,self.view.bounds.size.width,self.view.bounds.size.height-64)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    
//    if (self.requestUrl) {
//        self.requestUrl = [self.requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
//    [self.webView loadRequest:request];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    [self.webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]]];
    
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"context:%@,exception:%@",context,exception);
    };
    
}

- (void)openLibrary
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [self presentViewController:imagePicker animated:YES completion:NULL];
            }
        }
    }];
}


- (void)backDismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"webView_shouldStartLoadWithRequest:%@,navigationType:%li",request,navigationType);
    
    if ([request.URL.scheme isEqualToString:WebJSNavigationScheme] && [request.URL.host isEqualToString:MessageHandler]) {
        
        NSRange range = [request.URL.absoluteString rangeOfString:MessageHandler];
        if (range.location != NSNotFound) {
            
           @try {
            
                NSString *paramsData = [request.URL.absoluteString substringFromIndex:range.location+range.length+1];
                NSDictionary *jsonData = [self jsonParse:paramsData];
                NSLog(@"jsonData:%@",jsonData);
               
               NSString *successFuncName = jsonData[@"successCallback"];
               NSString *failFuncName = jsonData[@"failCallback"];
               
               //该方法会阻塞，直到有结果返回
               [self vk_callSelectorWithClassName:jsonData[@"className"] functionName:jsonData[@"functionName"] params:jsonData[@"params"] success:^(id resp) {
                   [self callbackWithName:successFuncName response:resp webView:webView];
               } fail:^(id resp) {
                   [self callbackWithName:failFuncName response:resp webView:webView];
               }];
               
                NSString *source = [NSString stringWithFormat:@"window.%@.messageReceived();", MessageHandler];//主要是重置状态用
                [webView stringByEvaluatingJavaScriptFromString:source];
                
            }@catch (NSException *exception) {
                NSLog(@"exception:%@",exception);
            }
            
        }
        
        
        return NO;
    }
    
    return YES;
}

- (void)vk_callSelectorWithClassName:(NSString *)className functionName:(NSString *)functionName params:(id)params success:(void(^)(id))success fail:(void(^)(id))fail
{
    Class Class = NSClassFromString(className);
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:::",functionName]);
    
    id objc = [Class new];
    //_objc = objc;
    NSError *err = nil;
    
    [objc VKCallSelector:selector error:&err,params,success,fail,nil];
}

- (void)callbackWithName:(NSString *)callbackName response:(id)resp webView:(UIWebView *)webView
{
    NSString *jsResource = [NSString stringWithFormat:@"%@('%@')",callbackName,resp];
    jsResource = [jsResource stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [webView stringByEvaluatingJavaScriptFromString:jsResource];
}

- (NSString *)jsonToString:(NSDictionary *)json
{
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&err];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (NSDictionary *)jsonParse:(NSString *)json
{
    NSDictionary *dic = nil;
    NSError *errr = nil;
    dic = [NSJSONSerialization JSONObjectWithData:[[json stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&errr];
    if (errr) {
        NSLog(@"解析错误,%@",errr);
        return nil;
    }
    return dic;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad:%@",webView);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad:%@",webView);

    NSString *path = [[NSBundle mainBundle] pathForResource:@"uiwebview.js" ofType:nil];
    NSError *error = nil;
    NSString *jsContent = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"读取失败");
    }else{
        NSLog(@"注入成功");
    }
    [webView stringByEvaluatingJavaScriptFromString:jsContent];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webView_didFailLoadWithError:%@",error);
}

@end
