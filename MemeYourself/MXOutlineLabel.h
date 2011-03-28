//
//  MXOutlineLabel.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MXOutlineLabel : UILabel 
{
    CGFloat outlineSize;
}

@property (readwrite, assign) CGFloat outlineSize;

@end
