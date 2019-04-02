
#import "ViewController.h"
#import "AppDelegate.h"

#define Kboundary @"----WebKitFormBoundaryjv0UfA04ED44AhWx"
#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

@interface ViewController () <NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progress setProgress:0];

}

/*
 ###################### Download Task
 */
-(void)downloadFile
{
	// 设置url
    NSURL * url = [NSURL URLWithString:@"http://127.0.0.1:18081/download/test.txt"];
    // 创建Session。
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                                 delegate:self
                                                            delegateQueue: [NSOperationQueue mainQueue]];
    // 创建NSURLSessionDownloadTask。
    NSURLSessionDownloadTask * downloadTask =[ defaultSession downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
	  {
	  	  // 处理Response
	      if(error == nil)
	      {
	          NSLog(@"Temporary file =%@",location);

	          NSError *err = nil;
	          NSFileManager *fileManager = [NSFileManager defaultManager];
	          NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];


	          NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"out.zip"]];
	          if ([fileManager moveItemAtURL:location
	                                   toURL:docsDirURL
	                                   error: &err])
	          {
	              NSLog(@"File is saved to =%@",docsDir);
	          }
	          else
	          {
	              NSLog(@"failed to move: %@",[err userInfo]);
	          }
	      }
	  }];
    [downloadTask resume];
}

-(void)downloadFileWithProgress
{
    NSURL * url = [NSURL URLWithString:@"http://127.0.0.1:18081/download/test.txt"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];

    NSURLSessionDownloadTask * downloadTask =[ defaultSession downloadTaskWithURL:url];
    [downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Temporary File :%@\n", location);
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"test.txt"]];
    if ([fileManager moveItemAtURL:location
                             toURL:docsDirURL
                             error: &err])
    {
        NSLog(@"File is saved to =%@",docsDir);
    }
    else
    {
        NSLog(@"failed to move: %@",[err userInfo]);
    }

}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;

        [self.progress setProgress:progress animated:YES];

    NSLog(@"Progress =%f",progress);
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
     NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received String %@",str);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
            NSLog(@"Download is Succesfull");
        } else if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
            NSLog(@"Upload is Succesfull");
        }
    }
    else
        NSLog(@"Error %@",[error userInfo]);
}

-(void) sendHTTPGet
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 创建Session。
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://127.0.0.1:18081/user?id=1"];
	// 构建Request对象。
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 创建NSURLSessionDataTask。
    NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 执⾏Task
        if(error == nil)
        {
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
        }
        
    }];
    
    [dataTask resume];
}

-(void) sendHTTPPost
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 创建Session。
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];

    NSURL * url = [NSURL URLWithString:@"http://127.0.0.1:18081/edit"];
    // 构建可变的Request对象。
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * params =@"id=1&name=Test&age=50";
    // 设置请求⽅法为POST，设置请求体数据。
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    // 执⾏Task
    NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
    
}

-(void) httpPostWithCustomDelegate
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                                                      delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:@"http://127.0.0.1:18081/edit"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSString * params =@"id=1&name=Test2&age=30";
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask =[delegateFreeSession dataTaskWithRequest:urlRequest
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSLog(@"Response:%@ %@\n", response, error);
                                          if(error == nil) {
                                              NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSLog(@"Data = %@",text);
                                          }
                                      }];
    [dataTask resume];

}

/*
 Upload Task
 */

- (void)httpFileUpload:(NSString *)filePath {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:18081/upload/test"]];

    request.HTTPMethod = @"POST";

    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary] forHTTPHeaderField:@"Content-Type"];

    NSURLSessionUploadTask *task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]] uploadTaskWithRequest:request fromData:[self getBodyData:filePath]];
    [task resume];
}

-(NSData *)getBodyData:(NSString *)filePath
{
    NSMutableData *fileData = [NSMutableData data];
    //5.1 文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
     Content-Type: image/png(MIMEType:大类型/小类型)
     空行
     文件参数
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];

    //name:file 服务器规定的参数
    //filename:Snip20160225_341.png 文件保存到服务器上面的名称
    //Content-Type:文件的类型
    [fileData appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"test.txt\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"Content-Type: text/plain" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:KNewLine];

    NSData *testData = [NSData dataWithContentsOfFile:filePath];
    [fileData appendData:testData];
    [fileData appendData:KNewLine];

    //5.3 结尾标识
    /*
     --分隔符--
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@--",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return fileData;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    float progress = totalBytesSent * 1.0 / totalBytesExpectedToSend;
    dispatch_async(dispatch_get_main_queue(),^ {
        [self.progress setProgress:progress animated:YES];
    });
    NSLog(@"Progress =%f",progress);
    NSLog(@"Sent: %lld bytes (Total: %lld bytes)  Expected: %lld bytes.\n",
          bytesSent, totalBytesSent, totalBytesExpectedToSend);
}

/*
 ###################### Data Task END
 */

-(IBAction) httpGet:(id)sender
{
    [self sendHTTPGet];
}

-(IBAction) httpPost:(id)sender
{
    [self httpPostWithCustomDelegate];
}

-(IBAction)fileDownload:(id)sender
{
    [self downloadFileWithProgress];
}

-(IBAction)fileUpload:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    [self httpFileUpload:filePath];
}

@end
