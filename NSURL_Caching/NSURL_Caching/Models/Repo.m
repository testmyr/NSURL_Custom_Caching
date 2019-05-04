//
//  Repo.m
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import "Repo.h"

@implementation Repo

@synthesize ownerName, name;

- (instancetype) initWithOwnerName: (NSString *)ownerName andName: (NSString *)name {    
    self = [super init];
    if (self) {
        self.ownerName = ownerName;
        self.name = name;
    }
    return self;
}

@end
