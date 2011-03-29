//
//  MXUtil.h
//  MemeYourself
//
//  Created by jrk on 28/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MXUtil : NSObject {
    
}

+ (NSString *) pathForMeme: (NSString *) memeFilename;
+ (NSString *) pathForImage: (NSString *) imageFilename;
+ (NSString *) pathForTemplate: (NSString *) templateFilename;

+ (NSString *) memeDir;
+ (NSString *) imageDir;
+ (NSString *) templateDir;


@end
