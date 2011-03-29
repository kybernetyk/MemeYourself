//
//  VZImgurUpload.m
//  MemeYourself
//
//  Created by jrk on 29/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VZImgurUpload.h"
#import "NSString+Additions.h"
#import "SBJSON.h"

@implementation VZImgurUpload

- (NSDictionary *) postFields
{
	NSMutableDictionary *postFields = [NSMutableDictionary dictionary];
	
	[postFields setObject: data forKey: @"image"];
	[postFields setObject: IMGUR_API_KEY forKey: @"key"];
	
	
	return postFields;
}

- (NSString *) hostUploadURL
{
	return @"http://api.imgur.com/2/upload.json";
}


- (void) processReturnValue: (NSString *) returnValue
{
	NSLog(@"return val: %@", returnValue);
	
	if ([returnValue containsString: @"error" ignoringCase: YES])
	{
		[self messageDelegateFailure];
		return;
	}

	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	id obj = [[parser objectWithString: returnValue] valueForKey: @"upload"];
	NSLog(@"obj: %@", obj);
	
	id links = [obj valueForKey: @"links"];
	NSLog(@"links: %@", links);
	
	id orig = [links valueForKey: @"original"];
	NSLog(@"%@", orig);
			  

	orig = [orig stringByReplacingOccurrencesOfString:@"imgur.com" withString:@"i.imgur.com"];
	
	[self messageDelegateSuccess: [NSString stringWithFormat:@"%@", orig]];
	
//	
//	NSString *url = [[returnValue componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] objectAtIndex: 0];
//	url = [url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//	
//	
	
	/*
	 NSError *error;	
	 NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString: returnValue options: NSXMLDocumentTidyHTML error: &error];
	 
	 if (document) 
	 {
	 NSArray *result = [document objectsForXQuery:@"for $img in //image_link return $img" constants:nil error:&error];
	 
	 if ([result count] <= 0)
	 {
	 NSLog(@"the result was nil bitch. there seems to be an error!");
	 NSLog(@"return val from image shack: %@",returnValue);
	 [document release];
	 [self messageDelegateFailure];
	 return;
	 }
	 
	 NSString *retval = [NSString stringWithString: [[result objectAtIndex: 0] stringValue]];
	 
	 [document release];
	 [self messageDelegateSuccess: [NSString stringWithFormat:@"%@", retval]];
	 return;
	 }
	 [document release];
	 [self messageDelegateFailure];
	 NSLog(@"UPS! no document bitch! %@",error);*/
	//NSLog(@"HTLR RETURN: %@", returnValue);
}


@end
