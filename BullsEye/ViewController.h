//
//  ViewController.h
//  BullsEye
//
//  Created by dingql on 14-2-27.
//  Copyright (c) 2014年 dingql. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *targetValue;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *round;
- (IBAction)valueChanged:(UISlider *)sender;
- (IBAction)resetGame;
- (IBAction)ShowScore:(id)sender;
- (IBAction)showInfo;


@end
