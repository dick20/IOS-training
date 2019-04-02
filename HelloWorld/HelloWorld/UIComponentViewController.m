//
//  UIComponentViewController.m
//  HelloWorld
//
//  Created by zhangtianfu on 2019/3/22.
//  Copyright © 2019 zhangtianfu. All rights reserved.
//

#import "UIComponentViewController.h"

@interface UIComponentViewController ()<UITextFieldDelegate, UITextViewDelegate>

@end

@implementation UIComponentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"UI控件";
    self.view.backgroundColor = [UIColor whiteColor];
    
#if 0
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 100)];
    label.text = @"UILabel是继承自UIView的一个显示控件，基本是除了UIView之外使用最广泛的控件";
    label.numberOfLines = 3;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor blueColor];
    label.backgroundColor = [UIColor grayColor];
    [label sizeToFit];
    [self.view addSubview:label];
#endif
    
#if 0
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 100)];
    UIFont *bigFont = [UIFont boldSystemFontOfSize:36];
    UIFont *smallFont = [UIFont boldSystemFontOfSize:bigFont.pointSize / 2];
    NSMutableAttributedString *attributeString6 = [[NSMutableAttributedString alloc] init];
    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:@"￥"
                                                                  attributes:@{NSFontAttributeName:smallFont,
                                                                               NSForegroundColorAttributeName:[UIColor blackColor],
                                                                               NSBaselineOffsetAttributeName:@(0)}];
    NSAttributedString *string2 = [[NSAttributedString alloc] initWithString:@"9"
                                                                  attributes:@{NSFontAttributeName:bigFont,
                                                                               NSForegroundColorAttributeName:[UIColor blueColor],
                                                                               NSBaselineOffsetAttributeName:@(0)}];
    NSAttributedString *string3 = [[NSAttributedString alloc] initWithString:@".99"
                                                                  attributes:@{NSFontAttributeName:smallFont,
                                                                               NSForegroundColorAttributeName:[UIColor blackColor],
                                                                               NSBaselineOffsetAttributeName : @(0)}];
    [attributeString6 appendAttributedString:string1];
    [attributeString6 appendAttributedString:string2];
    [attributeString6 appendAttributedString:string3];
    label.attributedText = attributeString6;
    [self.view addSubview:label];
#endif
    
#if 0
    UIImage *image = [UIImage imageNamed:@"test.png"];
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(20, 100, 200, 200);
        //    imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:imageView];
    }
    
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(20, 100+200+10, 200, 200);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:imageView];
    }
    
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(20, 100+200+10 + 200 + 10, 200, 200);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:imageView];
    }
#endif
    
#if 1
    UIImage *image1 = [UIImage imageNamed:@"animation1.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"animation2.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"animation3.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image1];
    imageView.animationImages = @[image1, image2, image3];
    imageView.animationDuration = 2;
    imageView.animationRepeatCount = 100;
    imageView.frame = CGRectMake(20, 100, 200, 200);
    [self.view addSubview:imageView];
    
    [imageView startAnimating];
#endif
    
#if 0
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 100, 150, 40);
    [button setTitle:@"HelloWorld" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"button_icon.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"button_bg.jpg"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"button_highlight_bg.jpg"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
#endif
    
#if 0
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchView.center = CGPointMake(100, 100);
    switchView.tintColor = [UIColor blueColor];
    switchView.onTintColor = [UIColor grayColor];
    switchView.thumbTintColor = [UIColor purpleColor];
    [switchView addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView];
#endif
    
#if 0
    UISwitch *switchVie2 = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchVie2.center = CGPointMake(200, 100);
    switchVie2.on = YES;
    switchVie2.tintColor = [UIColor blueColor];
    switchVie2.onTintColor = [UIColor grayColor];
    switchVie2.thumbTintColor = [UIColor purpleColor];
    [switchVie2 addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchVie2];
#endif
    
#if 0
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
    textField.placeholder = @"输入点什么吧";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    [self.view addSubview:textField];
#endif
    
#if 0
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 400, 400)];
    textView.text = @"欢迎来到UITextView的世界！欢迎来到UITextView的世界！欢迎来到UITextView的世界！";
    textView.font = [UIFont systemFontOfSize:20];
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor grayColor];
    textView.scrollEnabled = YES;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.delegate = self;
    [self.view addSubview:textView];
#endif
}

- (void)onSwitchChanged:(UISwitch*)sender {
    NSLog(@"isOn:%d", sender.isOn);
}

- (void)onButtonClick:(UIButton*)sender {
    NSLog(@"button click");
}


@end


