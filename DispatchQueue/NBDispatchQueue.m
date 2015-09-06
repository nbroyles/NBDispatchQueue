//
//  NBDispatchQueue.m
//  DispatchQueue
//
//  Created by Nate Broyles on 9/6/15.
//  Copyright (c) 2015 Nate Broyles. All rights reserved.
//

#import "NBDispatchQueue.h"
#import "NBThreadPool.h"

@implementation NBDispatchQueue {
    NSLock *_lock;
    NSMutableArray *_pendingBlocks;
    BOOL _serial;
    BOOL _serialRunning;
}

static NBDispatchQueue *gGlobalQueue;
static NBThreadPool *gThreadPool;

+ (void)initialize;
{
    // Check the class here because if this is ever subclassed and it doesn't
    // implement initialize then the superclass' initialize method will
    // be called -- meaning it could be invoked twice
    if (self == [NBDispatchQueue class]) {
        gGlobalQueue = [[NBDispatchQueue alloc] initSerial:NO];
        gThreadPool = [[NBThreadPool alloc] init];
    }
}

+ (NBDispatchQueue *)globalQueue;
{
    return gGlobalQueue;
}

- (id)initSerial:(BOOL)serial;
{
    if (self = [super init]) {
        _lock = [[NSLock alloc] init];
        _pendingBlocks = [[NSMutableArray alloc] init];
        _serial = serial;
    }
    return self;
}

- (void)dispatchOneBlock;
{
    [gThreadPool addBlock: ^{
        [_lock lock];
        dispatch_block_t block = [_pendingBlocks firstObject];
        [_pendingBlocks removeObjectAtIndex:0];
        [_lock unlock];

        block();

        if (_serial) {
            [_lock lock];
            if ([_pendingBlocks count] > 0) {
                [self dispatchOneBlock];
            } else {
                _serialRunning = NO;
            }
            [_lock unlock];
        }
    }];
}

- (void)dispatchAsync:(dispatch_block_t)block;
{
    [_lock lock];
    [_pendingBlocks addObject:block];

    if (_serial && !_serialRunning) {
        _serialRunning = YES;
        [self dispatchOneBlock];
    } else if (!_serial) {
        [self dispatchOneBlock];
    }

    [_lock unlock];
}

- (void)dispatchSync:(dispatch_block_t)block;
{
    NSCondition *condition = [[NSCondition alloc] init];
    __block BOOL done = NO;

    [self dispatchAsync:^{
        block();
        [condition lock];
        done = YES;
        [condition signal];
        [condition unlock];
    }];

    [condition lock];
    while (!done) {
        [condition wait];
    }
    [condition unlock];
}

@end
