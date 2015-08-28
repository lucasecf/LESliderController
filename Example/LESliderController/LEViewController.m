//
//  LEViewController.m
//  LESliderController
//
//  Created by Lucas Eduardo on 08/27/2015.
//  Copyright (c) 2015 Lucas Eduardo. All rights reserved.
//

#import "LEViewController.h"


@interface LEViewController ()

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@end

@implementation LEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.cacheControllers = NO;
    
    UIViewController *rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];
    [self registerTriggerView:self.rightButton toViewController:rightViewController onSide:LESliderSideRight];
    [self addSliderGesture:LESliderSideRight toTriggerView:self.rightButton];
    
    UIViewController *leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    [self registerTriggerView:self.leftButton toViewController:leftViewController onSide:LESliderSideLeft];
    [self addSliderGesture:LESliderSideLeft toTriggerView:self.leftButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftButtonDidTouch:(id)sender {
//    UIViewController *leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
//    [self registerTriggerView:self.leftButton toViewController:leftViewController onSide:LESliderSideLeft];
    [self showRegisteredViewControllerForTriggerView:sender animated:YES completion:nil];
}


- (IBAction)rightButtonDidTouch:(id)sender {
//    UIViewController *rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];
//    [self registerTriggerView:self.rightButton toViewController:rightViewController onSide:LESliderSideRight];
    [self showRegisteredViewControllerForTriggerView:sender animated:YES completion:nil];
}



@end
