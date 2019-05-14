//
//  ChatViewController.m
//  IM
//
//  Created by zhulinyin on 2019/5/8.
//  Copyright © 2019 zhulinyin. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatView.h"
@interface ChatViewController () <ChatViewDelegate>
@property (nonatomic, strong) ChatView *chatView;
@property (nonatomic, strong) UserModel *loginUser;
@property (nonatomic, strong) UserModel *chatUser;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.loginUser = [[UserManager getInstance] getLoginModel];
    self.chatUser = [[UserModel alloc] initWithProperties:@"321" NickName:@"321" RemarkName:@"321" Gender:@"man" Birthplace:@"guangzhou" ProfilePicture:@"teemo"];
    
    self.chatView = [[ChatView alloc] init];
    self.chatView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.chatView.delegate = self;
    [self.view addSubview:self.chatView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessages:) name:@"newMessages" object:nil];
}

- (void)getNewMessages:(NSNotification *)notification{
    NSArray *messages = [notification object];
    for (int i=0; i<messages.count; i++) {
        if([messages[i][@"From"] isEqualToString:self.chatUser.UserID]) {
            [self addMessage:messages[i][@"Type"] from:messages[i][@"From"] text:messages[i][@"content"]];
        }
    }
    //NSLog(@"%@", messages);
}

//delegate
- (void)sendMessage:(NSString *)type text:(NSString *)text {
    [self addMessage:type from:self.loginUser.UserID text:text];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://118.89.65.154:8000/content/%@", type]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [[NSString alloc] initWithFormat:@"to=%@&data=%@", self.chatUser.UserID, text];
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
                        NSLog(@"send success");
                    }
                    else {
                        NSLog(@"send fail");
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

//新增消息
- (void)addMessage:(NSString *)type from:(NSString *)from text:(NSString *)text {
    
    MessageModel *msgModel = [[MessageModel alloc] init];
    msgModel.Type = type;
    msgModel.SenderID = from;
    msgModel.Content = text;
    [self.chatView addMessage:msgModel];
}

@end
