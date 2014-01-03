//
//  NSWindow+WillOrderIn.m
//  LyncNC
//
//  Created by Dominik Pich on 02/01/14.
//  Copyright (c) 2014 info.pich. All rights reserved.
//

#import "NSWindow+WillOrderIn.h"
#import "NSObject+MethodSwizzle.h"

@implementation NSWindow (WillOrderIn)

+ (void)load {
    [self swizzleInstanceMethodWithSelector:@selector(orderWindow:relativeTo:) withSelector:@selector(xchg_orderWindow:relativeTo:)];
}

//should also override other methods!
- (void)xchg_orderWindow:(NSWindowOrderingMode)place relativeTo:(NSInteger)otherWin {
    if(!self.isVisible && place!=NSWindowOut) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NSWindowWillOrderIn object:self];
    }
    [self xchg_orderWindow:place relativeTo:otherWin];
}

@end

//will be sent as notification only
NSString *NSWindowWillOrderIn = @"NSWindowWillOrderIn";