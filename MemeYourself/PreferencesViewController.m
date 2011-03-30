//
//  PreferencesViewController.m
//  MemeYourself
//
//  Created by jrk on 30/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferencesViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>


@implementation PreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{

    }
    return self;
}

- (void)dealloc
{
	[sectionCaptions release];
	[sectionTitles release];

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
	
	NSArray *hosterCaptions = [NSArray arrayWithObjects:
							   @"htlr.org",
							   @"imgur.com",
							   nil];
	
	NSArray *redditCaptions = [NSArray arrayWithObjects:
							   @"Username",
							   @"Password",
							   nil];

	NSArray *miscCaptions = [NSArray arrayWithObjects:
							   @"Suggest Template",
							   @"Contact Developer",
							   @"Visit Minyx Games",
#ifdef IS_LITE
							 	@"Disable Ads",
#endif
							   nil];

	sectionCaptions = [[NSArray alloc] initWithObjects: hosterCaptions, redditCaptions, miscCaptions, nil];
	
	sectionTitles = [[NSArray alloc] initWithObjects: @"Image Hoster", @"reddit Account", @"Misc", nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[sectionCaptions release], sectionCaptions = nil;
	[sectionTitles release], sectionTitles = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionCaptions count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sectionTitles objectAtIndex: section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[sectionCaptions objectAtIndex: section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    [cell setAccessoryType: UITableViewCellAccessoryNone];
	
	//let's set up the checkmarks for our saved user preferences

	//hoster section
	if ([indexPath section] == 0)
	{
		NSInteger hoster = [[NSUserDefaults standardUserDefaults] integerForKey: @"hoster"];
		
		
		
		//difficulty can be 0 .. 2 (0 = beginner, ) so we can map the row index directly 
		if (hoster == [indexPath row])
			[cell setAccessoryType: UITableViewCellAccessoryCheckmark];
	}
	
	//reddit
	if ([indexPath section] == 1)
	{
		if ([indexPath row] == 0)
		{
			NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey: @"reddit_username"];
			if (!text)
				text = @"Username?";
			else
				text = [@"Username: " stringByAppendingString: text];
			
			[[cell textLabel] setText: text];
		}
		if ([indexPath row] == 1)
		{
			NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey: @"reddit_password"];
			if (!text)
				text = @"Password?";
			else
				text = [@"Password: " stringByAppendingString: @"***"];

			[[cell textLabel] setText: text];
		}
		return cell;
	}
	
	[[cell textLabel] setText: [[sectionCaptions objectAtIndex: [indexPath section]] objectAtIndex: [indexPath row]]];
	
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void) makeAlert: (int) tag text: (NSString *) text
{
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Enter Text"];
	[dialog setMessage:@" "];
	[dialog addButtonWithTitle:@"Cancel"];
	[dialog setCancelButtonIndex: 0];
	[dialog addButtonWithTitle:@"OK"];
	[dialog setTag: tag];
	
	field = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
	[field setBackgroundColor:[UIColor whiteColor]];
	[field becomeFirstResponder];
	[dialog addSubview: field];
	//CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
	//[dialog setTransform: moveUp];
	
	[field setText: text];

	if (tag == 2)
		[field setSecureTextEntry: YES];
	else
		[field setSecureTextEntry: NO];
	[field setAutocapitalizationType: UITextAutocapitalizationTypeNone];
	[field setClearButtonMode: UITextFieldViewModeWhileEditing];
	[field setKeyboardType: UIKeyboardTypeAlphabet];
	[field setKeyboardAppearance: UIKeyboardAppearanceDefault];
	
	
	[field becomeFirstResponder];
	[dialog show];
	[dialog release];
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"button index: %i", buttonIndex);
	NSLog(@"tag: %i", alertView.tag);
	NSLog(@"%@", field.text);

	if (buttonIndex == [alertView cancelButtonIndex])
		return;

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

	if (alertView.tag == 1)
	{
		[defs setObject: [field text] forKey: @"reddit_username"];
	}
	if (alertView.tag == 2)
	{
		[defs setObject: [field text] forKey: @"reddit_password"];
	}
	[defs synchronize];
	[tableview reloadData];
	
	[field autorelease];
	field = nil;
}

#pragma mark - Table view delegate

- (void) popUpMail: (NSString *) subject
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Hello"];
	[picker setToRecipients: [NSArray arrayWithObject: @"jszpilewski@me.com"]];
	
	
	// Fill out the email body text
	NSString *emailBody = @"Hey Minyx,\n\n";
	[picker setMessageBody:emailBody isHTML:NO];
	[picker setSubject: subject];
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	
	//hoster section
	if ([indexPath section] == 0)
	{
		NSInteger hoster = [indexPath row];
		
		[[NSUserDefaults standardUserDefaults] setInteger: hoster forKey: @"hoster"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	//reddit
	if ([indexPath section] == 1)
	{
		NSString *text = nil;
		if ([indexPath row] == 0)
			text = [[NSUserDefaults standardUserDefaults] objectForKey: @"reddit_username"];
		if ([indexPath row] == 1)
			text = [[NSUserDefaults standardUserDefaults] objectForKey: @"reddit_password"];
		
		[self makeAlert: [indexPath row] + 1 text: text];
	}
	
	//misc
	if ([indexPath section] == 2)
	{
		//suggest template
		if ([indexPath row] == 0)
		{
			[self popUpMail: @"Meme Yourself Template Suggestion"];
			return;
		}

		//contact developer
		if ([indexPath row] == 1)
		{
			[self popUpMail: @"Meme Yourself Feedback"];
			return;
		}
		
		//visit minyx
		if ([indexPath row] == 2)
		{
			[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://www.minyxgames.com"]];
			return;
		}
		
		//disable ads
		if ([indexPath row] == 3)
		{
			[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://www.minyxgames.com"]];
			return;
		}
	}
    

	
	[tableView reloadData];
}



@end
