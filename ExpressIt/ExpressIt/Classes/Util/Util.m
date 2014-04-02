//
//  Util.m
//  ExpressIt
//
//  Created by Deminem on 15/03/2014.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "Util.h"
#import "EXRemoteCall.h"
#import <ADMediaSharing/ADMediaSharing.h>
@interface Util(Private)

- (void)publishTheImageWithpostParams:(NSMutableDictionary *)params
                       localImagePath:(NSString *)localPath
                        shortMediaUrl:(NSString *)keyurl
                            uploadUrl:(NSString *)uploadUrl
                        fileExtension:(NSString *)fileExtension;

- (void)recallUploadImageToTheAmazonCloud:(NSMutableDictionary *)params
                           localImagePath:(NSString *)localPath
                                  keyname:(NSString *)key
                                uploadUrl:(NSString *)uploadUrl
                                   remote:(EXRemoteCall *)remote
                            fileExtension:(NSString *)fileExtension;

- (void)remoteCallToTheServerWithParams:(NSMutableDictionary *)params
                          remoteService:(EXRemoteCall *)remotecall;
@end

@implementation Util

+ (NSMutableDictionary *)requestHeaders {
    
    NSMutableDictionary *_requestHeaders = [[NSMutableDictionary alloc] init];
    [_requestHeaders setObject:API_KEY forKey:API_KEY_PARAM];
    [_requestHeaders setObject:CONTENT_MEDIA_TYPE forKey:CONTENT_TYPE_ACCEPT_KEY_PARAM];
    
    return _requestHeaders;
}

+ (ADAmazonS3Settings *)amazonS3Settings {
    
    ADAmazonS3Settings *_settings = [[ADAmazonS3Settings alloc]
                                    initWithTokenVendingMachineURL:AMAZON_S3_TVM_URL
                                    myAppAmazonS3BucketName:AMAZON_S3_BUCKET_NAME
                                    useSSL:NO];
    return _settings;
}
//Publish the media to the amazon......
- (void)publishTheMediaWithType:(MEDIATYPE)type
                     postParams:(NSMutableDictionary *)params
                 localImagePath:(NSString *)localPath
                    keyMediaUrl:(NSString *)mediakeyUrl
                 uploadMediaUrl:(NSString *)uplaodMediaUrl
                        handler:(completionHandler)handler
                  fileExtension:(NSString *)fileExtension {
    _completion = handler;
    if (type == MEDIATYPE_IMAGE) {
        [self publishTheImageWithpostParams:params
                             localImagePath:localPath
                              shortMediaUrl:mediakeyUrl
                                  uploadUrl:uplaodMediaUrl
                              fileExtension:fileExtension];
    } else {
        [self publishTheVideoWithpostParams:params
                             localVideoPath:localPath
                              shortMediaUrl:mediakeyUrl
                                  uploadUrl:uplaodMediaUrl
                              fileExtension:fileExtension];
    }
}

- (void)publishTheImageWithpostParams:(NSMutableDictionary *)params
                       localImagePath:(NSString *)localPath
                        shortMediaUrl:(NSString *)keyurl
                            uploadUrl:(NSString *)uploadUrl
                        fileExtension:(NSString *)fileExtension {
    
    EXRemoteCall * remoteCall = [[EXRemoteCall alloc]initWithURL:keyurl];
    [remoteCall fetchResponseWithFormat:EX_RESPONSE_FORMAT_STRING
                     dataWithCompletion:^(id string) {
                         
                         [params setValue:string forKey:REMOTE_SHORTURL_PARAM];
                         [self recallUploadImageToTheAmazonCloud:params
                                             localImagePath:localPath
                                                    keyname:string
                                                  uploadUrl:uploadUrl
                                                     remote:remoteCall
                                                   fileExtension:fileExtension];
                     } failure:^(NSError *error) {
                         _completion (nil, error);
                     }];

}

- (void)publishTheVideoWithpostParams:(NSMutableDictionary *)params
                       localVideoPath:(NSString *)localPath
                        shortMediaUrl:(NSString *)keyurl
                            uploadUrl:(NSString *)uploadUrl
                        fileExtension:(NSString *)fileExtension {
    
    EXRemoteCall * remoteCall = [[EXRemoteCall alloc]initWithURL:keyurl];
    [remoteCall fetchResponseWithFormat:EX_RESPONSE_FORMAT_STRING
                     dataWithCompletion:^(id string) {
                         
                         [params setValue:string forKey:REMOTE_SHORTURL_PARAM];
                         [self recallUploadVideoToTheAmazonCloud:params
                                             localImagePath:localPath
                                                    keyname:string
                                                  uploadUrl:uploadUrl
                                                     remote:remoteCall
                                                   fileExtension:fileExtension];
                     } failure:^(NSError *error) {
                         _completion (nil, error);
                     }];

}

- (void)recallUploadImageToTheAmazonCloud:(NSMutableDictionary *)params
                      localImagePath:(NSString *)localPath
                             keyname:(NSString *)key
                           uploadUrl:(NSString *)uploadUrl
                              remote:(EXRemoteCall *)remote
                            fileExtension:(NSString *)fileExtension {
    
    [ADMediaShareUtil publishMediaOnAmazonS3:[Util amazonS3Settings]
                                   mediaType:CONTENT_TYPE_IMAGE
                          amazonS3UploadType:TVM_ANONYMOUS_TYPE
                          localMediaFilePath:localPath
                          amazonS3BucketName:AMAZON_S3_BUCKET_NAME
                     amazonS3StorageFilePath:[NSString stringWithFormat:@"%@.%@",key,fileExtension]
                           completionHandler:^(AmazonServiceResponse *response) {
                               if (!response.error) {
                                   remote.url = uploadUrl;
                                   [self remoteCallToTheServerWithParams:params remoteService:remote];
                               }
                               else
                               {
                                   _completion (nil, response.error);
                               }
                           } ];
   
}

- (void)recallUploadVideoToTheAmazonCloud:(NSMutableDictionary *)params
                      localImagePath:(NSString *)localPath
                             keyname:(NSString *)key
                           uploadUrl:(NSString *)uploadUrl
                              remote:(EXRemoteCall *)remote
                            fileExtension:(NSString *)fileExtension {
    
    [ADMediaShareUtil publishMediaOnAmazonS3:[Util amazonS3Settings]
                                   mediaType:CONTENT_TYPE_VIDEO
                          amazonS3UploadType:TVM_ANONYMOUS_TYPE
                          localMediaFilePath:localPath
                          amazonS3BucketName:AMAZON_S3_BUCKET_NAME
                     amazonS3StorageFilePath:[NSString stringWithFormat:@"%@.%@",key,fileExtension]
                           completionHandler:^(AmazonServiceResponse *response) {
                               if (!response.error) {
                                   remote.url = uploadUrl;
                                   [self remoteCallToTheServerWithParams:params remoteService:remote];
                               }
                               else
                               {
                                   _completion (nil, response.error);
                               }
                           } ];
    
}

- (void)remoteCallToTheServerWithParams:(NSMutableDictionary *)params
                          remoteService:(EXRemoteCall *)remotecall {
    
    [remotecall fetchTheResponseWithParameters:params
                                        format:EX_RESPONSE_FORMAT_STRING
                            dataWithCompletion:^(id string) {
                                _completion(string, nil);
                            } failure:^(NSError *error) {
                                _completion(nil,error);
                            }];
}
//Checking the network status.....
+ (BOOL)networkStatus {
Reachability *reach = [Reachability reachabilityForInternetConnection];
NetworkStatus network = [reach currentReachabilityStatus];
    if (network == NotReachable) {
        return NO;
    } else {
        return YES;
    }
    
}

@end
