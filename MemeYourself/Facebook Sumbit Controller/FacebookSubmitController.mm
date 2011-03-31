//
//  FacebookSubmitController.m
//  Super Fill Up
//
//  Created by jrk on 26/10/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "FacebookSubmitController.h"
#import "NotificationSystem.h"
#import "FBConnect.h"
#import "SBJSON.h"

@implementation FacebookSubmitController
@synthesize score;
@synthesize level;
@synthesize delegate;
@synthesize facebook;
@synthesize dataSource;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) handleOpenURL: (NSURL *) url
{
	NSLog(@"handle open url: %@", url);
	if (!facebook)
	{
		facebook = [[Facebook alloc] initWithAppId: FB_APP_ID];
	}
	
	return [facebook handleOpenURL: url];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	NSLog(@"facebook lol dealloc");
	[facebook release];
	facebook = nil;
	
    [super dealloc];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
	NSLog(@"we're here!");
	dismissing = NO;
	[self shareOverFarmville];
	//	[self dismissModalViewControllerAnimated: YES];
	
}


#pragma mark -
#pragma mark farmville
- (void) shareOverFarmville
{
	if (![self dataSource])
	{
		NSLog(@"the facebook controller needs a datasource!");
		abort();
		return;
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	if (!facebook)
	{
		facebook = [[Facebook alloc] initWithAppId: FB_APP_ID];
		
		NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
		NSString *token = [defs objectForKey: @"fbtoken"];
		NSDate *date = [defs objectForKey: @"fbdate"];
		if (token)
		{
			NSLog(@"found token: %@", token);
			[facebook setAccessToken: token];	
			[facebook setExpirationDate: date];
			[self share2];
			return;
		}
		NSArray *perms = [NSArray arrayWithObjects:@"publish_stream"/*,@"offline_access"*/, nil];


		[facebook authorize: perms delegate: self];
		
		return;
	}
	[self share2];
}

- (void)fbDidLogin
{
	NSLog(@"fb login");
	if ([facebook accessToken])
	{
		NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
		[defs setObject: [facebook accessToken] forKey: @"fbtoken"];
		[defs setObject: [facebook expirationDate] forKey: @"fbdate"];
		[defs synchronize];
	}
	
	unlock_orientation = NO;
	[self share2];	
}

- (void) killme
{
	if (!dismissing)
	{	
		dismissing = YES;
		//	[self dismissModalViewControllerAnimated: NO];	
		[delegate facebookSubmitControllerDidFinish: self];
	}
}

/**
 * Called when the user dismiss the dialog without login
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"fb nologin");
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs removeObjectForKey: @"fbtoken"];
	[defs removeObjectForKey: @"fbdate"];
	[defs synchronize];
	
	isPostingOnFB = NO;
	[facebook release];
	facebook = nil;
	unlock_orientation = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	
	[self killme];	
	
	post_notification(kFacebookSubmitDidFail);
	
	//	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	//	[center postNotificationName: kEnableFacebookButton object: nil];
	
	
}

/**
 * Called when the user is logged out
 */
- (void)fbDidLogout
{
	NSLog(@"fb logout");
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs removeObjectForKey: @"fbtoken"];
	[defs removeObjectForKey: @"fbdate"];
	[defs synchronize];
	
	unlock_orientation = NO;
	isPostingOnFB = NO;	
	[facebook release];
	facebook = nil;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	
	[self killme];	
	
	//	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	//	[center postNotificationName: kEnableFacebookButton object: nil];
	post_notification(kFacebookSubmitDidFail);	
}


- (void) share2
{
	NSString *fb_title = [[self dataSource] titleForFBShare];
	NSString *fb_picurl = [[self dataSource] picurlForFBShare];
	NSString *fb_link = [[self dataSource] linkForFBShare];
	NSString *fb_link_name = [[self dataSource] linkNameForFBShare];
	NSString *fb_caption = [[self dataSource] captionForFBShare];	
	NSString *fb_description = [[self dataSource] descriptionForFBShare];	
	
	if (!fb_title || !fb_picurl || !fb_link || !fb_caption || !fb_description || !fb_link_name)
	{
		NSLog(@"lol! your datasource sucks!");
		abort();
		return;
	}
	
	NSMutableDictionary* params = [NSMutableDictionary dictionary];
	
//	[params setObject: fb_title forKey: @"message"];
	[params setObject: fb_picurl forKey: @"picture"];
	[params setObject: fb_link forKey: @"link"];
	[params setObject: fb_link_name forKey: @"name"];
//	[params setObject: fb_caption forKey: @"caption"];
//	[params setObject: fb_description forKey: @"description"];
	
	NSLog(@"sending params: %@", params);
	
	//SBJSON *json = [[[SBJSON alloc] init] autorelease];
	
	//NSString *params_str = [json stringWithObject: params];
	
	[facebook retain];
	//	[facebook requestWithMethodName: @"stream.publish" andParams: params andHttpMethod: @"POST" andDelegate: self];

	[facebook requestWithGraphPath: @"me/feed"
						 andParams: params 
					 andHttpMethod: @"POST" 
					   andDelegate: self];

	
//	[facebook dialog: @"feed" andParams: params andDelegate: self];
	
	
//	[_facebook dialog:@"feed"
//			andParams:params
//		  andDelegate:self];
//
	return;
	
	//	unlock_orientation = NO;
	//	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
	//								   FB_API_KEY, @"api_key",
	//								   fb_title , @"message",
	//								   nil];
	//	/*	NSString *action_links = @"[{\"text\":\"How Evil Are You???\",\"href\":\"http://itunes.apple.com/us/app/how-evil-are-you/id393122123?mt=8\"}]";
	//	 [params setObject:action_links forKey:@"action_links"];
	//	 
	//	 
	//	 NSLog(@"post params: %@", params);*/
	//	
	//	NSString *picurl = fb_picurl;//[NSString stringWithString: @"http://www.minyxgames.com/minyx-ultra/icon_90.png"];
	//	//NSString *picurl = [NSString stringWithString: @"http://www.minyxgames.com/mega-fill-up/not_awesome_face.png"];
	//	NSString *captionText = fb_caption;//[NSString stringWithFormat: @"{*actor*} has reached level %i and has now %i Gold!",level, score];
	//	
	//
	//	
	//	NSString *descString = fb_description;//@"And how much can you get? Minyx Ultra is free!";
	//	
	//	//media
	//	NSMutableDictionary *media_entry = [NSMutableDictionary dictionary];
	//	[media_entry setObject: @"image" forKey: @"type"];
	//	[media_entry setObject: picurl forKey: @"src"];
	//	[media_entry setObject: fb_link forKey: @"href"];
	//	NSArray *media = [NSArray arrayWithObject: media_entry];
	//	
	//	//attachment
	//	NSMutableDictionary *attachment = [NSMutableDictionary dictionary];
	//	[attachment setObject: fb_link forKey: @"href"];
	//	[attachment setObject: captionText forKey: @"caption"];
	//	[attachment setObject: descString forKey: @"description"];
	//	[attachment setObject: media forKey: @"media"];
	//	
	//	
	//	//actionlinks
	//	//	NSMutableDictionary *action_link = [NSMutableDictionary dictionary];
	//	//	[action_link setObject: @"Minyx Ultra for iPhone" forKey: @"text"];
	//	//	[action_link setObject: @"http://itunes.apple.com/app/LOL"  forKey: @"href"];
	//	//	NSArray *action_links = [NSArray arrayWithObject: action_link];
	//	
	//	SBJSON *json = [[[SBJSON alloc] init] autorelease];
	//	
	//	NSString *strAttachment = [json stringWithObject: attachment];
	//	
	//	[params setObject: strAttachment forKey: @"attachment"];
	//	
	//	NSLog(@"attachment: %@",strAttachment);
	//	
	//	[facebook retain];
	//	[facebook requestWithMethodName: @"stream.publish" andParams: params andHttpMethod: @"POST" andDelegate: self];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSLog(@"FB REQ %@ DID FAIL: %@",request, error);
	
	NSString *responseText = [[[NSString alloc] initWithData: [request responseText] encoding: NSUTF8StringEncoding] autorelease];
	
	NSLog(@"response text: %@", responseText);
	
	if ([error code] == 190 || [error code] == 104 || [error code] == 250 || [error code] == 10000)
	{
		
		NSLog(@"user deauthed us - removing token! %@", error);
		
		NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
		[defs removeObjectForKey: @"fbtoken"];
		[defs removeObjectForKey: @"fbdate"];
		[defs synchronize];
	}
	
	
	
	[facebook autorelease];
	[facebook release];
	facebook = nil;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Facebook",nil) 
													message:NSLocalizedString(@"Couldn't post to Facebook. Please try again!",nil)
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release]; 
	isPostingOnFB = NO;
	unlock_orientation = NO;
	
	[self killme];	
	
	//	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	//	[center postNotificationName: kEnableFacebookButton object: nil];
	post_notification(kFacebookSubmitDidFail);	
	
}

/**
 * Called when a request returns and its response has been parsed into an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"FB REQ SUCCESS: %@", result);// [[[NSString alloc] initWithData: result encoding: NSUTF8StringEncoding] autorelease]);
	unlock_orientation = NO;
	//dont re enable on success
	//	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	//	[center postNotificationName: kEnableFacebookButton object: nil];
	
	/*
	 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Facebook",nil) 
	 message:NSLocalizedString(@"Update successfully posted!",nil)
	 delegate:nil 
	 cancelButtonTitle:@"OK" 
	 otherButtonTitles: nil];
	 [alert show];
	 [alert release]; */
	[facebook autorelease];
	isPostingOnFB = NO;
	post_notification(kFacebookSubmitDidSucceed);
	[self killme];	
}

- (void) fbDialogLogin:(NSString *) token expirationDate:(NSDate *) expirationDate
{
	NSLog(@"token: %@",token);
}

- (void) fbDialogNotLogin:(BOOL) cancelled
{
	unlock_orientation = NO;
	
	NSLog(@"cancel!");
	isPostingOnFB = NO;
	//	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	//	[center postNotificationName: kEnableFacebookButton object: nil];
	post_notification(kFacebookSubmitDidFail);
	
	[self killme];	
}

- (void)dialogDidComplete:(FBDialog *)dialog
{
	NSLog(@"- (void)dialogDidComplete:(FBDialog *)dialog");
	post_notification(kFacebookSubmitDidSucceed);	
	[facebook autorelease];
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url
{
	NSLog(@"- (void)dialogCompleteWithUrl:(NSURL *)url %@", url);
	
	//	post_notification(kFacebookSubmitDidSucceed);	
//	[facebook autorelease];
}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
	NSLog(@"- (void)dialogDidNotCompleteWithUrl:(NSURL *)url %@", url);
//	post_notification(kFacebookSubmitDidFail);
//	[facebook autorelease];
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog
{
	NSLog(@"- (void)dialogDidNotComplete:(FBDialog *)dialog");
	post_notification(kFacebookSubmitDidFail);
	[facebook autorelease];
}
/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
	NSLog(@"- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error %@", [error localizedDescription]);
//	post_notification(kFacebookSubmitDidFail);
//	[facebook autorelease];
}


@end
