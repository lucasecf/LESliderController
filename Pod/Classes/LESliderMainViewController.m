//
//  LESliderMainViewController.m
//  LESlideTransition
//
//  Created by Lucas Eduardo  Chaves Frota on 20/10/13.
//  Copyright (c) 2013 Lucas Eduardo Chaves Frota. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "LESliderMainViewController.h"
#import "UIViewController+LESliderChild.h"


@interface LESliderMainViewController ()
{
    CGFloat _initialValue;
    CGFloat _endValue;
    
    CGFloat _initialWidthValue;
    CGFloat _finalWidthValue;
    
    CGFloat _initialHeightValue;
    CGFloat _finalHeightValue;
    
    CGFloat _offset;
    
    UIView *_selectedTriggerView;
    
    UIImageView *_snapshotView;
    
    UIColor *_originalBackgroundColor;
    
    NSMutableDictionary *_mappedViewControllers;
}

@property (assign, atomic) BOOL animating;

@end


#pragma mark - private methods signature
@interface LESliderMainViewController (private)

#pragma mark - show aux methods
- (void)showSliderViewController:(UIViewController*)viewController duration:(NSTimeInterval)duration animated:(BOOL)animated completion:(void(^)(void))completionBlock;

#pragma mark - dismiss aux methods
- (void)dismissView:(UIView*)animatedView ofController:(UIViewController*)viewController duration:(NSTimeInterval)duration animated:(BOOL)animated completion:(void(^)(void))completionBlock;

#pragma mark - gesture recognizers
- (void)slideRightViewController:(UIPanGestureRecognizer*)recognizer;
- (void)slideLeftViewController:(UIPanGestureRecognizer*)recognizer;

#pragma mark - Auxiliary and other methods
- (void)addChildViewControllerSubviewIfNotYet:(UIViewController*)viewController;
- (void)resizeBackgroundWithValue:(CGFloat)value;
- (void)handleBackgroundBeforeDragging;
- (void)handleBackgroundAfterDragging;
- (void)blockUserInteration:(BOOL)mustBlock;
- (UIImage*)snapshotOfView:(UIView*)view;

@end


@implementation LESliderMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mappedViewControllers = [NSMutableDictionary new];
    
    //default values
    self.showLeftLimitValue = self.showRightLimitValue = self.view.center.x;
    self.animationPresentingDuration = 0.7;
    self.animationDismissDuration = 0.4;
    self.voidColor = [UIColor blackColor];
    self.cacheControllers = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_snapshotView) {
        _snapshotView = [[UIImageView alloc] initWithImage:[self snapshotOfView:self.view]];
        _snapshotView.frame = self.view.frame;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _initialWidthValue = 150;
    _finalWidthValue = self.view.bounds.size.width;
    _initialHeightValue = (self.view.bounds.size.height/self.view.bounds.size.width) * _initialWidthValue;
    _finalHeightValue = self.view.bounds.size.height;
}

#pragma mark - setup methods

-(void)registerTriggerView:(UIView*)triggerView toViewController:(UIViewController*)viewController onSide:(LESliderSide)sliderSide
{
    viewController.sliderSide = sliderSide;
    _mappedViewControllers[[NSString stringWithFormat:@"%p", triggerView]] = viewController;
}


- (void)addSliderGesture:(LESliderSide)sliderSide toTriggerView:(UIView*)triggerView
{
    if(sliderSide == LESliderSideLeft)
    {
        UIPanGestureRecognizer *leftSliderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideLeftViewController:)];
        [triggerView addGestureRecognizer:leftSliderGesture];
    }
    else
    {
        UIPanGestureRecognizer *rightSliderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideRightViewController:)];
        [triggerView addGestureRecognizer:rightSliderGesture];
    }
}


#pragma mark - show controllers

- (void)showRegisteredViewControllerForTriggerView:(UIView*)triggerView animated:(BOOL)animated completion:(void(^)(void))completionBlock
{
    UIViewController *viewController = _mappedViewControllers[[NSString stringWithFormat:@"%p", triggerView]];
    NSAssert(viewController != nil, @"Presented controller cannot be nil. Maybe you dismiss it, didn't cache it and is trying to present it again without registering?");
    
    if (!self.animating) {
        _selectedTriggerView = triggerView;
        [self handleBackgroundBeforeDragging];
        [self showSliderViewController:viewController duration:self.animationPresentingDuration animated:animated completion:completionBlock];
    }
}

#pragma mark - dismiss controllers

- (void)dismissSliderViewController:(UIViewController*)viewController animated:(BOOL)animated completion:(void(^)(void))completionBlock
{
    [self dismissSliderViewController:viewController duration:self.animationPresentingDuration animated:animated completion:completionBlock];
}


- (void)dismissSliderViewController:(UIViewController*)viewController duration:(NSTimeInterval)duration animated:(BOOL)animated completion:(void(^)(void))completionBlock
{
    if (animated)
    {
        if (self.presentedViewController)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewController.view.frame];
            imageView.image = [self snapshotOfView:viewController.view];
            [self.view addSubview:imageView];
            [self.view bringSubviewToFront:imageView];
            
            [viewController dismissViewControllerAnimated:NO completion:^{
                [self dismissView:imageView ofController:viewController duration:duration animated:animated completion:completionBlock];
            }];
        }
        else
        {
            [self dismissView:viewController.view ofController:viewController duration:duration animated:animated completion:completionBlock];
        }
    }
    else
    {
        CGFloat finalValue = (viewController.sliderSide == LESliderSideLeft) ? 0.0 : viewController.view.frame.size.width;
        
        [self resizeBackgroundWithValue:finalValue];
        [self handleBackgroundAfterDragging];
        [self blockUserInteration:NO];
        
        [viewController dismissViewControllerAnimated:NO completion:completionBlock];
    }
}

@end


@implementation LESliderMainViewController (private)


#pragma mark - show aux methods

- (void)showSliderViewController:(UIViewController*)viewController duration:(NSTimeInterval)duration animated:(BOOL)animated completion:(void(^)(void))completionBlock
{
    [self addChildViewControllerSubviewIfNotYet:viewController];
    
    [self.view bringSubviewToFront:viewController.view];
    CGFloat finalValue = (viewController.sliderSide == LESliderSideLeft) ? self.view.frame.size.width : 0.0;
    
    if (animated)
    {
        [UIView animateWithDuration:duration animations:
         ^{
             viewController.view.center = CGPointMake(self.view.center.x, viewController.view.center.y);
             
             [self resizeBackgroundWithValue:finalValue];
             
         } completion:^(BOOL finished){
             
             [self presentViewController:viewController animated:NO completion:nil];
             
             if (completionBlock) {
                 completionBlock();
             }
         }];
    }
    else
    {
        viewController.view.center = CGPointMake(self.view.center.x, viewController.view.center.y);
        [self resizeBackgroundWithValue:finalValue];
        [self presentViewController:viewController animated:NO completion:nil];
    }
}



#pragma mark - dismiss aux methods

- (void)dismissView:(UIView*)animatedView ofController:(UIViewController*)viewController duration:(NSTimeInterval)duration animated:(BOOL)animated completion:(void(^)(void))completionBlock {
    
    CGFloat finalValue = (viewController.sliderSide == LESliderSideLeft) ? 0.0 : viewController.view.frame.size.width;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGPoint finalCenter = (viewController.sliderSide == LESliderSideLeft) ?
        CGPointMake(-viewController.view.frame.size.width/2.0, animatedView.center.y) :
        CGPointMake(self.view.frame.size.width + viewController.view.frame.size.width/2.0, animatedView.center.y);
        
        animatedView.center = finalCenter;
        
        [self resizeBackgroundWithValue:finalValue];
        
    } completion:^(BOOL finished) {
        if(finished) {
            [viewController dismissViewControllerAnimated:NO completion:nil];
            [self handleBackgroundAfterDragging];
            [self blockUserInteration:NO];
            
            [animatedView removeFromSuperview];
            [viewController.view removeFromSuperview];
            
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}


#pragma mark - gesture recognizers

- (void)slideLeftViewController:(UIPanGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    UIViewController *viewController = _mappedViewControllers[[NSString stringWithFormat:@"%p", recognizer.view]];
    _selectedTriggerView = (UIButton*)recognizer.view;
    
    [self addChildViewControllerSubviewIfNotYet:viewController];
    
    if([recognizer state] == UIGestureRecognizerStateBegan)
    {
        _offset = point.x;
        [self handleBackgroundBeforeDragging];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        
        viewController.view.center = CGPointMake(point.x - viewController.view.frame.size.width/2.0 - _offset, viewController.view.center.y);
        
        [self resizeBackgroundWithValue:viewController.view.frame.origin.x + viewController.view.frame.size.width];
        
    }
    else if([recognizer state] == UIGestureRecognizerStateEnded)
    {
        
        if (viewController.view.frame.origin.x + viewController.view.frame.size.width > self.showLeftLimitValue)
        {
            //show
            [self showSliderViewController:viewController duration:self.animationDismissDuration animated:YES completion:nil];
        }
        else
        {
            //hide
            [self dismissSliderViewController:viewController duration:self.animationDismissDuration animated:YES completion:nil];
        }
        
    }
}


- (void)slideRightViewController:(UIPanGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    UIViewController *viewController = _mappedViewControllers[[NSString stringWithFormat:@"%p", recognizer.view]];
    _selectedTriggerView = (UIButton*)recognizer.view;
    
    
    [self addChildViewControllerSubviewIfNotYet:viewController];
    
    if([recognizer state] == UIGestureRecognizerStateBegan)
    {
        _offset = self.view.frame.size.width - point.x;
        [self handleBackgroundBeforeDragging];
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        
        viewController.view.center = CGPointMake(point.x + _offset + viewController.view.frame.size.width/2.0, viewController.view.center.y);
        
        [self resizeBackgroundWithValue:viewController.view.frame.origin.x];
        
    }
    else if([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if (viewController.view.frame.origin.x < self.showRightLimitValue)
        {
            //show
            [self showSliderViewController:viewController duration:self.animationDismissDuration animated:YES completion:nil];
        }
        else
        {
            //hide
            [self dismissSliderViewController:viewController duration:self.animationDismissDuration animated:YES completion:nil];
        }
        
    }
}

#pragma mark - Auxiliary and other methods

- (void)addChildViewControllerSubviewIfNotYet:(UIViewController*)viewController
{
    if (![self.view.subviews containsObject:viewController.view]) {
        viewController.view.frame = viewController.sliderSide == LESliderSideLeft ?
        CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) :
        CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:viewController.view];
    }
}


- (void)resizeBackgroundWithValue:(CGFloat)value
{
    UIViewController *viewController = _mappedViewControllers[[NSString stringWithFormat:@"%p", _selectedTriggerView]];
    
    CGFloat atualValue = value;
    
    _initialValue = 0.0;
    _endValue =  self.view.frame.size.width;
    
    if(viewController.sliderSide == LESliderSideRight) {
        atualValue = _initialValue + _endValue - value;
    }
    
    //the 0s in the formula were kept only to keep the parametrization clearer
    CGFloat parametrizedAlpha = 0.0 + ( (atualValue - _initialValue) * (1.0 - 0.0) / (_endValue - _initialValue) );
    
    CGFloat parametrizedWidthValue = _initialWidthValue + ( (atualValue - _initialValue) * (_finalWidthValue - _initialWidthValue) / (_endValue - _initialValue) );
    CGFloat parametrizedHeightValue = _initialHeightValue + ( (atualValue - _initialValue) * (_finalHeightValue - _initialHeightValue) / (_endValue - _initialValue) );
    
    
    _snapshotView.bounds = CGRectMake(0,0,
                                      _finalWidthValue - (parametrizedWidthValue - _initialWidthValue),
                                      _finalHeightValue - (parametrizedHeightValue - _initialHeightValue));
    
    _snapshotView.alpha = 1.0 - parametrizedAlpha;
}


- (void)handleBackgroundBeforeDragging
{
    [self blockUserInteration:YES];
    self.animating = YES;
    
    if ([self.delegate respondsToSelector:@selector(beginTransitionAnimation)]) {
        [self.delegate beginTransitionAnimation];
    }
    
    //adding snapshot view as subview
    [self.view addSubview:_snapshotView];
    [self.view sendSubviewToBack:_snapshotView];

    //configuring colors
    _originalBackgroundColor = self.view.backgroundColor;
    self.view.backgroundColor = self.voidColor;
    
    //Hide all subviews but snapshot view. Only the snapshot should be visible
    for (UIView *subview in self.view.subviews) {
        subview.hidden = YES;
    }
    _snapshotView.hidden = NO;
    
    //necessery to show the hidden view controller when dragging the button
    UIViewController *viewController = _mappedViewControllers[[NSString stringWithFormat:@"%p", _selectedTriggerView]];
    viewController.view.hidden = NO;
}

- (void)handleBackgroundAfterDragging
{
    self.animating = NO;
    
    //Unhidden all subviews, and removing snapshot view
    for (UIView *subview in self.view.subviews) {
        subview.hidden = NO;
    }
    [_snapshotView removeFromSuperview];
    self.view.backgroundColor = _originalBackgroundColor;
    
    if(!self.cacheControllers) {
        [_mappedViewControllers removeObjectForKey:[NSString stringWithFormat:@"%p", _selectedTriggerView]];
    }
    
    if ([self.delegate respondsToSelector:@selector(endTransitionAnimation)]) {
        [self.delegate endTransitionAnimation];
    }
}


- (void)blockUserInteration:(BOOL)mustBlock
{
    self.view.userInteractionEnabled = !mustBlock;
}

- (UIImage*)snapshotOfView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end