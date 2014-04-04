//
//  SaveVideoSession.m
//  ExpressIt
//
//  Created by naveen on 4/4/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "SaveVideoSession.h"

@implementation SaveVideoSession
@synthesize arrayOfSessions;
@synthesize durationTime;
@synthesize durationProgressTime;
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:arrayOfSessions forKey:@"arrayOfSessions"];
    [encoder encodeObject:durationTime forKey:@"durationTime"];
    [encoder encodeFloat:durationProgressTime forKey:@"durationProgressTime"];
}
- (id)initWithCoder:(NSCoder *)decoder {
        if (self = [super init]) {
            self.arrayOfSessions = [decoder decodeObjectForKey:@"arrayOfSessions"];
            self.durationTime = [decoder decodeObjectForKey:@"durationTime"];
            self.durationProgressTime = [decoder decodeFloatForKey:@"durationProgressTime"];
        }
    return self;
}
- (id)initWithArray:(NSMutableArray *)arraysOfSessions durationTime:(NSTimer *)durationTimer durationProgressTime:(float)progressTime
{
    self = [super init];
    
    if (self) {
        self.arrayOfSessions = arraysOfSessions;
        self.durationTime = durationTimer;
        self.durationProgressTime = progressTime;
    }
    return  self;
}


@end
