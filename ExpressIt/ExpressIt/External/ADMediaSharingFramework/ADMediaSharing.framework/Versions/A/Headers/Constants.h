/*
 * Copyright 2010-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */


/**
 * This is the the DNS domain name of the endpoint your Token Vending
 * Machine is running.  (For example, if your TVM is running at
 * http://mytvm.elasticbeanstalk.com this parameter should be set to
 * mytvm.elasticbeanstalk.com.)
 */
#define TOKEN_VENDING_MACHINE_URL    @"http://mpanontvm-env.elasticbeanstalk.com/"

/**
 * This indiciates whether or not the TVM is supports SSL connections.
 */
#define USE_SSL                      NO


#define CREDENTIALS_ALERT_MESSAGE    @"Please provide amazon S3 configurations with your credentials or Token Vending Machine URL."
//#define ACCESS_KEY_ID                @"AKIAIYNADA4LZNEAVKBA"  // Leave this value as is.
//#define SECRET_KEY                   @"F+wkdN5KC8wenk47+XAQJfVCEVv9XxN9EK3OUAZF"  // Leave this value as is.
#define __MY_APPS_BUCKET_NAME__      @"expressit-development"
#define __USERNAME__ @"TVMUser"
#import <UIKit/UIKit.h>

@interface Constants:NSObject {
}

//+(UIAlertView *)credentialsAlert;
//+(UIAlertView *)errorAlert:(NSString *)message;
//+(UIAlertView *)expiredCredentialsAlert;

@end
