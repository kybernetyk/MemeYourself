//
//  HelpDetailViewController.m
//  MemeYourself
//
//  Created by jrk on 30/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpDetailViewController.h"


@implementation HelpDetailViewController
@synthesize helpFile;

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
	[self setHelpFile: nil];
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
	
	[webView setOpaque: NO];
	[webView setBackgroundColor: [UIColor clearColor]];

	NSURL *url = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: helpFile ofType: nil] isDirectory: NO];
	NSURLRequest *req = [NSURLRequest requestWithURL: url];
	
	[webView loadRequest: req];	

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

@end
