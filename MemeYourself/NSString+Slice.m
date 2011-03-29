//
//  NSString+Slice.m
//  XFTest
//
//  Created by jrk on 24/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "NSString+Slice.h"


@implementation NSString (Slice)

#pragma mark -
#pragma mark index of substring ...
- (NSInteger) indexOfSubstring: (NSString *) substring startingAtIndex: (NSInteger) startIndex ignoringCase: (BOOL) flag
{
	unsigned mask = (flag ? NSCaseInsensitiveSearch : 0);
	
	NSRange range;
	range.location = startIndex;
	range.length = [self length] - startIndex;
	
	NSRange ret = [self rangeOfString: substring options: mask range: range];
	
	return ret.location;
}

- (NSInteger) indexOfSubstring: (NSString *) substring startingAtIndex: (NSInteger) startIndex
{
	return [self indexOfSubstring: substring startingAtIndex: startIndex ignoringCase: NO];
}



- (NSInteger) indexOfSubstring: (NSString *) substring ignoringCase: (BOOL) flag
{
	return [self indexOfSubstring: substring startingAtIndex: 0 ignoringCase: flag];
}

- (NSInteger) indexOfSubstring: (NSString *) substring
{
	return [self indexOfSubstring: substring ignoringCase: NO];	
}

#pragma mark -
#pragma mark string between ...
- (NSString *) stringBetweenSubstringOne: (NSString *) substringOne andSubstringTwo: (NSString *) substringTwo ignoringCase: (BOOL) flag
{
	NSInteger start = [self indexOfSubstring: substringOne ignoringCase: flag];
	if (start == NSNotFound)
		return nil;
	
	NSInteger stop = [self indexOfSubstring: substringTwo startingAtIndex: start ignoringCase: flag];
	if (stop == NSNotFound)
		return nil;
	
	start += [substringOne length];
	stop -= 1; //don't want the first char of substringTwo :]
	
	return [self stringBySlicingFrom: start to: stop];
	
}

- (NSString *) stringBetweenSubstringOne: (NSString *) substringOne andSubstringTwo: (NSString *) substringTwo
{
	return [self stringBetweenSubstringOne: substringOne andSubstringTwo: substringTwo ignoringCase: NO];
}


#pragma mark -
#pragma mark string by slicing ...
- (NSString *) stringBySlicingFrom: (NSUInteger) fromIndex to: (NSInteger) toIndex
{
	//-1 = to the end
	if (toIndex == -1)
		toIndex = [self length];

	//-2 == the 2nd char from the end, etc.
	if (toIndex < -1)
		toIndex = [self length] + toIndex;
	
	//fix for case if toIndex == self lenght 
	if (toIndex < [self length])
		toIndex ++;
	
	//bounds checking
	if (toIndex > [self length] || fromIndex > [self length])
		return nil;
	if (toIndex < fromIndex)
		return nil;
	if (fromIndex < 0)
		return nil;


	NSRange r;
	r.location = fromIndex;
	r.length = (toIndex - fromIndex);
		
	return [self substringWithRange: r];			 
}

- (NSString *) stringBySlicingFrom: (NSUInteger) fromIndex
{
	return [self stringBySlicingFrom: fromIndex to: [self length]];
}
- (NSString *) stringBySlicingTo: (NSInteger) toIndex
{
	return [self stringBySlicingFrom: 0 to: toIndex];
}


@end
