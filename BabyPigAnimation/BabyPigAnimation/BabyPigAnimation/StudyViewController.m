//
//  StudyViewController.m
//  BabyPigAnimation
//
//  Created by hanbo on 2018/10/12.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "StudyViewController.h"
#import "DrawView.h"

@interface StudyViewController ()

/** <#注释#> */
@property (nonatomic, strong) UIView *aView;

/** <#注释#> */
@property (nonatomic, strong)  DrawView *drawView;

@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self createrSubViews]; // 动画
//    [self graffitiViews];  // 涂鸦绘图
      [self shapLayers]; // 原型进度条
}

- (void)shapLayers {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(375/2-100, 667/2-100, 200, 200)];
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3.0;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.repeatCount = 100;

    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;//图形填充色
    layer.path = path.CGPath;
    layer.lineWidth = 25.0;
    //圆的起始位置，默认为0
    layer.strokeStart = 0;
    //圆的结束位置，默认为1，如果值为0.75，则显示3/4的圆
    layer.strokeEnd = 1;
    [layer addAnimation:animation forKey:@"strokeEndAnimation"];
    
    [self.view.layer addSublayer:layer];
}

/** 涂鸦绘图 */
- (void)graffitiViews {
    
    DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    drawView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:drawView];
    self.drawView = drawView;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 500, 200, 40);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"撤销" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

/** 撤销上一笔绘制 */
- (void)undo:(UIButton *)sender {
    [self.drawView.lineArray removeLastObject];
    [self.drawView setNeedsDisplay];
}

- (void)createrSubViews {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    aView.backgroundColor = [UIColor redColor];
    [self.view addSubview:aView];
    self.aView = aView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 450, 280, 30);
    
    [button setTitle:@"Do Animation" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor yellowColor];
    
    [button addTarget:self action:@selector(doAinmation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];

}

- (void)doAinmation:(UIButton *)sender {
    
//    NSLog(@"开始动画");
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.aView.frame = CGRectMake(200, 200, 100, 100);
////        self.aView.alpha = 0.0;
//        self.aView.backgroundColor = [UIColor orangeColor];
    //    }];
    /*
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.aView.frame = CGRectMake(200, 200, 100, 100);
        self.aView.backgroundColor = [UIColor orangeColor];
    } completion:^(BOOL finished) {
        [self.aView removeFromSuperview];
    }];
     */
    
    /*
    // 属性动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, 100)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    animation.duration = 1;
//     key 动画名字
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation1.toValue = (id)[UIColor greenColor].CGColor;
    animation1.duration = 2;
    // key 动画名字
   
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation,animation1];
    
    // 动画组时长要大于等于最大动画时长
    group.duration = 2;
    
    [self.aView.layer addAnimation:group forKey:nil];
     */
    
    // 关键帧动画
    
    
   
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCGPoint:CGPointMake(100, 100)],
                           [NSValue valueWithCGPoint:CGPointMake(200, 150)],
                           [NSValue valueWithCGPoint:CGPointMake(140, 210)],
                           [NSValue valueWithCGPoint:CGPointMake(300, 400)],
                           [NSValue valueWithCGPoint:CGPointMake(120, 60)],
                           [NSValue valueWithCGPoint:CGPointMake(150, 200)],
                           [NSValue valueWithCGPoint:CGPointMake(150, 300)],nil];
    
    // 设置关键帧动画每一帧的时间,如果不设置.则每一帧时长相等
    // 设置的值是,每一帧动画结束的时候占用总时长的百分比
    keyAnimation.keyTimes = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.1],
                             [NSNumber numberWithFloat:0.2],
                             [NSNumber numberWithFloat:0.6],
                             [NSNumber numberWithFloat:0.8],
                             [NSNumber numberWithFloat:0.9],
                             [NSNumber numberWithFloat:1.0],nil];
    keyAnimation.duration = 5;
    [self.aView.layer addAnimation:keyAnimation forKey:nil];
    
    
    
}
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
