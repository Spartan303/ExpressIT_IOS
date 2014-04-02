//
//  EXRemoteGetCall.h
//  ExpressIt
//
//  Created by naveen on 3/18/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _EX_RESPONSE_FORMAT{
    EX_RESPONSE_FORMAT_XML,
    EX_RESPONSE_FORMAT_JSON,
    EX_RESPONSE_FORMAT_STRING
} EX_RESPONSE_FORMAT;


typedef void (^CompletionResponse)(id string);
typedef void (^FailureResponse)(NSError *error);



@interface EXRemoteCall : NSObject <NSURLConnectionDelegate> {
    
     NSMutableData *urlData;
     EX_RESPONSE_FORMAT dataFormat;
}
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) CompletionResponse completionResponse;
@property (nonatomic, strong) FailureResponse failureResponse;

- (id)initWithURL:(NSString *)url;

- (void)fetchResponseWithFormat:(EX_RESPONSE_FORMAT)format
              dataWithCompletion:(CompletionResponse)completion
                         failure:(FailureResponse)failure;

- (void)fetchTheResponseWithParameters:(NSMutableDictionary *)dict
                                format:(EX_RESPONSE_FORMAT)format
                    dataWithCompletion:(CompletionResponse)completion
                               failure:(FailureResponse)failure;
- (NSData*)encodePostValueParameters:(NSDictionary*)dictionary;
@end
