//
//  NSWindow+WillOrderIn.h
//  LyncNC
//
//  Created by Dominik Pich on 02/01/14.
//  Copyright (c) 2014 info.pich. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (WillOrderIn)

@end

//will be sent as notification only
extern NSString *NSWindowWillOrderIn;