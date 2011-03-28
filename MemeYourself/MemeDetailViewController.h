//
//  MemeDetailViewController.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemeArchiveViewController.h"

@interface MemeDetailViewController : UIViewController 
{
	NSString *imageName;
	UIImageView *imageView;
	MemeArchiveViewController *parent;
}
@property (assign) MemeArchiveViewController *parent;
@property (retain) IBOutlet UIImageView *imageView;
@property (readwrite, retain) NSString *imageName;

- (IBAction) share: (id) sender;
- (IBAction) trash: (id) sender;

@end
