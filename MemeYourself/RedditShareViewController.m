//
//  RedditShareViewController.m
//  MemeYourself
//
//  Created by jrk on 29/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RedditShareViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSString+Additions.h"
#import "NSString+SBJSON.h"
#import "NSString+Slice.h"

#import "VZImgurUpload.h"

@implementation RedditShareViewController
@synthesize imageFilename;
@synthesize redditURL;

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
	[self setRedditURL: nil];
	[self setImageFilename: nil];
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
	[imageView setImage: [UIImage imageWithContentsOfFile: [MXUtil pathForMeme: [self imageFilename]]]];
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSString *subreddit = [defs objectForKey: @"subreddit"];
	if (subreddit)
		[subredditField setText: subreddit];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) cancel: (id)sender
{
	[self dismissModalViewControllerAnimated: YES];
}

- (void) share: (id)sender
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSString *username = [defs objectForKey: @"reddit_username"];
	NSString *password = [defs objectForKey: @"reddit_password"];

	if (!username || !password)
	{
		UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Error"
													 message: @"Please set up your reddit.com username and password in the preferences!"
													delegate: nil
										   cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[av show];
		[av release];
		return;
	}
	
	if ([[subredditField text] length] == 0)
	{
		UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Error"
													 message: @"Please enter a subreddit"
													delegate: nil
										   cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[av show];
		[av release];
		return;
	}

	if ([[titleField text] length] == 0)
	{
		UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Error"
													 message: @"Please enter a title"
													delegate: nil
										   cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[av show];
		[av release];
		return;
	}

	[defs setObject: [subredditField text] forKey: @"subreddit"];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	[self disableUI];
	
	VZImgurUpload *uc = [[VZImgurUpload alloc] init];
	[uc setDelegate: self];
	
	NSString *path = [MXUtil pathForMeme: [self imageFilename]];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	
	NSMutableDictionary *uploadInfo = [NSMutableDictionary dictionary];
	[uploadInfo setValue:[NSNumber numberWithBool: NO] forKey:@"shouldOpenSummaryWindow"];
	[uploadInfo setValue:[NSNumber numberWithBool: YES] forKey:@"shouldOpenUploadedFileInBrowser"];
	
	[uc setUploadMetaInformation: uploadInfo];
	[uc setFilename: [self imageFilename]];
	[uc setData: myData];
	[uc performUpload];

	
}

- (void) uploadClient: (id) aClient fileUploadSuccess: (BOOL) succeeded withReturnedURL: (NSString *) url
{
	NSLog(@"imgur upload completed ...");
	[self continueSubmission: url];
	[aClient release];
}

- (void) uploadClientfileUploadDidFail: (id) aClient
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	NSLog(@"upload for %@ failed!", [aClient filename]);
	[aClient autorelease];
	[self enableUI];
}


- (void) continueSubmission: (NSString *) linkurl
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSString *username = [defs objectForKey: @"reddit_username"];
	NSString *password = [defs objectForKey: @"reddit_password"];
	
	ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: @"http://www.reddit.com/api/login"]];
	[req setPostFormat: ASIURLEncodedPostFormat];
	[req setPostValue: username forKey: @"user"];
	[req setPostValue: password forKey: @"passwd"];
	[req startSynchronous];
	
	NSString *resp = [req responseString];
	
	NSLog(@"resp: %@", resp);
	if ([resp containsString: @"error" ignoringCase: YES])
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
		[self enableUI];
		UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Error"
													 message: @"Login failed. Check your username/password. (If it's right maybe reddit's servers are down again?)"
													delegate: nil
										   cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[av show];
		[av release];
		return;
	}
	
	ASIHTTPRequest *req2 = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: @"http://www.reddit.com/"]];
	[req2 startSynchronous];
	
	resp = [req2 responseString];
	
	NSLog(@"resp for /: %@", resp);
	
	if (![resp containsString: @"name=\"uh\" value=" ignoringCase: YES])
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
		[self enableUI];
		UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Error"
													 message: @"Login seemed to work, but there was no uh key found. Is reddit down?"
													delegate: nil
										   cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[av show];
		[av release];

		return;
	}
	
	NSString *uh = [resp stringBetweenSubstringOne: @"name=\"uh\" value=\"" andSubstringTwo: @"\"/>"];
	NSLog(@"uh: %@", uh);

	if ([uh length] == 0)
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
		[self enableUI];
		UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Error"
													 message: @"Couldn't extract uh! Reddit down?"
													delegate: nil
										   cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[av show];
		[av release];
		
		return;
	}

	req = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: @"http://www.reddit.com/api/submit"]];
	[req setURL: [NSURL URLWithString: @"http://www.reddit.com/api/submit"]];
	[req setPostValue: [subredditField text] forKey: @"sr"];
	[req setPostValue: @"link" forKey: @"kind"];
	[req setPostValue: [titleField text] forKey: @"title"];
	[req setPostValue: [subredditField text] forKey: @"r"];
	[req setPostValue: linkurl forKey: @"url"];
	[req setPostValue: uh forKey: @"uh"];
	[req setPostValue: @"html" forKey: @"renderstyle"];
	[req startSynchronous];
	
	resp = [req responseString];
	
	NSLog(@"resp2: %@", resp);
	
	if ([resp containsString: @"error" ignoringCase: YES])
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
		[self enableUI];
		UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Error"
													 message: @"No reaction on our submission. Maybe reddit is down/slow?"
													delegate: nil
										   cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[av show];
		[av release];
		return;
	}	
	
	
	if (![resp containsString: @"http://www.reddit.com/r" ignoringCase: YES])
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
		[self enableUI];
		UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Error"
													 message: @"No redirect URL found! Maybe reddit is under high load again?"
													delegate: nil
										   cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[av show];
		[av release];
		return;
	}
	
	NSString *redirect = [resp stringBetweenSubstringOne: @"[\"http://www.reddit.com/r/" andSubstringTwo: @"\"]]"];
	redirect = [@"http://www.reddit.com/r/" stringByAppendingString: redirect];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	NSLog(@"redirect: %@", redirect);
	
	[self setRedditURL: redirect];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *av = [[UIAlertView alloc] initWithTitle: @"Success"
												 message: [NSString stringWithFormat: @"Your meme has been submitted to %@. Do you want to open the submission now?", redirect]
												delegate: self
									   cancelButtonTitle: @"No" otherButtonTitles: @"Yes", nil];
	[av show];
	[av release];

	
	//[[UIApplication sharedApplication] openURL: [NSURL URLWithString: redirect]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [alertView cancelButtonIndex])
	{
		[self enableUI];
		[self dismissModalViewControllerAnimated: YES];
		return;
	}
	[self enableUI];
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: [self redditURL]]];
	[self dismissModalViewControllerAnimated: YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) disableUI
{
	[activityIndicator startAnimating];
	[titleField setEnabled: NO];
	[subredditField setEnabled: NO];
	[cancelButton setEnabled: NO];
	[submitButton setEnabled: NO];
}

- (void) enableUI
{
	[activityIndicator stopAnimating];
	[titleField setEnabled: YES];
	[subredditField setEnabled: YES];
	[cancelButton setEnabled: YES];
	[submitButton setEnabled: YES];	
}

@end
