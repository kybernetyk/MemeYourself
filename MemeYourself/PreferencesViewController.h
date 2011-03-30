//
//  PreferencesViewController.h
//  MemeYourself
//
//  Created by jrk on 30/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PreferencesViewController : UIViewController 
{
	NSArray *sectionCaptions;		//text that is shown in the UI
	NSArray *sectionTitles;			//titles that are shown for each section
	NSArray *sectionValues;			//mapped values of the 

	UITextField *field;
	
	IBOutlet UITableView *tableview;
}

@end
