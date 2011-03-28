//
//  MemeArchiveViewController.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemeArchiveViewController : UIViewController 
{
	UIScrollView *scrollView;
	
	NSMutableDictionary *filenames;
	
	BOOL needsRefresh;
	
	int selectedTag;
}

@property (retain) IBOutlet UIScrollView *scrollView;
@property (assign) BOOL needsRefresh;

@end
