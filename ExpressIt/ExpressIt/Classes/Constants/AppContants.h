//
//  AppContants.h
//  ExpressIt
//
//  Created by Deminem on 15/03/2014.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONTENT_TYPE_ACCEPT_KEY_PARAM @"Accept"
#define API_KEY_PARAM @"apikey"

@interface AppContants : NSObject

//************************** APP CONSTANTS **************************//

extern NSString * API_KEY;

extern NSString * CONTENT_MEDIA_TYPE;

extern NSString * TEMP_USER_ID;

extern NSInteger TEMP_IMAGE_WIDTH;

extern NSInteger TEMP_IMAGE_HEIGHT;

extern NSString * AMAZON_S3_TVM_URL;

extern NSString * AMAZON_S3_BUCKET_NAME;

extern NSString * REMOTE_DESCRIPTION_PARAM;

extern NSString * REMOTE_TYPE_PARAM;

extern NSString * REMOTE_SHORTURL_PARAM;

extern NSString * REMOTE_TYPE_PARAM_VALUE_IMAGE;

extern NSString * REMOTE_TYPE_PARAM_VALUE_VIDEO;

//************************** APP CONSTANTS **************************//


//************ Video Constants *************//

extern float  VIDEO_MAXIMUMDURATION;

extern float  VIDEO_MINIMUMDURATION;

//************ Video Constatns ************//



@end
