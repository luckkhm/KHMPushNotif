//
//  KHMApns.m
//  KHMApns
//
//  Created by Ahmed Khemiri on 1/26/17.
//  Copyright © 2017 Ahmed Khemiri. All rights reserved.
//

#import "KHMApns.h"

@implementation KHMApns
+(NSDictionary *)headersFields{
    NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded"};
    return headers;
}

+(NSMutableURLRequest *)requestWithUrl:(NSURL *)url timeoutInterval:(NSTimeInterval)timeOut setHTTPMethod:(NSString *)method withParamHeaderFields:(NSDictionary *)headerFields andDeviceToken:(NSData *) deviceTocken{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:timeOut];
    
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[@"deviceID=khm" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"&deviceToken=%@",deviceTocken ] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:method];
    [request setAllHTTPHeaderFields:headerFields];
    [request setHTTPBody:postData];
    
    return request;
}
+(void)parserWebServiceWithRequest:(NSMutableURLRequest *)request getFinish:(void (^)(bool succes,NSDictionary *result,NSError *error))isGet{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            @autoreleasepool {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
                id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                switch (httpResp.statusCode) {
                    case 200:{
                        isGet(true,jsonObjects,nil);
                    }
                        break;
                    case 404:
                        isGet(false,(NSDictionary *)@"Are you connected? Check your network and try again.",nil);
                        break;
                    default:
                        isGet(false,(NSDictionary *)@"Check your info and try again",nil);
                        break;
                }
            }
        }
        else {
            isGet(false,(NSDictionary *)error,error);
        }
    }] resume];
    
}





+ (void)updateDeviceToken:(NSData *)deviceToken :(void (^)(bool succes,NSDictionary *result,NSError *error))isGet{

    NSMutableURLRequest *request = [self requestWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",service]] timeoutInterval:8.0 setHTTPMethod:@"POST" withParamHeaderFields:[self headersFields] andDeviceToken:deviceToken];
    
#if DEBUG
    NSLog(@"Start updateDeviceToken");
#endif
    
    [self parserWebServiceWithRequest:request getFinish:^(bool succes, NSDictionary *result, NSError *error) {
        if (succes) {
            isGet(true,result,nil);
        }
        else{
            isGet(false,result,error);
        }
    }];
    
}


@end
