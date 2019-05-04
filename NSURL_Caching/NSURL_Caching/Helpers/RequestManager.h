//
//  RequestManager.h
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestManager : NSObject

+ (RequestManager *)sharedInstance;
+ (NSString *) repositoryPath;

- (void) getPopularRepositoriesForSwiftAtPage: (NSInteger) pageIndex;
- (void) getCommitsForRepo: (Repo*) repository;

@end

NS_ASSUME_NONNULL_END
