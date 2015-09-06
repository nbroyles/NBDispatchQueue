//
//  NBThreadPool.h
//  DispatchQueue
//
//  Created by Nate Broyles on 9/6/15.
//  Copyright (c) 2015 Nate Broyles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBThreadPool : NSObject

- (void)addBlock:(dispatch_block_t)block;

@end
