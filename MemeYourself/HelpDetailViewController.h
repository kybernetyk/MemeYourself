//
//  HelpDetailViewController.h
//  MemeYourself
//
//  Created by jrk on 30/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpDetailViewController : UIViewController 
{
	NSString *helpFile;    
	
	IBOutlet UIWebView *webView;
}

@property (readwrite, retain) NSString *helpFile;

@end
