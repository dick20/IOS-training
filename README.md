# IOS-training
中山大学IOS实训项目

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
@property (nonatomic, strong) DatabaseHelper *databaseHelper;
@property (nonatomic, strong) NSMutableArray *chatMsg;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@end

@implementation ChatViewController

- (instancetype)initWithContact:(UserModel *)chatUser
{
    self = [super init];
    if (self)
    {
        self.loginUser = [[UserManager getInstance] getLoginModel];
        self.chatUser = chatUser;
        self.databaseHelper = [DatabaseHelper getInstance];
        self.chatMsg = [self.databaseHelper queryAllMessagesWithChatId:chatUser.UserID];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];

    self.chatView = [[ChatView alloc] init];
    self.chatView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.chatView.delegate = self;

    self.chatView.chatMsg = self.chatMsg;
    [self.view addSubview:self.chatView];
    
    // 发送图片按钮
    [self.chatView.imageButton addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.chatView tableViewScrollToBottom];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessages:) name:@"newMessages" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.chatMsg.count > 0) {
        SessionModel *session = [[SessionModel alloc] initWithChatId:self.chatUser.UserID withChatName:self.chatUser.NickName withProfilePicture:self.chatUser.ProfilePicture withLatestMessageContent:[self.chatMsg[self.chatMsg.count-1] Content] withLatestMessageTimeStamp:[self.chatMsg[self.chatMsg.count-1] TimeStamp]
                                 withUnreadNum:0];
        [self.databaseHelper insertSessionWithSession:session];
    }
    
}

- (void)getNewMessages:(NSNotification *)notification{
    NSArray *messages = [notification object];
    for (int i=0; i<messages.count; i++) {
        MessageModel *message = messages[i];
        if([message.SenderID isEqualToString:self.chatUser.UserID]) {
            [self addMessage:message];
        }
    }
    //NSLog(@"%@", messages);
}

//delegate
- (void)sendMessage:(NSString *)type text:(NSAttributedString *)text {
    MessageModel* message = [[MessageModel alloc] init];
    message.Type = type;
    message.SenderID = self.loginUser.UserID;
    message.ReceiverID = self.chatUser.UserID;
    message.Content = text;
    message.TimeStamp = [NSDate date];
    [self addMessage:message];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [URLHelper getURLwithPath:[[NSString alloc] initWithFormat:@"/content/%@", type]];
    NSDictionary* params = @{@"to":self.chatUser.UserID, @"data":text.string, @"timestamp":[self.dateFormatter stringFromDate:message.TimeStamp]};
    
    [manager POST:url parameters:params progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([responseObject[@"state"] isEqualToString:@"ok"])
             {
                 NSLog(@"send success");
                 [self.databaseHelper insertMessageWithMessage:message];
             }
             else
             {
                 NSLog(@"send fail");
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"send fail");
             NSLog(@"%@", error.localizedDescription);
         }];
}

//新增消息
- (void)addMessage:(MessageModel* )message {
    [self.chatMsg addObject:message];
    self.chatView.chatMsg = self.chatMsg;
}

// 发送图片
- (void)sendImage:(UIImage *)image {
    // 本地显示部分
    //2.初始化富文本对象
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"test"];
    
    //3.初始化NSTextAttachment对象
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = CGRectMake(0, 0, 100, 100);//设置frame
    attchment.image = image;//设置图片
    
    //4.创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//    [attributedString insertAttributedString:string atIndex:0];//插入到第几个下标
    [attributedString appendAttributedString:string];   //添加到尾部
    
    
    MessageModel* message = [[MessageModel alloc] init];
    message.Type = @"image";
    message.SenderID = self.loginUser.UserID;
    message.ReceiverID = self.chatUser.UserID;
    message.Content = attributedString;
    message.TimeStamp = [NSDate date];
    [self addMessage:message];
    
    // 网络部分
    NSString* path = @"/content/image";
    NSDate* timestamp = [NSDate date];
    NSString* userName = self.chatUser.UserID;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    // 处理url
    NSString* urlString = [URLHelper getURLwithPath:path];
    NSLog(@"%@", urlString);
    // 添加参数
    NSDictionary* params = @{@"to":userName, @"timestamp":timestamp};
    // 发送图片
    [manager POST:urlString parameters:params constructingBodyWithBlock:
     ^(id<AFMultipartFormData> _Nonnull formData){
         // 图片转data
         NSData *data = UIImagePNGRepresentation(image);
         [formData appendPartWithFileData :data name:@"file" fileName:@"928-1.png"
                                  mimeType:@"multipart/form-data"];
     } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject){
         NSLog(responseObject[@"msg"]);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
         NSLog(@"sendImage fail");
         NSLog(@"%@", error.localizedDescription);
     }];
    
    //     测试，成功读取图片
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    [imageView setFrame:CGRectMake(0, 0, 200, 200)];
//    [self.view addSubview:imageView];
}

// 选择图片
- (void)chooseImage:(UIButton *)btn
{
    [self alterHeadPortrait];
}

- (void)alterHeadPortrait{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    // 判断授权情况
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 无权限
        NSLog(@"no auth");
    }
    else{
        NSLog(@"has auth!!!!!");
    }
    
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *) info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    NSLog(urlStr);
    [self dismissViewControllerAnimated:YES completion:nil];
    // 上传到云端
    [self sendImage:newPhoto];
    
//     测试，成功读取图片
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:newPhoto];
//    [imageView setFrame:CGRectMake(0, 0, 200, 200)];
//    [self.view addSubview:imageView];
}

@end

