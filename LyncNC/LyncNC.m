//
//  LyncNC.m
//  LyncNC
//
//  Created by Dominik Pich on 03.01.13.
//  Copyright (c) 2013 info.pich. All rights reserved.
//

#import "LyncNC.h"
#import "NSWindow+WillOrderIn.h"
#import "LyncCommonAlertWindowController.h"
#import <objc/runtime.h>

@implementation LyncNC

/**
 * A special method called by SIMBL once the application has started and all classes are initialized.
 */
+ (void) load {
    LyncNC *plugin = [LyncNC sharedInstance];

    NSMutableSet *windows = [NSMutableSet set];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillOrderIn
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      if(![windows containsObject:note.object]) {
                                                          [windows addObject:note.object];
                                                          [plugin windowShown:note.object];
                                                      }
                                                      else
                                                          NSLog(@"already opened window not readded");
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      if([windows containsObject:note.object]) {
                                                          [windows removeObject:note.object];
                                                      }
                                                      else
                                                          NSLog(@"never opened window closing");
                                                  }];
}

/**
 * initializes a single instance of our plugin
 * @return the single static instance of the plugin object
 */
+ (LyncNC*) sharedInstance {
    static LyncNC* plugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plugin = [[self alloc] init];
    });
    return plugin;
}

#pragma mark lync alerts

- (void)windowShown:(NSWindow*)alertWindow {
    id controller = alertWindow.delegate;
    if([controller isKindOfClass:NSClassFromString(@"LyncCommonAlertWindowController")]) {
        [self lyncAlertShown:controller];
        alertWindow.alphaValue = 0;
        [alertWindow setFrame:NSZeroRect display:NO];
    }
}

- (void)lyncAlertShown:(id)controller {
    NSString *name = [[controller contactNameField] stringValue];
    NSString *text = [[controller contextField] stringValue];

//    //doesnt work yet as image is provided async
//    Ivar ivar = class_getInstanceVariable([controller class], [@"contactPhotoImageView" UTF8String]);
//    NSImageView *contactPhotoImageView = object_getIvar(controller, ivar);
//    NSImage *image = contactPhotoImageView.image;
//    image = nil;
    
    [self notifyWithTitle:name
              description:text
                    image:nil];
}

#pragma mark notification center

/**
 * helper method that gets called to deliver a notification. 
 * it checks wether notification center is available first too
 */
- (void)notifyWithTitle:(NSString*)title description:(NSString*)desc image:(NSImage*)image {
    NSUserNotification *note = [[NSUserNotification alloc] init];
    note.title = title;
    note.informativeText = desc;
    //10.8
    if(image && [note respondsToSelector:@selector(setContentImage:)]) {
        note.contentImage = image;
    }
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:note];
    [note release];
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    [NSApp activateIgnoringOtherApps:YES];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end