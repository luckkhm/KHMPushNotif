//
//  KHMApns.h
//  KHMApns
//
//  Created by Ahmed Khemiri on 1/26/17.
//  Copyright © 2017 Ahmed Khemiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHMApns : NSObject

extern NSString *const service;
+ (void)updateDeviceToken:(NSData *)deviceToken :(void (^)(bool succes,NSDictionary *result,NSError *error))isGet;
@end
