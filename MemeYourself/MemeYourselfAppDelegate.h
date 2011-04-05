//
//  MemeYourselfAppDelegate.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSubmitController.h"

@interface MemeYourselfAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> 
{
	FacebookSubmitController *facebookController;
	
	IBOutlet UITabBarItem *adsItem;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;


- (void) initFBShare: (id) datasource;

- (void) increaseBadge;
- (void) resetBadge;

@end
