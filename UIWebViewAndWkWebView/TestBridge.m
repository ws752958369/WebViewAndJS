//
//  TestBridge.m
//  UIWebViewAndWkWebView
//
//  Created by wangsheng on 2019/5/14.
//  Copyright © 2019 wangsheng. All rights reserved.
//

#import "TestBridge.h"

@implementation TestBridge

- (void)invoice:(id)params
{
    NSLog(@"invoice:%@",params);
}

- (void)invoice2:(id)params :(void(^)(id,NSError *))callback
{
    NSLog(@"invoice2:%@",params);
}

- (void)invoice3:(id)params :(void (^)(id _Nonnull))callback1 :(void (^)(id _Nonnull))callback2
{
    NSLog(@"invoice3:%@,%@,%@",params,callback1,callback2);
    if ([params[@"path"] isEqualToString:@"https:www/baidu.com"]) {
        callback1(@"oc callback");
    }else{
        NSDictionary *json = @{@"callback1":@110,@"callback2":@111};
        callback2([self jsonString:json]);
    }
}

- (NSString *)jsonString:(NSDictionary *)jsonDic
{
    NSMutableArray *array = [NSMutableArray array];
    for (id key in jsonDic) {
        id value = jsonDic[key];
        [array addObject:[NSString stringWithFormat:@"%@:%@",key,value]];
    }
    return [NSString stringWithFormat:@"{%@}",[array componentsJoinedByString:@","]];
}



@end
