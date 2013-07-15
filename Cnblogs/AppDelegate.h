//
//  AppDelegate.h
//  Cnblogs
//
//  Created by Lei Sun on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) UINavigationController *navigationController;

@end
