//
//  SaveVideoSession.h
//  ExpressIt
//
//  Created by naveen on 4/4/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveVideoSession : NSObject<NSCoding> {
    NSMutableArray * arrayOfSessions;
    NSTimer *durationTime;
    float durationProgressTime;
}
@property (nonatomic, retain) NSMutableArray * arrayOfSessions;
@property (nonatomic, retain) NSTimer *durationTime;
@property (nonatomic) float durationProgressTime;
- (id)initWithArray:(NSMutableArray *)arraysOfSessions durationTime:(NSTimer *)durationTimer durationProgressTime:(float)progressTime;

@end
