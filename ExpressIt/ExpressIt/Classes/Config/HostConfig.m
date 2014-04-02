//
//  HostConfig.m
//  ExpressIt
//
//  Created by Deminem on 15/03/2014.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "HostConfig.h"

@implementation HostConfig

//************************** HOST CONFIGURATION **************************//

NSString * HOST_PRODUCTION_URL = @"<< Production URL >>";

NSString * HOST_STAGING_URL = @"<< Staging URL >>";

NSString * HOST_DEVELOPMENT_URL = @"http://202.125.129.93:7070/xit/";

Environment environment = DEVELOPMENT;

//************************** HOST CONFIGURATION **************************//
/**
 * Get the selected host environment
 *
 */
+ (Environment)selectedEnvironment {
    return environment;
}

/**
 * Get the selected host environment uri
 *
 */
+ (NSString *)hostUri {
    
    NSString *hostUri = @"";
    
    switch (environment) {
        case PRODUCTION:
            hostUri = HOST_PRODUCTION_URL;
            break;

        case STAGING:
            hostUri = HOST_STAGING_URL;
            break;
            
        case DEVELOPMENT:
            hostUri = HOST_DEVELOPMENT_URL;
            break;
            
        default:
            NSLog(@"Host Environment is not defined!");
            break;
    }
    
    return hostUri;
}

@end
