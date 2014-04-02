//
//  HostConfig.h
//  ExpressIt
//
//  Created by Deminem on 15/03/2014.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PRODUCTION  = 1,
    STAGING     = 2,
    DEVELOPMENT = 3
    
} Environment;

@interface HostConfig : NSObject

//************************** HOST CONFIGURATION **************************//

extern NSString * HOST_PRODUCTION_URL;

extern NSString * HOST_STAGING_URL;

extern NSString * HOST_DEVELOPMENT_URL;

extern Environment environment;

//************************** HOST CONFIGURATION **************************//

+ (Environment)selectedEnvironment;

+ (NSString *)hostUri;

@end
