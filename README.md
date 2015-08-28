# LESliderController

## What is this

Just a container controller, to present another controllers via tap/pan gesture with a nice and different animation! See a example of app that uses it:

<p align="center">
<img src="Images/preview.gif" alt="GIF 1" width="375px" />
</p>

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first. As always, open the project through the ```.xcworkspace``` file.

## Requirements
* iOS 8 or above
* Nowadays, ```LESliderController``` only works well if the project does not allow change of orientations during execution. Only in apps fixed in Portrait OR Landscape.

## Installation

#### Cocoapods

LESliderController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LESliderController', '~> 0.1'
```

#### Manually

Drag and copy all files in the [__LECropPictureViewController__](Pod/Classes) folder into your project, or add it as a git submodule.

## How to use

#### Basic Usage

To use the LESliderController is very easy and straightforward. Follow the steps below:

1) Make the controller you want to make the root/container of the navigation a subclass of ```LESliderMainViewController```:


```objective-c
@import UIKit;

#import <LESliderController/LESliderMainViewController.h>

@interface MyViewController : LESliderMainViewController

@end
```

2) Add buttons to trigger the transition to the "child" controllers. This can be done by InterfaceBuilder or with buttons allocated via code. You can even use any kind of ```UIViews```, as long as you trigger the transition with some gesture recognizer. Let's move on with a interface builder example:

```objective-c

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@end
```

3) If you are using storyboad, for each "child" you want to present throughout the main view, set a ```Storyboard ID``` in the third tab of interface builder (identity inspector).

4) Now, in the implementation (.m) file of the controller, setup each "child" controller you want as the example below:

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController *rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];
    [self registerTriggerView:self.rightButton toViewController:rightViewController onSide:LESliderSideRight];
    [self addSliderGesture:LESliderSideRight toTriggerView:self.rightButton];
    
    UIViewController *leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    [self registerTriggerView:self.leftButton toViewController:leftViewController onSide:LESliderSideLeft];
    [self addSliderGesture:LESliderSideLeft toTriggerView:self.leftButton];

}
```
Notice the ```onSide:``` parameter. You can choose either ```LESliderSideRight``` to have a transition from right to left or ```LESliderSideLeft``` to have a transition from left to right.

With this piece of code, you are already ready to present the controllers via a pan gesture in the buttons you registered in the ```registerTriggerView:``` parameter.

5) Implement actions for the buttons (or a tap gesture recognizer if not using buttons) to trigger the transition when tapping in it.

```objective-c
- (IBAction)leftButtonDidTouch:(id)sender {
    [self showRegisteredViewControllerForTriggerView:sender animated:YES completion:nil];
}


- (IBAction)rightButtonDidTouch:(id)sender {
    [self showRegisteredViewControllerForTriggerView:sender animated:YES completion:nil];
}
```

6) Finally, inside the presented controller, import the ```#import <LESliderController/UIViewController+LESliderChild.h>``` header and in a action of any button, call the method below to dismiss the controller.

```objective-c
#import "UIViewController+LESliderChild.h"

@implementation MyChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTouchBackBtn:(id)sender {
    //[self dismissSliderController:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

```


#### Advanced Options
 
Check the ```LESliderMainViewController.h``` to see all avaliable properties. You can use them, for example, to change the duration of the animations.

##### Caching controllers 

One particular topic is about caching the presented controllers. The basic setup keeps the reference of the controllers in memory, similar to what the UITabBarController does. This means that, once you present the controller, dismiss it, and present it again, the previous state was preserved. This can be very helpful to avoid multiple requisition loads, for example, but could also be problematic if the controller is heavy and holds a lot of memory.

If thats the case, and you want to avoid this behaviour, you can do the setup below to release the controllers after the dismiss.

In your subclass of ```LESliderMainViewController.h```:

```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cacheControllers = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rightButtonDidTouch:(id)sender {
    UIViewController *rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];
    [self registerTriggerView:self.rightButton toViewController:rightViewController onSide:LESliderSideRight];
    [self showRegisteredViewControllerForTriggerView:sender animated:YES completion:nil];
}

- (IBAction)leftButtonDidTouch:(id)sender {
    UIViewController *leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    [self registerTriggerView:self.leftButton toViewController:leftViewController onSide:LESliderSideLeft];
    [self showRegisteredViewControllerForTriggerView:sender animated:YES completion:nil];
}
```

## TODO:

* Refactor the ```LESliderMainViewController.m``` file to allow change of orientation during execution.


## Collaborate
Liked the project? Is there something missing or that could be better? Feel free to contribute :)

1. Fork it

2. Create your branch
``` git checkout -b name-your-feature ```

3. Commit it
``` git commit -m 'the difference' ```

4. Push it
``` git push origin name-your-feature ```

5. Create a Pull Request


## Author

Lucas Eduardo, lucasecf@gmail.com

## License

LESliderController is available under the MIT license. See the LICENSE file for more info.
