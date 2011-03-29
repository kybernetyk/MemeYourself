//
//  MemeCreatorViewController.m
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemeCreatorViewController.h"
#import "MXOutlineLabel.h"
#import "SelectMemeViewController.h"

@implementation MemeCreatorViewController
@synthesize imageView;
@synthesize currentFilename;

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
	[self setCurrentFilename: nil];
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
	[lowerLabel setFont: [UIFont fontWithName: @"Arial-BoldMT" size: 24.0]];
	[upperLabel setFont: [UIFont fontWithName: @"Arial-BoldMT" size: 24.0]];
	[lowerLabel setOutlineSize: 6];
	[upperLabel setOutlineSize: 6];
	
	NSLog(@"%@", lowerLabel);
	NSLog(@"%f", [lowerLabel outlineSize]);

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
											  otherButtonTitles: @"Take Photo", @"Camera Roll", @"Previous Memes", nil];
	
	
	[sheet showFromBarButtonItem: sender animated: YES];
	[sheet release];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [actionSheet cancelButtonIndex])
		return;

	if (buttonIndex == 2)
	{
		SelectMemeViewController *vc = [[SelectMemeViewController alloc] initWithNibName: @"SelectMemeViewController" bundle: nil];
		[vc setDelegate: self];
		[self presentModalViewController: vc animated: YES];
		[vc release];
		return;
	}
	
	NSLog(@"%i", buttonIndex);
	
	UIImagePickerController *c = [[UIImagePickerController alloc] init];
	[c setAllowsEditing: YES];
	[c setDelegate: self];

	if (buttonIndex == 0)
		[c setSourceType: UIImagePickerControllerSourceTypeCamera];
	if (buttonIndex == 1)
		[c setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
	
	[self presentModalViewController: c animated: YES];
	[c release];
}

-(UIImage *)imageWithImage:(UIImage *)image covertToSize:(CGSize)size 
{
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();
	return destImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *editedImage = [info objectForKey: UIImagePickerControllerEditedImage];
	UIImage *originalImage = [info objectForKey: UIImagePickerControllerOriginalImage];
	UIImage *image = originalImage;
	if (editedImage)
		image = editedImage;
	
	[self dismissModalViewControllerAnimated: YES];
	
	if (image.size.width < 640 || image.size.height < 640)
	{
		CGSize sz = CGSizeMake(640, 640);
		image = [self imageWithImage: image covertToSize: sz];
	}
	
	NSLog(@"size: %f,%f", image.size.width, image.size.height);

	NSData *d = UIImagePNGRepresentation(image);
	
	NSDate *now = [NSDate date];
	int i = [now timeIntervalSince1970];
	
	NSString *fn = [NSString stringWithFormat: @"%i.png", i];
	[d writeToFile: [MXUtil pathForImage: fn] atomically: YES];
	NSLog(@"%@", fn);

	
	image = [UIImage imageWithContentsOfFile: [MXUtil pathForImage: fn]];
	
	[imageView setImage: image];
	[self setCurrentFilename: fn];
}


//forward tap to the appropriate checkbox if the users releases his finger in a label
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex: 0];
	
	if (![[touch view] isKindOfClass: [MXOutlineLabel class]])
		return;
	
//	CGPoint p = [touch locationInView: [self view]];	
	
	int tag = [[touch view] tag];

	NSLog(@"tag: %i", tag);

	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Enter Text"];
	[dialog setMessage:@" "];
	[dialog addButtonWithTitle:@"Cancel"];
	[dialog addButtonWithTitle:@"OK"];
	[dialog setTag: tag];
	
	field = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
	[field setBackgroundColor:[UIColor whiteColor]];
	[field becomeFirstResponder];
	[dialog addSubview: field];
	//CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
	//[dialog setTransform: moveUp];
	
	if (tag == 1)
		[field setText: [upperLabel text]];
	if (tag == 2)
		[field setText: [lowerLabel text]];

	[field setClearButtonMode: UITextFieldViewModeWhileEditing];
	[field setKeyboardType: UIKeyboardTypeAlphabet];
	[field setKeyboardAppearance: UIKeyboardAppearanceAlert];
	

	[field becomeFirstResponder];
	[dialog show];
	[dialog release];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"tag: %i", alertView.tag);
	
	NSLog(@"%@", field.text);
	MXOutlineLabel *l;
	
	if (alertView.tag == 1)
	{
		[upperLabel setText: [field text]];	
		l = upperLabel;
	}
	if (alertView.tag == 2)
	{
		[lowerLabel setText: [field text]];	
		l = lowerLabel;
	}
	
	
	/* This is where we define the ideal font that the Label wants to use.
	 Use the font you want to use and the largest font size you want to use. */
	UIFont *font = [l font];
	
	int i;
	/* Time to calculate the needed font size. This for loop starts at the largest font size, and decreases by two point sizes (i=i-2) Until it either hits a size that will fit or hits the minimum size we want to allow (i > 10) */
	for(i = 28; i > 10; i=i-2)
	{
		// Set the new font size.
		font = [font fontWithSize:i];
		// You can log the size you're trying: NSLog(@"Trying size: %u", i);
		
		/* This step is important: We make a constraint box
		 using only the fixed WIDTH of the UILabel. The height will
		 be checked later. */
		CGSize constraintSize = CGSizeMake(260.0f, MAXFLOAT);
		
		// This step checks how tall the label would be with the desired font.
		CGSize labelSize = [[l text] sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		
		/* Here is where you use the height requirement!
		 Set the value in the if statement to the height of your UILabel
		 If the label fits into your required height, it will break the loop
		 and use that font size. */
		if(labelSize.height <= [l frame].size.height)
			break;
	}
	// You can see what size the function is using by outputting: NSLog(@"Best size is: %u", i);
	
	// Set the UILabel's font to the newly adjusted font.
	[l setFont: font];
	
	// Put the text into the UILabel outlet variable.
	
	
	[field autorelease];
}

-(void)selectMemeViewController: (SelectMemeViewController *) vc didReturnImageFilename: (NSString *) fn
{
	UIImage *image = [UIImage imageWithContentsOfFile: [MXUtil pathForImage: fn]];
	[imageView setImage: image];
	
	[self setCurrentFilename: fn];
}

- (void) trash:(id)sender
{
	[upperLabel setText: @""];
	[lowerLabel setText: @""];
	[imageView setImage: nil];
}

- (void) save:(id)sender
{
	CGSize s = [[imageView image] size];
	NSLog(@"%f - %f", s.width, s.height);
	
	CGSize t = [imageView bounds].size;
	
	float wf = s.width/t.width;
	float hf = s.height/t.height;
	
	CGPoint uc = [upperLabel center];
	CGPoint lc = [lowerLabel center];
	
	CGPoint p = uc;
	p.x *= wf;
	p.y *= hf;
	[upperLabel setCenter: p];

	p = lc;
	p.x *= wf;
	p.y *= hf;
	[lowerLabel setCenter: p];

	CGRect lowerFrame = [lowerLabel frame];
	CGRect upperFrame = [upperLabel frame];
	
	upperFrame.origin.x = 0;
	upperFrame.size.height *= hf;
	upperFrame.origin.y = 0;
	upperFrame.size.width = s.width;
	
	lowerFrame.origin.x = 0;
	lowerFrame.size.height *= hf;
	lowerFrame.origin.y = s.height - lowerFrame.size.height;
	lowerFrame.size.width = s.width;

	
	
	CGFloat lowerSize = [[lowerLabel font] pointSize];
	CGFloat upperSize = [[upperLabel font] pointSize];
	
	CGFloat lts = lowerSize;
	CGFloat uts = upperSize;
	
	[lowerLabel setFont: [UIFont fontWithName: @"Arial-BoldMT" size: lowerSize * hf]];
	[upperLabel setFont: [UIFont fontWithName: @"Arial-BoldMT" size: upperSize * hf]];

	
	UIGraphicsBeginImageContext([[imageView image] size]);
	[[imageView image] drawAtPoint: CGPointZero];
	[upperLabel drawTextInRect: upperFrame];
	[lowerLabel drawTextInRect: lowerFrame];
	
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[lowerLabel setFont: [UIFont fontWithName: @"Arial-BoldMT" size: lts]];
	[upperLabel setFont: [UIFont fontWithName: @"Arial-BoldMT" size: uts]];
	[upperLabel setCenter: uc];
	[lowerLabel setCenter: lc];
	NSData *d = UIImagePNGRepresentation(outputImage);
	
	NSDate *now = [NSDate date];
	int i = [now timeIntervalSince1970];
	
	NSString *fn = [NSString stringWithFormat: @"%i.png", i];
	[d writeToFile: [MXUtil pathForMeme: fn] atomically: YES];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName: kNewMemeAdded object: nil];

}

@end
