//
//  RedditShareViewController.h
//  MemeYourself
//
//  Created by jrk on 29/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RedditShareViewController : UIViewController 
{
	NSString *imageFilename;  
	NSString *redditURL;
	
	IBOutlet UIImageView *imageView;
	IBOutlet UITextField *titleField;
	IBOutlet UITextField *subredditField;
	
	IBOutlet UIBarButtonItem *cancelButton;
	IBOutlet UIButton *submitButton;
}

@property (readwrite, retain) NSString *imageFilename;
@property (readwrite, retain) NSString *redditURL;
- (IBAction) cancel: (id) sender;
- (IBAction) share: (id) sender;
- (void) continueSubmission: (NSString *) linkurl;

- (void) disableUI;
- (void) enableUI;
@end
