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

typedef enum ADRequestMethod {
    LOGGER_INFO,
    LOGGER_DEBUG,
    LOGGER_WARN,
    LOGGER_ERROR
    
} LoggerLevel;

@interface ADLogger : NSObject {
    
}

#pragma mark Public Methods
+ (void)log:(LoggerLevel)type mesage:(NSString *)msg;

@end
