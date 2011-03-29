//
//  MemeTemplateViewController.h
//  MemeYourself
//
//  Created by jrk on 29/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MemeTemplateViewController : UIViewController 
{
	id delegate;    
	
	IBOutlet UIScrollView *scrollView;
	NSMutableDictionary *filenames;
}

@property (readwrite, assign) id delegate;

- (IBAction) cancel: (id) sender;

@end
