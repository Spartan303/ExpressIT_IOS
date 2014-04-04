//
//  DiskCache.h
//  SampleMKKit
//
//  Created by naveen on 2/11/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskCache : NSObject

+ (NSMutableArray *)cachedData:(NSString *)filePath;
+ (void)writeToFile:(NSMutableArray *)array filePath:(NSString *)filePath override:(BOOL)function;


@end
