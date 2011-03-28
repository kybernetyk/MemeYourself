//
//  MemeDetailViewController.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MemeDetailViewController : UIViewController 
{
	NSString *imageName;
	
	UIImageView *imageView;
}
@property (retain) IBOutlet UIImageView *imageView;
@property (readwrite, retain) NSString *imageName;

@end
