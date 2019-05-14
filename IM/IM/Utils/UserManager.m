//
//  UserManager.m
//  IM
//
//  Created by zhulinyin on 2019/5/11.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import "UserManager.h"

@interface UserManager()
@property(strong, nonatomic) UserModel *loginUser;
@property(strong, nonatomic) SocketRocketUtility *socket;
@end

@implementation UserManager

static UserManager *instance = nil;


+(instancetype) getInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.socket = [SocketRocketUtility instance];
        instance.seq = 0;
    }) ;
    
    return instance;
}


+(id) allocWithZone:(struct _NSZone *)zone
{
    return [UserManager getInstance] ;
}


-(id) copyWithZone:(struct _NSZone *)zone
{
    return [UserManager getInstance] ;
}


-(UserModel*) getLoginModel
{
    return self.loginUser;
}


-(void) login:(NSString *)username withPassword:(NSString *)password
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"http://118.89.65.154:8000/account/login"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&password=%@", username, password];
    [urlRequest setHTTPMethod:@"post"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil) {
            if(NSClassFromString(@"NSJSONSerialization")) {
                NSError *e = nil;
                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
                if(e) {
                    NSLog(@"error");
                }
                if([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *result = object;
                    if([result[@"state"] isEqualToString:@"ok"]) {
                        NSLog(@"login success");
                        self.loginUser = [[UserModel alloc] initWithProperties:username NickName:username RemarkName:username Gender:@"man" Birthplace:@"guangzhou" ProfilePicture:@"peppa"];
                        [self.socket SRWebSocketOpen];
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        [UIApplication sharedApplication].keyWindow.rootViewController = mainStoryboard.instantiateInitialViewController;
                    }
                    else {
                        NSLog(@"login fail");
                    }
                }
                else {
                    NSLog(@"Not dictionary");
                }
            }
        }
        else {
            NSLog(@"网络异常");
        }
    }];
    [task resume];
}


-(void) logout
{
    [self.socket SRWebSocketClose];
    [self.socket wsOperate:@"close" data:self.loginUser.UserID];
}


-(void) register:(NSString *)username withPassword:(NSString *)password
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"http://118.89.65.154:8000/account/register"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&password=%@", username, password];
    [urlRequest setHTTPMethod:@"post"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil) {
            if(NSClassFromString(@"NSJSONSerialization")) {
                NSError *e = nil;
                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
                if(e) {
                    NSLog(@"error");
                }
                if([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *result = object;
                    if([result[@"state"] isEqualToString:@"ok"]) {
                        NSLog(@"register success");
                        self.loginUser = [[UserModel alloc] initWithProperties:username NickName:username RemarkName:username Gender:@"man" Birthplace:@"guangzhou" ProfilePicture:@"peppa"];
                        [self.socket SRWebSocketOpen];
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        [UIApplication sharedApplication].keyWindow.rootViewController = mainStoryboard.instantiateInitialViewController;
                    }
                    else {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"注册失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        NSLog(@"register fail");
                    }
                }
                else {
                    NSLog(@"Not dictionary");
                }
            }
        }
        else {
            NSLog(@"网络异常");
        }
    }];
    [task resume];
}
@end
