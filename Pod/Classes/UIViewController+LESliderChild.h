//
//  UIViewController+LESliderChield.h
//  PetProject
//
//  Created by Lucas Eduardo Chaves Frota on 09/03/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LESliderMainViewController.h"

@interface UIViewController (LESliderChild)

/**
 holds the sliderSide value for this "child" controller.  See the LESliderSide enum to check the possible values
*/
@property(nonatomic, assign) LESliderSide sliderSide;


/**
 Dissmiss the controller that was presented by a LESliderMainViewController.

 @param animated Just tells if the dissmiss will be animated or not.
 
 */
-(void)dismissSliderController:(BOOL)animated;



@end
