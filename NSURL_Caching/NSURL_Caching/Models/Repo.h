//
//  Repo.h
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Repo : NSObject

@property (nonatomic, retain) NSString * ownerName;
@property (nonatomic, retain) NSString * name;

- (instancetype) initWithOwnerName: (NSString *)ownerName andName: (NSString *)name;

@end

NS_ASSUME_NONNULL_END
