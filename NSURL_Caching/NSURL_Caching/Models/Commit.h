//
//  Commit.h
//  NSURL_Caching
//
//  Created by sdk on 5/5/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Commit : NSObject

@property (nonatomic, retain) NSString * branchName;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * hash;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorAvatarUrl;


@property (nonatomic, retain) NSString * parentHash;


@end

NS_ASSUME_NONNULL_END
