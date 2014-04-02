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

@interface ADAmazonS3Settings : NSObject {
    
    NSString *_tokenVendingMachineURL;
    NSString *_myAppAmazonS3BucketName;
    NSString *_amazonS3UserName;
    NSString *_accessKeyId;
    NSString *_secretKey;
    
    BOOL _useSSL;
}

#pragma mark Properties
/**
 * This is the the DNS domain name of the endpoint your Token Vending
 * Machine is running.  (For example, if your TVM is running at
 * http://mytvm.elasticbeanstalk.com this parameter should be set to
 * mytvm.elasticbeanstalk.com.)
 */
@property (strong, nonatomic) NSString *tokenVendingMachineURL;

/**
 * This is the amazon S3 bucket name, which would be used to upload the media
 */
@property (strong, nonatomic) NSString *myAppAmazonS3BucketName;

/**
 * This is the amazon S3 bucket name, which would be used to upload the media
 */
@property (strong, nonatomic) NSString *amazonS3UserName;

/**
 * This is the access key and secret token required for specific scenrios
 */
@property (strong, nonatomic) NSString *accessKeyId;
@property (strong, nonatomic) NSString *secretKey;

/**
 * This indiciates whether or not the TVM is supports SSL connections.
 */
@property (nonatomic) BOOL useSSL;

#pragma mark Public Methods
- (id)initWithTokenVendingMachineURL:(NSString *)tokenVendingMachineURL
             myAppAmazonS3BucketName:(NSString *)myAppAmazonS3BucketName
                              useSSL:(BOOL)useSSL;

- (id)initWithTokenVendingMachineURL:(NSString *)tokenVendingMachineURL
             myAppAmazonS3BucketName:(NSString *)myAppAmazonS3BucketName
                    amazonS3UserName:(NSString *)amazonS3UserName
                              useSSL:(BOOL)useSSL;

- (id)initWithTokenVendingMachineURL:(NSString *)tokenVendingMachineURL
             myAppAmazonS3BucketName:(NSString *)myAppAmazonS3BucketName
                    amazonS3UserName:(NSString *)amazonS3UserName
                         accessKeyId:(NSString *)accessKeyId
                           secretKey:(NSString *)secretKey
                              useSSL:(BOOL)useSSL;

@end
