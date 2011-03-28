//
//  MemeArchiveViewController.m
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemeArchiveViewController.h"
#import "UIImageResizing.h"
#import "MemeDetailViewController.h"

enum JPImagePickerControllerThumbnailSize {
	kJPImagePickerControllerThumbnailSizeWidth = 75,
	kJPImagePickerControllerThumbnailSizeHeight = 75
};

enum JPImagePickerControllerPreviewImageSize {
	kJPImagePickerControllerPreviewImageSizeWidth = 320,
	kJPImagePickerControllerPreviewImageSizeHeight = 420
};
#define PADDING_TOP 4
#define PADDING 4
#define THUMBNAIL_COLS 4


@implementation MemeArchiveViewController
@synthesize scrollView;

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
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver: self];

    [super dealloc];
}

- (void) awakeFromNib
{
	[super awakeFromNib];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver: self selector: @selector(newMemeAdded:) name: kNewMemeAdded object: nil];
}

- (void) newMemeAdded: (NSNotification *) notification
{
	needsRefresh = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
	
	if (!needsRefresh)
		return;
	for (int i = 0; i < [[scrollView subviews] count]; i++ ) {
		[[[scrollView subviews] objectAtIndex:i] removeFromSuperview];
	}
	UIButton *button;
	UIImage *thumbnail;
	int images_count = 0;
	
	[filenames release];
	filenames = [[NSMutableDictionary alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSDirectoryEnumerator *e = [[NSFileManager defaultManager] enumeratorAtPath: documentsDirectory];
	
	NSMutableArray *a = [NSMutableArray array];
	
	int i = 0;
	for (NSString *fn in e)
	{
		NSLog(@"%@",fn);
		images_count ++;
		
		[a insertObject: fn atIndex: 0];
	}
	
	for (NSString *fn in a)
	{	
		[filenames setObject: fn forKey: [NSNumber numberWithInt: i]];
		
		thumbnail = [UIImage imageWithContentsOfFile: [documentsDirectory stringByAppendingPathComponent: fn]];
		thumbnail = [thumbnail scaleAndCropToSize: 
					 CGSizeMake(kJPImagePickerControllerThumbnailSizeWidth, kJPImagePickerControllerThumbnailSizeHeight)
									 onlyIfNeeded:NO];
		
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:thumbnail forState:UIControlStateNormal];
		button.showsTouchWhenHighlighted = YES;
		button.userInteractionEnabled = YES;
		[button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = i;
		button.frame = CGRectMake(kJPImagePickerControllerThumbnailSizeWidth * (i % THUMBNAIL_COLS) + PADDING * (i % THUMBNAIL_COLS) + PADDING,
								  kJPImagePickerControllerThumbnailSizeHeight * (i / THUMBNAIL_COLS) + PADDING * (i / THUMBNAIL_COLS) + PADDING + PADDING_TOP,
								  kJPImagePickerControllerThumbnailSizeWidth,
								  kJPImagePickerControllerThumbnailSizeHeight);
		
		[scrollView addSubview:button];
		
		
		i++;
	}
	
	int rows = images_count / THUMBNAIL_COLS;
	if (((float)images_count / THUMBNAIL_COLS) - rows != 0) 
	{
		rows++;
	}
	int height = kJPImagePickerControllerThumbnailSizeHeight * rows + PADDING * rows + PADDING + PADDING_TOP;
	
	scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
	scrollView.clipsToBounds = YES;
	needsRefresh = NO;
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
	
	needsRefresh = YES;
}

- (void) buttonTouched: (id) sender
{
	NSString *fn = [filenames objectForKey: [NSNumber numberWithInt: [sender tag]]];
	NSLog(@"button %i touched. filename: %@", [sender tag], fn);
	
	MemeDetailViewController *mdvc = [[MemeDetailViewController alloc] initWithNibName: @"MemeDetailViewController" bundle: nil];
	[mdvc setImageName: fn];
	
	[[self navigationController] pushViewController: mdvc animated: YES];
	[mdvc release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	[filenames release];
	filenames = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.scrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
