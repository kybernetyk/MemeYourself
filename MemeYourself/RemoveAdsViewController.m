//
//  RemoveAdsViewController.m
//  MemeYourself
//
//  Created by jrk on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RemoveAdsViewController.h"


@implementation RemoveAdsViewController

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) buyNow: (id) sender
{
	[[[UIApplication sharedApplication] delegate] resetBadge];
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://itunes.apple.com/us/app/meme-yourself-pro/id429650703?mt=8&ls=1"]];

}


@end
