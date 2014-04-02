/*
 * Copyright (C) 2014 Adnan Urooj (Deminem Solutions)
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "ADMediaShareRequest.h"
#import "ADLogger.h"

@interface ADMediaShareUtil : NSObject {
    
}

#pragma mark Remote Server Methods
+ (void)publishMedia:(ADMediaShareRequest *)request
       mediaFilePath:(NSString *)localMediaFilePath
           mediaType:(ContentType)mediaType
   completionHandler:(ADMediaRequestHandler)handler;

+ (void)publishMedia:(ADMediaShareRequest *)request
       mediaFileName:(NSString *)mediaFileName
           mediaData:(NSData *)mediaData
           mediaType:(ContentType)mediaType
   completionHandler:(ADMediaRequestHandler)handler;

#pragma mark Amazon S3 cloud Methods
+ (void)publishMediaOnAmazonS3:(ADAmazonS3Settings *)amazonS3Settings
                     mediaType:(ContentType)mediaType
            amazonS3UploadType:(AmazonS3UploadType)amazonS3UploadType
            localMediaFilePath:(NSString *)localMediaFilePath
            amazonS3BucketName:(NSString *)amazonS3BucketName
       amazonS3StorageFilePath:(NSString *)amazonS3StorageFilePath
             completionHandler:(ADMediaAmazonS3RequestHandler)handler;
@end
