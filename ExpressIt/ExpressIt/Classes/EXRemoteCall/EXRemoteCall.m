//
//  EXRemoteGetCall.m
//  ExpressIt
//
//  Created by naveen on 3/18/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "EXRemoteCall.h"

@implementation EXRemoteCall

// Customise the init methods..
// Directly sets the urls while calling...
- (id)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}
// Fetch the respose and added the completion handlers . Which is for the get service call.
- (void)fetchResponseWithFormat:(EX_RESPONSE_FORMAT)format
              dataWithCompletion:(CompletionResponse)completion
                         failure:(FailureResponse)failure {
    
     dataFormat = format;
    _completionResponse = completion;
    _failureResponse = failure;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}
//fetch the post request response by calling the service with the parameters....
- (void)fetchTheResponseWithParameters:(NSMutableDictionary *)dict
                                format:(EX_RESPONSE_FORMAT)format
                    dataWithCompletion:(CompletionResponse)completion
                               failure:(FailureResponse)failure {
     dataFormat = format;
    _completionResponse = completion;
    _failureResponse = failure;
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [request setHTTPBody:[self encodePostValueParameters:dict]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
    
}
// encoded the url form params .....
- (NSData*)encodePostValueParameters:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark ---------URL CONNECTION METHODS---------

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _failureResponse(error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
  
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    if (urlData) {
        urlData = nil;
    }
    urlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [urlData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *parsingError = nil;
    if (dataFormat == EX_RESPONSE_FORMAT_JSON) {
        id object = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&parsingError];
       
        if (parsingError) {
          
            _failureResponse(parsingError);
        } else {
          
            _completionResponse(object);
        }
    }
    else if (dataFormat == EX_RESPONSE_FORMAT_STRING) {
        id object = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
        _completionResponse(object);
    }
    else
    {
        //TODO
    }
}
@end
