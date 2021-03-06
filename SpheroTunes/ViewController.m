//
//  ViewController.m
//  SpheroTunes
//
//  Created by Carlos Ricardo Santos on 11/3/12.
//  Copyright (c) 2012 Carlos Ricardo Santos. All rights reserved.
//

#import "ViewController.h"

#import "RobotKit/RobotKit.h"

#import "RobotUIKit/RobotUIKit.h"

@implementation ViewController

#pragma mark - Actions

- (IBAction)connectButtonClicked:(id)sender {
    
    DLog(@"")
    [self setupRobotConnection];
}

- (IBAction)ledSwitchChanged:(id)sender {
    
    DLog(@"")
    [self toggleLED];
}

#pragma mark - Views

-(void)viewDidLoad {
    [super viewDidLoad];
    
    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

    /*Only start the blinking loop when the view loads*/
    robotOnline = NO;

    calibrateHandler = [[RUICalibrateGestureHandler alloc] initWithView:self.view];
}
-(void)appWillResignActive:(NSNotification*)notification {
    DLog(@"")
    /*When the application is entering the background we need to close the connection to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
}

-(void)appDidBecomeActive:(NSNotification*)notification {
    DLog(@"")
    /*When the application becomes active after entering the background we try to connect to the robot*/
    [self setupRobotConnection];
}

- (void)handleRobotOnline {
    DLog(@"Robot online!")
    /*The robot is now online, we can begin sending commands*/
    if(!robotOnline) {
        
        /*Only start the blinking loop once*/
        [self toggleLED];
    }
    robotOnline = YES;
}

- (void)toggleLED {
    DLog(@"ledON = %d",ledON)
    /*Toggle the LED on and off*/
    if (ledON) {
        ledON = NO;
        [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
    } else {
        ledON = YES;
        [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:1.0];
    }
//    [self performSelector:@selector(toggleLED) withObject:nil afterDelay:0.5];
}

-(void) setupRobotConnection {
    DLog(@"")
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl]) {
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];
    }
}

-(IBAction)sleepPressed:(id)sender {
    //RobotUIKit resources like images and nib files stored in an external bundle and the path must be specified
    NSString* rootpath = [[NSBundle mainBundle] bundlePath];
    NSString* ruirespath = [NSBundle pathForResource:@"RobotUIKit" ofType:@"bundle" inDirectory:rootpath];
    NSBundle* ruiBundle = [NSBundle bundleWithPath:ruirespath];
    
    //Present the slide to sleep view controller
    RUISlideToSleepViewController *sleep = [[RUISlideToSleepViewController alloc] initWithNibName:@"RUISlideToSleepViewController" bundle:ruiBundle];
    sleep.view.frame = self.view.bounds;
    [self presentModalLayerViewController:sleep animated:YES];
}

- (void)viewDidUnload {
    [self setConnectBtn:nil];
    [self setLedSwitch:nil];
    [super viewDidUnload];
}
@end
