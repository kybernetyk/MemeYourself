//
//  MemeCreatorViewController.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXOutlineLabel.h"
#import "MXAdController.h"
@interface MemeCreatorViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet MXOutlineLabel *upperLabel;
	IBOutlet MXOutlineLabel *lowerLabel;
	
	IBOutlet UIBarButtonItem *saveButton;
	
	UITextField *field;
	
	UIImageView *imageView;
	
	NSString *currentFilename;
	
	MXAdController *adController;
	
	IBOutlet UIView *adView;
}
@property (retain) IBOutlet UIImageView *imageView;

@property (readwrite, retain) NSString *currentFilename;

- (IBAction) takePicture: (id) sender;

- (IBAction) trash: (id) sender;
- (IBAction) save: (id) sender;

@end
