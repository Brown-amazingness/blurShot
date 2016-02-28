//
//  ViewController.h
//  BlurShot
//
//  Created by Umar on 1/22/16.
//  Copyright © 2016 Shazia Haroon. All rights reserved.
//
@import KCFloatingActionButton;




#import <UIKit/UIKit.h>
#import "FXBlurView.h"



@interface ViewController : UIViewController

@property UIImage *screengrab;

@property (weak, nonatomic) IBOutlet UILabel *TutorialLabel;


@property (weak, nonatomic) IBOutlet KCFloatingActionButton *menuButton;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *blurSlider;
- (IBAction)blurSliderMoved:(UISlider *)sender;

@end

