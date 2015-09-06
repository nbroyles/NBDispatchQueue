//
//  main.m
//  DispatchQueue
//
//  Created by Nate Broyles on 9/6/15.
//  Copyright (c) 2015 Nate Broyles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBDispatchQueue.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NBDispatchQueue *queue = [NBDispatchQueue globalQueue];

        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

        [queue dispatchSync:^{
            NSLog(@"%@", [DateFormatter stringFromDate:[NSDate date]]);
            [NSThread sleepForTimeInterval:10.0f];
        }];

        for (int i = 0; i < 200; ++i) {
            [queue dispatchAsync:^{
                NSLog(@"This is test #%d", i);
            }];
        }

        // Arbitrary sleep to let child threads finish
        [NSThread sleepForTimeInterval:5.0f];

        NSLog(@"Done!");
    }
    return 0;
}
