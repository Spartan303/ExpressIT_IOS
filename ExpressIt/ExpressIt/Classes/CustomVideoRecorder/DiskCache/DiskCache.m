//
//  DiskCache.m
//  SampleMKKit
//
//  Created by naveen on 2/11/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "DiskCache.h"

@implementation DiskCache


+ (NSMutableArray *)cachedData:(NSString *)filePath
{
    
   NSMutableArray * array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return array;
    
}
+ (void)writeToFile:(NSMutableArray *)array filePath:(NSString *)filePath override:(BOOL)function
{
//    NSFileHandle *file;
//    
//    file = [NSFileHandle fileHandleForUpdatingAtPath: @"/tmp/quickfox.txt"];
//    
//    if (file == nil)
//        NSLog(@"Failed to open file");
//    
//    [file truncateFileAtOffset: 0];
//    
//    [file closeFile];
    
    
 [NSKeyedArchiver archiveRootObject:array toFile:filePath];


}

@end
