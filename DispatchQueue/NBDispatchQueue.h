//
//  NBDispatchQueue.h
//  DispatchQueue
//
//  Created by Nate Broyles on 9/6/15.
//  Copyright (c) 2015 Nate Broyles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBDispatchQueue : NSObject

+ (NBDispatchQueue *)globalQueue;

- (id)initSerial:(BOOL)serial;

- (void)dispatchAsync:(dispatch_block_t)block;
- (void)dispatchSync:(dispatch_block_t)block;

@end
