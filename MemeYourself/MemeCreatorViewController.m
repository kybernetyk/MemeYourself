//
//  MemeCreatorViewController.m
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemeCreatorViewController.h"


@implementation MemeCreatorViewController
@synthesize imageView;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.imageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) takePicture: (id) sender
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle: @"LOLZ" 
													   delegate: self 
											  cancelButtonTitle: @"cancel"
										 destructiveButtonTitle: nil
											  otherButtonTitles: @"Take Photo", @"Photo Archive", nil];
	
	
	[sheet showFromBarButtonItem: sender animated: YES];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [actionSheet cancelButtonIndex])
		return;

	NSLog(@"%i", buttonIndex);
	
	UIImagePickerController *c = [[UIImagePickerController alloc] init];
	[c setAllowsEditing: YES];
	[c setDelegate: self];

	if (buttonIndex == 0)
		[c setSourceType: UIImagePickerControllerSourceTypeCamera];
	else
		[c setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
	
	[self presentModalViewController: c animated: YES];
	[c release];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *editedImage = [info objectForKey: UIImagePickerControllerEditedImage];
	UIImage *originalImage = [info objectForKey: UIImagePickerControllerOriginalImage];
	UIImage *image = originalImage;
	if (editedImage)
		image = editedImage;
	
	[self dismissModalViewControllerAnimated: YES];
	
	NSLog(@"orig: %@", originalImage);
	NSLog(@"edited: %@", editedImage);
	NSLog(@"image: %@", image);
	
	NSData *d = UIImagePNGRepresentation(image);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSDate *now = [NSDate date];
	int i = [now timeIntervalSince1970];
	
	NSString *fn = [NSString stringWithFormat: @"%i.png", i];
	[d writeToFile: [documentsDirectory stringByAppendingPathComponent: fn] atomically: YES];
	NSLog(@"%@", fn);
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName: kNewMemeAdded object: nil];

	
	image = [UIImage imageWithContentsOfFile: [documentsDirectory stringByAppendingPathComponent: fn]];
	
	[imageView setImage: image];
}
@end
