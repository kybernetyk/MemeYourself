/*
 *  NotificationSystem.mm
 *  Fruitmunch
 *
 *  Created by jrk on 8/12/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "NotificationSystem.h"

void post_notification (NSString *notificationName, id object)
{
	NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
	[dc postNotificationName: notificationName object: object];
}