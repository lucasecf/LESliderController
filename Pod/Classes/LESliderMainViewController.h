//
//  LESliderMainViewController.h
//  LESlideTransition
//
//  Created by Lucas Eduardo  Chaves Frota on 20/10/13.
//  Copyright (c) 2013 Lucas Eduardo Chaves Frota. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    LESliderSideLeft,
    LESliderSideRight,
    
} LESliderSide;


@protocol LESliderMainViewControllerDelegate <NSObject>

@optional
-(void)beginTransitionAnimation;
-(void)endTransitionAnimation;

@end


@interface LESliderMainViewController : UIViewController

@property(weak, nonatomic) id<LESliderMainViewControllerDelegate> delegate;

/**
 This is the color that appears when the main background is been shrunk. Default one is black.
 */
@property (strong, nonatomic) UIColor *voidColor;

/**
 When dragging a controller during a transition (with the gestures), this values are the threshold to control if the controller will be presented or dissmissed.
 The default values are the center of the screen, for both sides (left and right).
 */
@property (assign, nonatomic) CGFloat showLeftLimitValue;
@property (assign, nonatomic) CGFloat showRightLimitValue;

/**
 Values used to control the duration of the animations. Default ones are 0.7 and 0.4, respectively.
 */
@property (assign, nonatomic) CGFloat animationPresentingDuration;
@property (assign, nonatomic) CGFloat animationDismissDuration;

/**
 Readonly property to control if the controller is during a transition animation.
 */
@property (assign, atomic, readonly) BOOL animating;

/**
 Controls if the main controller will keep the child viewController in memory (similar to the UITabBarController) or it will release them after dismiss. Default value is YES.
 */
@property (assign, atomic) BOOL cacheControllers;


#pragma mark - public methods

/**
 Setup method. Use this one to assign a view that will trigger a controller transition.
 
 @param triggerView View that will trigger the controller transition, like a UIButton or even a normal UIView (with gesture recognizers)
 
 @param viewController Controller that will be presented.
 
 @param sliderSide Side of the transition animation. See the LESliderSide enum to check the possible values
 
 */
- (void)registerTriggerView:(UIView*)triggerView toViewController:(UIViewController*)viewController onSide:(LESliderSide)sliderSide;


/**
 With this method, you can use a pan gesture recognizer to drag the soon to be presented controller to the screen.
 
 @param sliderSide Side that will trigger the transition dragging. See the LESliderSide enum to check the possible values
 
 @param triggerView View that the pan gesture will be added.
 
 */
- (void)addSliderGesture:(LESliderSide)sliderSide toTriggerView:(UIView*)triggerView;


/**
 The view you see been resized during the transition is only a snapshot of your real controller. Call this method if you want to update this snapshot, if your main controller changed it's UI somehow.
 */
- (void)updateSnapshotTransitionImage;


/**
 Present a new controller. The controller presented it will be the one registered for the triggerView passed in the params.
 
 @param triggerView View that will trigger the controller transition.
 
 @param animated Controls if the transition will be animated or not.
 
 @param completionBlock Block that will be executed when the transition finishes.
 
 */
-(void)showRegisteredViewControllerForTriggerView:(UIView*)triggerView animated:(BOOL)animated completion:(void(^)(void))completionBlock;


/**
 This dismiss a registered and already presented viewController. If animated, the duration of the animation will be the animationDismissDuration property value.
 
 @param viewController Controller that will be dismissed.
 
 @param animated Controls if the dismiss will be animated or not.
 
 @param completionBlock Block that will be executed when the transition finishes.
 
 */
- (void)dismissSliderViewController:(UIViewController*)viewController animated:(BOOL)animated completion:(void(^)(void))completionBlock;


/**
 This dismiss a registered and already presented viewController. If animated, the duration of the animation will be the one passed in the duration param.
 
 @param viewController Controller that will be dismissed.
 
 @param duration Duration of the transition.
 
 @param animated Controls if the dismiss will be animated or not.
 
 @param completionBlock Block that will be executed when the transition finishes.
 
 */
-(void)dismissSliderViewController:(UIViewController*)viewController duration:(NSTimeInterval)duration animated:(BOOL)animated completion:(void(^)(void))completionBlock;

@end
