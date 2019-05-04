//
//  CoreDataHelper.h
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubResponse+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (GitHubResponse *)cachedResponseForUrl: (NSString*) urlPath;
+ (void)addResponseEnityBasedOn: (NSURLResponse*) response data: (NSData*) data andUrlPath: (NSString*) urlPath;
+ (void) cleanCleanable;

@end

NS_ASSUME_NONNULL_END
