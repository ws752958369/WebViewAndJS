//
//  WSExtension.m
//  UIWebViewAndWkWebView
//
//  Created by wangsheng on 2019/5/16.
//  Copyright © 2019 wangsheng. All rights reserved.
//

#import "WSExtension.h"

@implementation WSExtension
- (NSString *)ws_jsonString
{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }else if ([self isKindOfClass:[NSData class]]){
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)ws_jsonObj
{
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[(NSString *)self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }else if ([self isKindOfClass:[NSData class]]){
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    return nil;
}
@end
