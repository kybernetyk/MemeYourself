//
//  MXOutlineLabel.m
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MXOutlineLabel.h"


@implementation MXOutlineLabel
@synthesize outlineSize;

- (void)drawTextInRect:(CGRect)rect {
	
	CGSize shadowOffset = self.shadowOffset;
	UIColor *textColor = self.textColor;
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(c, [[self font] pointSize]/4.0 );
	
	CGContextSetTextDrawingMode(c, kCGTextStroke);
	self.textColor = [UIColor blackColor];
	[super drawTextInRect:rect];
	
	CGContextSetTextDrawingMode(c, kCGTextFill);
	self.textColor = textColor;
	self.shadowOffset = CGSizeMake(0, 0);
	[super drawTextInRect:rect];
	
	self.shadowOffset = shadowOffset;
	
}

@end
