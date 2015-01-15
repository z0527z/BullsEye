//
//  ViewController.m
//  BullsEye
//
//  Created by dingql on 14-2-27.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ViewController ()
{
    int _currentValue;
    int _goal;
    int _scorePoint;
    int _count;
}

@end


@implementation ViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 背景
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"Background"];
    [self.view addSubview:bgView];
    
    // 描述文字
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 41, 319, 21)];
    titleLabel.text = @"Put the bull's eye as closer as you can to:";
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    // 目标分数
    UILabel * goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 5, CGRectGetMinY(titleLabel.frame), 30, CGRectGetHeight(titleLabel.frame))];
    goalLabel.textColor = [UIColor whiteColor];
    self.targetValue = goalLabel;
    [self.view addSubview:goalLabel];
    
    // 最小值
    UILabel * minLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 122, 10, 21)];
    minLabel.text = @"1";
    minLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:minLabel];
    
    // 最大值
    UILabel * maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(427, CGRectGetMinY(minLabel.frame), 30, CGRectGetHeight(minLabel.frame))];
    maxLabel.text = @"100";
    maxLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:maxLabel];
    
    // 滑动条
    UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(minLabel.frame) + 10, CGRectGetMinY(minLabel.frame), CGRectGetMinX(maxLabel.frame) - CGRectGetMaxX(minLabel.frame) - 20, 34)];
    slider.center = CGPointMake(slider.center.x, CGRectGetMidY(minLabel.frame));
    self.slider = slider;
    [self.view addSubview:slider];
    
    UIImage * thumbNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    [self.slider setThumbImage:thumbNormal forState:UIControlStateNormal];
    UIImage * thumbHighlighted = [UIImage imageNamed:@"SliderThumb-highlighted"];
    [self.slider setThumbImage:thumbHighlighted forState:UIControlStateHighlighted];
    
    UIImage * trackLeft = [[UIImage imageNamed:@"SliderTrackLeft"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    [self.slider setMinimumTrackImage:trackLeft forState:UIControlStateNormal];
    UIImage * trackRight = [[UIImage imageNamed:@"SliderTrackRight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    [self.slider setMaximumTrackImage:trackRight forState:UIControlStateNormal];
    
    // 开始按钮
    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(185, 181, 100, 37);
    [startBtn setBackgroundImage:[UIImage imageNamed:@"Button-Normal.png"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"Button-Highlighted.png"] forState:UIControlStateHighlighted];
    [startBtn setTitle:@"Hit Me" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(ShowScore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    // 重置按钮
    UIButton * resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake(20, 264, 32, 32);
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"StartOverButton.png"] forState:UIControlStateNormal];
    [resetBtn setImage:[UIImage imageNamed:@"StartOverIcon.png"] forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
    
    // 分数描述
    UILabel * scroreDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 269, 50, 21)];
    scroreDescLabel.text = @"Score:";
    scroreDescLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:scroreDescLabel];
    
    // 分数
    UILabel * scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scroreDescLabel.frame) + 10, CGRectGetMinY(scroreDescLabel.frame), 58, CGRectGetHeight(scroreDescLabel.frame))];
    self.score = scoreLabel;
    scoreLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:scoreLabel];
    
    // 回合描述
    UILabel * roundDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(scoreLabel.frame) + 20, CGRectGetMinY(scoreLabel.frame), 56, CGRectGetHeight(scoreLabel.frame))];
    roundDescLabel.text = @"Round:";
    roundDescLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:roundDescLabel];
    
    // 回合
    UILabel * roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(roundDescLabel.frame) + 10, CGRectGetMinY(roundDescLabel.frame), 30, CGRectGetHeight(roundDescLabel.frame))];
    self.round = roundLabel;
    roundLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:roundLabel];
    
    // 信息展示
    UIButton * infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoBtn.frame = CGRectMake(434, 269, 22, 22);
    [infoBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoBtn];
    
    [self resetGame];
    [self updateLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateLabels
{
    self.round.text = [NSString stringWithFormat:@"%d", _count];
    self.targetValue.text = [NSString stringWithFormat:@"%d", _goal];
    self.score.text = [NSString stringWithFormat:@"%d", _scorePoint];
}

- (IBAction)valueChanged:(UISlider *)sender {
    _currentValue = lroundf(sender.value);
}

- (void) makeGoal
{
    _goal = arc4random()% 99 + 1;
}

- (IBAction)resetGame{
    _currentValue = 50;
    _count = 1;
    _scorePoint = 0;
    _count = 1;
    CATransition * transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    self.slider.value = _currentValue;
    [self makeGoal];
    [self updateLabels];
    
    [self.view.layer addAnimation:transition forKey:nil];
}

- (IBAction)ShowScore:(id)sender {
    int result = _goal - abs(_currentValue - _goal);
    _scorePoint += result;
    _count++;
    NSString * message = [NSString stringWithFormat:@"本次得分: %d", result];
    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"结果" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
    
    [self makeGoal];
    [self updateLabels];
}

- (IBAction)showInfo {
    
    AboutViewController * about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    about.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:about animated:YES completion:^{
        
    }];
    
}
@end
