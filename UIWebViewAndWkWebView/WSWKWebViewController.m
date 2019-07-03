//
//  WSWKWebViewController.m
//  UIWebViewAndWkWebView
//
//  Created by wangsheng on 2019/3/4.
//  Copyright © 2019 wangsheng. All rights reserved.
//

#import "WSWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "VKMsgSend.h"

static NSString *const MessageHandler = @"WSMessageHandler";
@interface WSWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,strong)WKWebView *webView;
@end

@implementation WSWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backDismiss)];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //解决有时加载本地资源文件不全的问题
    [configuration.preferences setValue:@(true) forKey:@"allowFileAccessFromFileURLs"];
    
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    [userController addScriptMessageHandler:self name:MessageHandler];
    
    NSString *source = [NSString stringWithFormat:
                        @"window.%@ = {"
                        "  postMessage: function (data) {"
                        "    window.webkit.messageHandlers.%@.postMessage(String(data));"
                        "  }"
                        "};", MessageHandler, MessageHandler
                        ];
    
    WKUserScript *jsscript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userController addUserScript:jsscript];
    /*
     
    
     
     */
    
    configuration.userContentController = userController;
    
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,64,self.view.bounds.size.width,self.view.bounds.size.height-64) configuration:configuration];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    NSString *pathHtml = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    [self.webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:pathHtml]]];return;
    
    NSString *path111 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    //dist,web,web1
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/web/index.html",path111]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if ([request.URL.lastPathComponent isEqualToString:@"index.html"]) {
        [self.webView evaluateJavaScript:@"" completionHandler:^(id _Nullable res, NSError * _Nullable error) {
            NSLog(@"js errror:%@m,res:%@",error,res);
        }];
        
        [self.webView loadFileURL:request.URL allowingReadAccessToURL:request.URL.URLByDeletingLastPathComponent];
        
        return;
    }
    [self.webView loadFileURL:request.URL allowingReadAccessToURL:request.URL];
    
    
    /*
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.102:3000/index.html#/make"]];
    [self.webView loadRequest:request];*/
    
    
}

- (void)backDismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"webView_didFailProvisionalNavigation:%@",error);
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"webView_didCommitNavigation");
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"webView_didFinishNavigation");
}


#pragma mark - WKScriptMessageHandler
//js call oc
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"message:%@,%@,%@",message.body,message.name,message.frameInfo);
    if ([message.name isEqualToString:MessageHandler]) {
        //解析body
        if ([message.body isKindOfClass:[NSString class]]) {
            NSError *error ;
            NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:[message.body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                NSLog(@"message.body数据类型错误,无法解析");
            }else{
                __weak typeof(self)weakSelf= self;
                NSString *successCallback = jsonBody[@"successCallback"];
                NSString *failureCallback = jsonBody[@"failCallback"];
                
                id a =  ^(id res){
                    __strong typeof(self)strongSelf = weakSelf;
                    [strongSelf callbackWithName:successCallback response:res webView:strongSelf.webView];
                };
                
                id b = ^(id res){
                    __strong typeof(self)strongSelf = weakSelf;
                    [strongSelf callbackWithName:failureCallback response:res webView:strongSelf.webView];
                };
                
                [self vk_callSelectorWithClassName:jsonBody[@"className"] functionName:jsonBody[@"functionName"] params:jsonBody[@"params"] success:successCallback?a:nil fail:failureCallback?b:nil];
            }
        }
    }
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

- (void)callbackWithName:(NSString *)callbackName response:(id)resp webView:(WKWebView *)webView
{
    NSString *jsResource = [NSString stringWithFormat:@"%@('%@')",callbackName,resp];
    jsResource = [jsResource stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [self.webView evaluateJavaScript:jsResource completionHandler:^(id _Nullable resp, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",error);
        }else{
            NSLog(@"resp:%@",resp);
        }
    }];
}


-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"message1:%@,frame1:%@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    NSLog(@"message2:%@,frame2:%@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    NSLog(@"prompt:%@,defaultText:%@,frame:%@",prompt,defaultText,frame);
    completionHandler(@"alert");
}
@end
