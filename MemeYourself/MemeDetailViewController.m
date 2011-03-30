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
#import "VZHtlrUpload.h"
#import "VZImgurUpload.h"
#import "FBConnect.h"
#import "RedditShareViewController.h"

@implementation MemeDetailViewController
@synthesize imageName;
@synthesize imageView;
@synthesize parent;
@synthesize uploadedImageURL;

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

	NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
	[dc addObserver: self selector: @selector(fbDidFail:) name: kFacebookSubmitDidFail object: nil];
	[dc addObserver: self selector: @selector(fbDidSucceed:) name: kFacebookSubmitDidSucceed object: nil];

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
	NSString *uploaderName = nil;

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	int i = [defs integerForKey: @"hoster"];
	
	switch (i) 
	{
		case kHtlr:
			uploaderName = @"htlr.org";
			break;
		case kImgur:
			uploaderName = @"imgur.com";
			break;
		default:
			uploaderName = @"htlr.org";
			break;
	}
	

	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle: @"Share" 
													   delegate: self 
											  cancelButtonTitle: @"cancel"
										 destructiveButtonTitle: nil
											  otherButtonTitles: @"EMail", @"Facebook", uploaderName, @"Reddit", nil];
	
	
	[sheet showFromBarButtonItem: sender animated: YES];
	[sheet release];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//delete sheet
	if ([actionSheet tag] == 23)
	{
		if (buttonIndex == [actionSheet cancelButtonIndex])
			return;
		
		NSString *path_img = [MXUtil pathForMeme: [self imageName]];
		NSString *path_thumb = [MXUtil pathForMeme: [@"thumb_" stringByAppendingString: [self imageName]]];
		
		NSError **err;
		[[NSFileManager defaultManager] removeItemAtPath: path_img error: err];
		[[NSFileManager defaultManager] removeItemAtPath: path_thumb error: err];
		
		[parent setNeedsRefresh: YES];
		
		[[self navigationController] popViewControllerAnimated: YES];

		return;
	}
	
	
	if (buttonIndex == [actionSheet cancelButtonIndex])
		return;
	
	if (buttonIndex == 0)
	{
		[self shareByMail];
		return;
	}
	
	if (buttonIndex == 1)
	{
		[self shareByFacebook];
		return;
	}
	
	if (buttonIndex == 2)
	{
		[self shareByUpload];
		return;
	}
	
	if (buttonIndex == 3)
	{
		[self shareByReddit];
		return;
	}
	NSLog(@"%i", buttonIndex);
}


- (void) shareByMail
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Hello"];
	
	
	// Attach an image to the email
	NSString *path = [MXUtil pathForMeme: [self imageName]];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"image/png" fileName: [self imageName]];
	
	// Fill out the email body text
	NSString *emailBody = @"Hey, I made this!";
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
		[self dismissModalViewControllerAnimated:YES];
	}
	else
	{
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (IBAction) trash: (id) sender
{
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle: @"Really delete this meme?"
													   delegate: self 
											  cancelButtonTitle: @"cancel"
										 destructiveButtonTitle: @"Yes delete"
											  otherButtonTitles: nil];
	[sheet setTag: 23];

	[sheet showFromBarButtonItem: sender animated: YES];
	[sheet release];
	
}


- (id) activeUploader
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	int i = [defs integerForKey: @"hoster"];
	
	id ret = nil;
	switch (i) 
	{
		case kHtlr:
			ret = [[VZHtlrUpload alloc] init];
			break;
		case kImgur:
			ret = [[VZImgurUpload alloc] init];
			break;
		default:
			ret = [[VZHtlrUpload alloc] init];
			break;
	}

	return ret;
}

#pragma mark - imghoster upload
- (void) shareByUpload
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];

	id uc = [self activeUploader];
	//VZHtlrUpload *uc = [[VZHtlrUpload alloc] init];
	//VZImgurUpload *uc = [[VZImgurUpload alloc] init];
	[uc setDelegate: self];
	
	NSString *path = [MXUtil pathForMeme: [self imageName]];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	
	NSMutableDictionary *uploadInfo = [NSMutableDictionary dictionary];
	[uploadInfo setValue:[NSNumber numberWithBool: NO] forKey:@"shouldOpenSummaryWindow"];
	[uploadInfo setValue:[NSNumber numberWithBool: YES] forKey:@"shouldOpenUploadedFileInBrowser"];

	[uc setUploadMetaInformation: uploadInfo];
	[uc setFilename: [self imageName]];
	[uc setData: myData];
	[uc performUpload];
}

#pragma mark - reddit
- (void) shareByReddit
{
	RedditShareViewController *vc = [[RedditShareViewController alloc] initWithNibName:@"RedditShareViewController" bundle: nil];
	[vc setImageFilename: [self imageName]];
	[self presentModalViewController: vc animated: YES];
	[vc release];
}


#pragma mark - facebook
- (void) shareByFacebook
{
	id uc = [self activeUploader];
	[uc setDelegate: self];
	
	NSString *path = [MXUtil pathForMeme: [self imageName]];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	
	NSMutableDictionary *uploadInfo = [NSMutableDictionary dictionary];
	[uploadInfo setValue:[NSNumber numberWithBool: NO] forKey:@"shouldOpenSummaryWindow"];
	[uploadInfo setValue:[NSNumber numberWithBool: NO] forKey:@"shouldOpenUploadedFileInBrowser"];
	[uploadInfo setValue:[NSNumber numberWithBool: YES] forKey:@"shouldShareFacebook"];
	
	[uc setUploadMetaInformation: uploadInfo];
	[uc setFilename: [self imageName]];
	[uc setData: myData];
	[uc performUpload];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];

}

#pragma mark Imagehoster Client delegate
- (void) uploadClient: (id) aClient fileUploadSuccess: (BOOL) succeeded withReturnedURL: (NSString *) url
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	NSDictionary *uploadInfo = [aClient uploadMetaInformation];
	
	//open summary window
	if ([[uploadInfo valueForKey: @"shouldOpenSummaryWindow"] boolValue])
	{
		NSLog(@"the file %@ was uploaded to the url %@",[aClient filename],url);
	}
	
	if ([[uploadInfo valueForKey: @"shouldShareFacebook"] boolValue])
	{
		[self setUploadedImageURL: url];
		[self shareByFacebook2];
	}
	
	//redirect to teh brauser
	if ([[uploadInfo valueForKey: @"shouldOpenUploadedFileInBrowser"] boolValue])	
	{
		url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
 		NSURL *_url = [NSURL URLWithString: url];
		
		NSLog(@"the file %@ was uploaded to the url %@",[aClient filename],url);
		
		[[UIApplication sharedApplication] openURL: _url];
	}
	
	
	[aClient autorelease];
	
}

- (void) uploadClientfileUploadDidFail: (id) aClient
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	NSLog(@"upload for %@ failed!", [aClient filename]);
	[aClient autorelease];
}

#pragma mark - facebook
- (void) shareByFacebook2
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	[[[UIApplication sharedApplication] delegate] initFBShare: self];
}


#pragma mark -
#pragma mark facebook datasource
- (void) fbDidFail: (NSNotification *) notification
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	
}

- (void) fbDidSucceed: (NSNotification *) notification
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Facebook",nil) 
													message:NSLocalizedString(@"Meme successfully posted to your wall!",nil)
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release]; 

	
}

- (NSString *) titleForFBShare
{
	return @"I created a meme!";
}
- (NSString *) captionForFBShare
{
	return @"";
}
- (NSString *) descriptionForFBShare
{
	return @"";
}

- (NSString *) linkForFBShare
{
	return [self uploadedImageURL];
}

- (NSString *) linkNameForFBShare
{
	return [self uploadedImageURL];
}

- (NSString *) picurlForFBShare
{
	return [self uploadedImageURL];
}

@end

