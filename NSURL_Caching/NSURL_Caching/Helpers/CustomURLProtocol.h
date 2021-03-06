//
//  CustomURLProtocol.h
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomURLProtocol : NSURLProtocol

@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSURLResponse *response;

@end

NS_ASSUME_NONNULL_END
