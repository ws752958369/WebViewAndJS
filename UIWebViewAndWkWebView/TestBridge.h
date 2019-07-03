//
//  TestBridge.h
//  UIWebViewAndWkWebView
//
//  Created by wangsheng on 2019/5/14.
//  Copyright © 2019 wangsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestBridge : NSObject
- (void)invoice:(id)params;
- (void)invoice2:(id)params :(void(^)(id,NSError *))callback;
- (void)invoice3:(id)params :(void(^)(id))callback1 :(void(^)(id))callback2;
@end

NS_ASSUME_NONNULL_END
