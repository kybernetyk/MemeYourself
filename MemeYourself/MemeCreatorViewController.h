//
//  MemeCreatorViewController.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MemeCreatorViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    
	UIImageView *imageView;
}
@property (retain) IBOutlet UIImageView *imageView;

- (IBAction) takePicture: (id) sender;

@end
