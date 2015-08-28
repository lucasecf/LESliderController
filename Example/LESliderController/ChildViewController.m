//
//  ChildViewController.m
//  LESliderDemo
//
//  Created by Lucas Eduardo on 24/06/15.
//  Copyright (c) 2015 Lucas Eduardo. All rights reserved.
//

#import "ChildViewController.h"
#import "UIViewController+LESliderChild.h"

@interface ChildViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnDidTouch:(id)sender {
    [self dismissSliderController:YES];
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
