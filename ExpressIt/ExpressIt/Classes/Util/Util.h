//
//  Util.h
//  ExpressIt
//
//  Created by Deminem on 15/03/2014.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppContants.h"
#import <ADMediaSharing/ADAmazonS3Settings.h>
#import <ADMediaSharing/Reachability.h>
typedef enum _MEDIATYPE{
    MEDIATYPE_IMAGE,
    MEDIATYPE_VIDEO
} MEDIATYPE;

typedef void(^completionHandler)(id result, NSError * error);

@interface Util : NSObject {
    
    
    
}
@property (nonatomic, strong) completionHandler completion;

+ (NSMutableDictionary *)requestHeaders;
+ (ADAmazonS3Settings *)amazonS3Settings;

- (void)publishTheMediaWithType:(MEDIATYPE)type
                     postParams:(NSMutableDictionary *)params
                 localImagePath:(NSString *)localPath
                    keyMediaUrl:(NSString *)mediakeyUrl
                 uploadMediaUrl:(NSString *)uplaodMediaUrl
                        handler:(completionHandler)handler
                  fileExtension:(NSString *)fileExtension;

+ (BOOL)networkStatus;
@end
