//
//  MemeDetailViewController.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemeArchiveViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "FBConnect.h"
#import "FacebookSubmitController.h"

@interface MemeDetailViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> 
{
	NSString *imageName;
	UIImageView *imageView;
	MemeArchiveViewController *parent;
	
	Facebook *facebook;
	
	NSString *uploadedImageURL;
}
@property (assign) MemeArchiveViewController *parent;
@property (retain) IBOutlet UIImageView *imageView;
@property (readwrite, retain) NSString *imageName;
@property (readwrite, retain) NSString *uploadedImageURL;

- (IBAction) share: (id) sender;
- (IBAction) trash: (id) sender;
- (void) shareByMail;
- (void) shareByUpload;
- (void) shareByFacebook;
@end
