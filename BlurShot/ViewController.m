//
//  ViewController.m
//  BlurShot
//
//  Created by Umar on 1/22/16.
//  Copyright © 2016 Shazia Haroon. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property UIImage *screengrab;
@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.blurView.tintColor = [UIColor clearColor];
    
    
    [self prefersStatusBarHidden];
    self.blurView.blurRadius = self.blurSlider.value;
    self.blurView.blurEnabled = NO;
    
    if (_imageView.image) {
        self.TutorialLabel.hidden = YES;
        self.TutorialLabel.alpha = 0;
    }else{
        //Show label
        [self.view bringSubviewToFront:_TutorialLabel];
    }

    
    //AD Stuff

    
    
    
    __block UIImagePickerController *picker;
    __block UIActivityViewController *activityVC;

    __weak KCFloatingActionButton *_fab = self.menuButton;
    [self.menuButton addItem:@"Upload Image" icon:[UIImage imageNamed:@"UploadArrow"] handler:^(KCFloatingActionButtonItem *item) {
        
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker animated:YES completion:^{
            }];
        }];
        
        self.TutorialLabel.hidden = YES;
        self.TutorialLabel.alpha = 0;
        
        [_fab close];
    }];

    [self.menuButton addItem:@"Toggle Dark Background" icon:[UIImage imageNamed:@"DarkMode"]handler:^(KCFloatingActionButtonItem *item){
        self.TutorialLabel.hidden = YES;
        self.TutorialLabel.alpha = 0;
        if (_imageView.backgroundColor != [UIColor blackColor]) {
            _imageView.backgroundColor = [UIColor blackColor];
        }else{
            _imageView.backgroundColor = [UIColor whiteColor];
        }
    }];
    [self.menuButton addItem:@"Save Image" icon:[UIImage imageNamed:@"Save"]handler:^(KCFloatingActionButtonItem * item) {
        [_fab close];
        [self screenshotAndSaveImage:YES];
    }];
    [self.menuButton addItem:@"Share" icon:[UIImage imageNamed:@"Share"] handler:^(KCFloatingActionButtonItem * item) {
        
        [self screenshotAndSaveImage:NO];
        NSString *message = [NSString stringWithFormat:@"Check out this awesome wallpaper from the app blurShot!"];
        
        NSArray *activityVCItems = [NSArray arrayWithObjects:message,_screengrab, nil];
        activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityVCItems applicationActivities:nil];
        activityVC.popoverPresentationController.sourceView = self.blurView;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:activityVC animated:YES completion:^{
            }];
        }];
        
                       
                       
                           
        [_fab close];
    }];
    
    //gestures!
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(createSelectiveBlur:)];
    [self.view addGestureRecognizer:pan];
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}



- (IBAction)blurSliderMoved:(UISlider *)sender {
    self.blurView.blurEnabled = YES;
    self.blurView.blurRadius = sender.value;
    
}


-(void)createSelectiveBlur:(UIPanGestureRecognizer *)pan{
    //We need to check if selective blurring is toggled
    //if (selectiveBlurEnabled)
    
    
    
    CGPoint start;
    CGPoint end;
    CGFloat width;
    CGFloat height;
    
    if (pan.state == UIGestureRecognizerStateBegan ) {
        start = [pan translationInView:self.view];
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        end = [pan locationInView:self.view];
        width = fabs(start.x - end.x);
        height = fabs(start.y - end.y);
        CGRect frame = CGRectMake(end.x, end.y, width, height);
        _blurView.frame = frame;
    }
    
}
-(void)screenshotAndSaveImage:(BOOL)saveImage
{
    
    UIView *wholeScreen = self.blurView;

    // define the size and grab a UIImage from it
    self.menuButton.hidden = YES;
    self.blurSlider.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(wholeScreen.bounds.size, YES, 0.5);
    [wholeScreen.layer renderInContext:UIGraphicsGetCurrentContext()];
    [wholeScreen drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    UIImage *screengrab = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.screengrab = screengrab;
    if (saveImage) {
        UIImageWriteToSavedPhotosAlbum(_screengrab, nil, nil, nil);
    }
    self.menuButton.hidden = NO;
    self.blurSlider.hidden = NO;
    
    


}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
