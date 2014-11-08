//
//  AppDelegate.h
//  DemoBeaconstac
//
//  Created by Garima Batra on 8/26/14.
//  Copyright (c) 2014 Mobstac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CMMotionManager *motionmanager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;

@end
