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
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ADLogger.h"
#import <AWSS3/S3PutObjectResponse.h>
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/S3PutObjectRequest.h>
#import "AmazonClientManager.h"
#import <AWSRuntime/AWSRuntime.h>
#import "ADAmazonS3Settings.h"

#define content_filePath @"filePath"
#define content_fileName @"file"

typedef enum _ADRequestMethod {
    ADRequestMethodGET,
    ADRequestMethodPUT,
    ADRequestMethodPOST,
    ADRequestMethodDELETE

} ADRequestMethod;

typedef enum _HttpStatusCodes {
    HttpSCTypeUnknown = 0,
	HttpSCTypeSuccess = 200,
	HttpSCTypeBadRequest = 400,
	HttpSCTypeUnauthorized = 401,
	HttpSCTypeNotFound = 402,
	HttpSCTypeInternalServerError = 500,
	HttpSCTypeBadGateway = 502,
    
} HttpStatusCodes;

typedef enum _ContentType {
    
    CONTENT_TYPE_NONE = -1,
    CONTENT_TYPE_IMAGE,
    CONTENT_TYPE_VIDEO,
    CONTENT_TYPE_TEXT
    
} ContentType;

typedef enum _AmazonS3UploadType {
    
    TVM_ANONYMOUS_TYPE,
    TVM_ANONYMOUS_IDENTITY_TYPE,
    DIRECT_S3_TYPE
    
} AmazonS3UploadType;

typedef void(^ADMediaRequestHandler)(NSURL *url, NSData *responseData, NSError *error);

typedef void(^ADMediaAmazonS3RequestHandler)(AmazonServiceResponse *response);

@interface ADMediaShareRequest : NSObject {

@private
    // Request Uri
    NSString *_requestUri;
    
    ASIFormDataRequest *_asiFormDataRequest;

    // Request Method
    ADRequestMethod _requestMethod;
    
    // Content Type
    ContentType _contentType;
    
    // Request POST content filename
    NSString *_conentFileName;

    // Request POST content localFilePath
    NSString *_contentLocalFilePath;
    
    // Dictionary for custom HTTP request headers
	NSMutableDictionary *_requestHeaders;
    
    // Dictionary for post body params
	NSMutableDictionary *_postBodyParams;
}

#pragma mark Properties
@property (strong, nonatomic) NSString *requestUri;
@property (nonatomic) ADRequestMethod requestMethod;
@property (nonatomic) ContentType contentType;
@property (strong, nonatomic) NSString *conentFileName;
@property (strong, nonatomic) NSString *contentLocalFilePath;
@property (strong, nonatomic) NSMutableDictionary *requestHeaders;
@property (strong, nonatomic) NSMutableDictionary *postBodyParams;

#pragma mark - Lifecyle Methods
- (id)initWithURL:(NSString *)url
   requestHeaders:(NSMutableDictionary *)headers
    requestMethod:(ADRequestMethod)requestMethod;

- (id)initWithURL:(NSString *)url
   requestHeaders:(NSMutableDictionary *)headers
      contentType:(ContentType)contentType
   postBodyParams:(NSMutableDictionary *)postBodyParams
    requestMethod:(ADRequestMethod)requestMethod;

- (id)initWithURL:(NSString *)url
  contentFileName:(NSString *)contentFileName
  contentFilePath:(NSString *)contentFilePath
      contentType:(ContentType)contentType
   requestHeaders:(NSMutableDictionary *)headers
   postBodyParams:(NSMutableDictionary *)postBodyParams
    requestMethod:(ADRequestMethod)requestMethod;

#pragma mark Remote Sever Methods
- (void)performRequestWithHandler:(ADMediaRequestHandler)handler;

- (void)performRequestWithHandler:(ADMediaRequestHandler)handler withData:(NSData *)data;

#pragma mark Amazon S3 Methods
- (void)performAmazonS3RequestWithHandler:(ADMediaAmazonS3RequestHandler)handler
                         amazonS3Settings:(ADAmazonS3Settings *)amazonS3Settings
                       localImageFilePath:(NSString *)localImageFilePath
                                mediaType:(ContentType)contentType
                       amazonS3bucketName:(NSString *)amazonS3bucketName
                       amazonS3UploadType:(AmazonS3UploadType)amazonS3UploadType
                  amazonS3StorageFilePath:(NSString *)amazonS3StorageFilePath;
@end
