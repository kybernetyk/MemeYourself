//
//  MXUtil.m
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MXUtil.h"


@implementation MXUtil

+ (NSString *) pathForMeme: (NSString *) memeFilename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *imageDir = [documentsDirectory stringByAppendingPathComponent: @"images"];
	NSString *memeDir = [documentsDirectory stringByAppendingPathComponent: @"memes"];

	return [memeDir stringByAppendingPathComponent: memeFilename];
}

+ (NSString *) pathForImage: (NSString *) imageFilename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imageDir = [documentsDirectory stringByAppendingPathComponent: @"images"];
//	NSString *memeDir = [documentsDirectory stringByAppendingPathComponent: @"memes"];
	
	return [imageDir stringByAppendingPathComponent: imageFilename];
}

+ (NSString *) memeDir
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *imageDir = [documentsDirectory stringByAppendingPathComponent: @"images"];
	NSString *memeDir = [documentsDirectory stringByAppendingPathComponent: @"memes"];

	return memeDir;
}

+ (NSString *) imageDir
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imageDir = [documentsDirectory stringByAppendingPathComponent: @"images"];
//	NSString *memeDir = [documentsDirectory stringByAppendingPathComponent: @"memes"];

	return imageDir;
}


@end
