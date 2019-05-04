//
//  PopularRepositoriesViewModel.m
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import "PopularRepositoriesViewModel.h"
#import "RequestManager.h"
#import "CoreDataHelper.h"

@implementation PopularRepositoriesViewModel

@synthesize delegate;

NSMutableArray *repositories;

- (instancetype)initWithView: (id<PopularRepositoriesViewModelViewDelegate>) owner
{
    self = [super init];
    if (self) {
        self.delegate = owner;
    }
    return self;
}

- (void)start {
    repositories = [[NSMutableArray alloc] initWithCapacity:20];
    //TODO refactoring
    [[RequestManager sharedInstance] getPopularRepositoriesForSwiftAtPage:1
                                                                   sucess:^(id result){
                                                                       if (result != nil) {
                                                                           NSArray *recivedItems = (NSArray*) result;
                                                                           if (recivedItems != nil) {
                                                                               for (NSDictionary* item in recivedItems) {
                                                                                   NSString *name = item[@"name"];
                                                                                   NSString *descr = item[@"description"];
                                                                                   NSDictionary *owner = item[@"owner"];
                                                                                   NSString *ownerName;
                                                                                   NSString *ownerAvatarUrl;
                                                                                   if (owner != nil) {
                                                                                       ownerName = owner[@"login"];
                                                                                       ownerAvatarUrl = owner[@"avatar_url"];
                                                                                   }
                                                                                   Repo *newInst = [Repo new];
                                                                                   newInst.name = name;
                                                                                   newInst.descr = descr;
                                                                                   newInst.ownerName = ownerName;
                                                                                   newInst.ownerAvatarUrl = ownerAvatarUrl;
                                                                                   [repositories addObject:newInst];
                                                                               }
                                                                               [self.delegate updateView];
                                                                           }
                                                                       }
                                                                   }
                                                                  failure:^(NSError *result){
                                                                      
                                                                  }];
    
}

//pragma mark: - PopularRepositoriesViewModelProtocol

- (NSInteger) numberOfRepositories {
    return repositories.count;
}

- (Repo*) repoForRowAtIndex: (NSInteger) index {
    return repositories.count > 0 ? repositories[index] : 0;
}

- (void) loadNextPage {
    NSInteger duePageIndex = repositories.count / REPO_PAGE_SIZE.integerValue + 1;
    [[RequestManager sharedInstance] getPopularRepositoriesForSwiftAtPage:duePageIndex
                                                                   sucess:^(id result){
                                                                       if (result != nil) {
                                                                           NSArray *recivedItems = (NSArray*) result;
                                                                           if (recivedItems != nil) {
                                                                               for (NSDictionary* item in recivedItems) {
                                                                                   NSString *name = item[@"name"];
                                                                                   NSString *descr = item[@"description"];
                                                                                   NSDictionary *owner = item[@"owner"];
                                                                                   NSString *ownerName;
                                                                                   NSString *ownerAvatarUrl;
                                                                                   if (owner != nil) {
                                                                                       ownerName = owner[@"login"];
                                                                                       ownerAvatarUrl = owner[@"avatar_url"];
                                                                                   }
                                                                                   Repo *newInst = [Repo new];
                                                                                   newInst.name = name;
                                                                                   newInst.descr = descr;
                                                                                   newInst.ownerName = ownerName;
                                                                                   newInst.ownerAvatarUrl = ownerAvatarUrl;
                                                                                   [repositories addObject:newInst];
                                                                               }
                                                                               [self.delegate updateView];
                                                                           }
                                                                       }
                                                                   }
                                                                  failure:^(NSError *result){
                                                                      
                                                                  }];
}

- (void) cleanReposCache {    
    [CoreDataHelper cleanCleanable];
    [self start];
}

@end
