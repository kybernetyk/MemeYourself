//
//  MemeDetailViewController.m
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemeDetailViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@implementation MemeDetailViewController
@synthesize imageName;
@synthesize imageView;
@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[self setImageName: nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	UIImage *img = [UIImage imageWithContentsOfFile: [MXUtil pathForMeme: [self imageName] ]];
	
	[imageView setImage: img];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[self setImageView: nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) share: (id) sender
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Hello"];
	
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"jszpilewski@me.com"]; 
	
	[picker setToRecipients:toRecipients];
	
	// Attach an image to the email
	NSString *path = [MXUtil pathForMeme: [self imageName]];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"image/png" fileName: [self imageName]];
	
	// Fill out the email body text
	NSString *emailBody = @"It is raining";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	if (result == MFMailComposeResultFailed && error)
	{
		// Show error : [error localizedDescription];
	}
	else
	{
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (IBAction) trash: (id) sender
{
	NSString *path_img = [MXUtil pathForMeme: [self imageName]];
	NSString *path_thumb = [MXUtil pathForMeme: [@"thumb_" stringByAppendingString: [self imageName]]];
	
	NSError **err;
	[[NSFileManager defaultManager] removeItemAtPath: path_img error: err];
	[[NSFileManager defaultManager] removeItemAtPath: path_thumb error: err];
	
	[parent setNeedsRefresh: YES];
	
	[[self navigationController] popViewControllerAnimated: YES];
}

@end

