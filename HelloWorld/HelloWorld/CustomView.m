//
//  CustomView.m
//  HelloWorld
//
//  Created by zhangtianfu on 2019/3/22.
//  Copyright © 2019 zhangtianfu. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
#if 0
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 175, 110);
    CGContextAddLineToPoint(context, 260, 250);
    CGContextAddLineToPoint(context, 110, 250);
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 2);
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextFillPath(context);
    CGContextStrokePath(context);
#endif
    
#if 1
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(175, 110)];
    [path addLineToPoint:CGPointMake(260, 250)];
    [path addLineToPoint:CGPointMake(110, 250)];
    [path closePath];
    [path setLineWidth:2];
    [[UIColor greenColor] setFill];
    [[UIColor redColor] setStroke];
    [path fill];
    [path stroke];
#endif
    
#if 0
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 100, 300, 300) cornerRadius:150];
    [[UIColor blueColor] setStroke];
    [path stroke];

#endif
    
#if 0
    NSString *text = @"CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。";
    [text drawInRect:CGRectMake(0, 100, rect.size.width, rect.size.height) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
#endif
    
#if 0
    UIImage *image = [UIImage imageNamed:@"animation1.jpg"];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat drawWidth = rect.size.width - 10;
    CGFloat drawHeight = drawWidth * height/ width;
    [image drawInRect:CGRectMake(5, 100, drawWidth, drawHeight)];
#endif

    
}


@end
