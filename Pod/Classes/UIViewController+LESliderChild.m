//
//  UIViewController+LESliderChield.m
//  PetProject
//
//  Created by Lucas Eduardo Chaves Frota on 09/03/14.
//  Copyright (c) 2014 Wemob. All rights reserved.
//

#import "UIViewController+LESliderChild.h"

#import <objc/runtime.h>
#import <objc/message.h>

static char SLIDER_SIDE_KEY;

@implementation UIViewController (LESliderChild)

@dynamic sliderSide;


- (void)setSliderSide:(LESliderSide)sliderSide
{
    objc_setAssociatedObject(self, &SLIDER_SIDE_KEY, @(sliderSide), OBJC_ASSOCIATION_ASSIGN);
}

- (LESliderSide)sliderSide
{
    NSNumber *sliderAsNumber = objc_getAssociatedObject(self, &SLIDER_SIDE_KEY);
    return [sliderAsNumber intValue];
}


-(void)dismissSliderController:(BOOL)animated {
    [(LESliderMainViewController*)self.presentingViewController dismissSliderViewController:self animated:animated completion:nil];
}




@end
