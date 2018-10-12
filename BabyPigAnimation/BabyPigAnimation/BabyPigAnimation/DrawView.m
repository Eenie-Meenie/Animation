//
//  DrawView.m
//  BabyPigAnimation
//
//  Created by hanbo on 2018/10/12.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

- (NSMutableArray *)lineArray {
    if (!_lineArray) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        <#statements#>
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSMutableArray *pointArray = [NSMutableArray array];
    [self.lineArray addObject:pointArray];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    // 点转字符串
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    NSMutableArray *pointArray = [_lineArray lastObject];
    
    NSValue *pointValue = [NSValue valueWithCGPoint:point];
    
    [pointArray addObject:pointValue];
    
    // 重绘界面, 会调用drawRect方法
    [self setNeedsDisplay];
    
}

///** 当view修改frame的时候会调用这个方法 */
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//
//    // 1.在drawRect拿到上下文. 2.通过一个image图片拿到上下文
//    // 得到上下文,绘画的配置信息
//    CGContextRef contentRef = UIGraphicsGetCurrentContext();
//    // 设置画笔颜色
//    CGContextSetStrokeColorWithColor(contentRef, [UIColor redColor].CGColor);
//    // 设置画笔的族系
//    CGContextSetLineWidth(contentRef, 2.0);
//
//    for (int i = 0; i < _lineArray.count; i ++) {
//        NSMutableArray *pointArray = _lineArray[i];
//
//        for (int j = 0; j < (int)pointArray.count-1; j ++) {
//            NSValue *firstPointValue = pointArray[j];
//            NSValue *secondPointValue = pointArray[j + 1];
//
//            CGPoint firstPoint = [firstPointValue CGPointValue];
//            CGPoint secondPoint = [secondPointValue CGPointValue];
//
//            /** 把笔触移动到一个点 */
//            CGContextMoveToPoint(contentRef, firstPoint.x, firstPoint.y);
//            /** 笔触和另外一个点要连城一个路径 */
//            CGContextAddLineToPoint(contentRef, secondPoint.x, secondPoint.y);
//        }
//    }
//    // 绘制路线
//    CGContextStrokePath(contentRef);
//}

- (void)drawRect:(CGRect)rect {
    //1.获取图形上下文,目前我们现在使用的都是UIGraphics开头,CoreGraphics,项目的简称CG
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.描述路径
    //2.1 创建路径
    CGContextMoveToPoint(ctx, 100, 100);
    //2.2 添加线到一个点
    CGContextAddLineToPoint(ctx, 200, 200);
    //3.完成路线
    CGContextStrokePath(ctx);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //2.画线
    [path moveToPoint:CGPointMake(100, 200)];
    [path addLineToPoint:CGPointMake(240, 300)];
    //3.渲染
    [path stroke];
    
    //绘制一个原形（不规范的绘制）
    UIBezierPath *path3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(140, 200, 100, 100) cornerRadius:50];
    [[UIColor redColor] set];
    [path3 stroke];  // 绘制边框
//    [path3 fill];   填充颜色
    
}

 
  


@end
