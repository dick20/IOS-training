//
//  SessionHelper.m
//  IM
//
//  Created by Ray Shaw on 2019/5/10.
//  Copyright © 2019年 zhulinyin. All rights reserved.
//

#import "SessionHelper.h"

@interface SessionHelper()

//@property (weak, nonatomic) NSString* serverURL = @"http://118.89.65.154:8000/";

@end


@implementation SessionHelper

+ (void)sendRequest:(NSString*)path method:(NSString*)method parameters:(NSString*)parameters handler:(void(^)(id))handler
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString* serverDomain = @"http://118.89.65.154:8000";
    NSString* urlString = [serverDomain stringByAppendingString:path];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:method];
    if (![parameters isEqual: @""])
    {
        NSString *params = [[NSString alloc] initWithString:parameters];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if(error == nil)
        {
            if(NSClassFromString(@"NSJSONSerialization"))
            {
                NSError *e = nil;
                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
                if(e)
                {
                  NSLog(@"error");
                }
                if([object isKindOfClass:[NSDictionary class]])
                {
                  handler(object);
                }
                else
                {
                  NSLog(@"Not dictionary");
                }
            }
        }
        else
        {
            NSLog(@"网络异常");
        }
    }];
    
    [task resume];
}

@end

