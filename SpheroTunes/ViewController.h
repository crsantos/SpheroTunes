//
//  ViewController.h
//  SpheroTunes
//
//  Created by Carlos Ricardo Santos on 11/3/12.
//  Copyright (c) 2012 Carlos Ricardo Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RobotUIKit/RobotUIKit.h>

@interface ViewController : UIViewController {
    BOOL ledON;
    BOOL robotOnline;
    RUICalibrateGestureHandler *calibrateHandler;
}
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UISwitch *ledSwitch;

-(void)setupRobotConnection;
-(void)handleRobotOnline;
-(void)toggleLED;

@end

