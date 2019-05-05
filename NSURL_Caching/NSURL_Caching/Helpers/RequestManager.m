//
//  RequestManager.m
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"
#import "CustomURLProtocol.h"
#import "Repo.h"
#import "Commit.h"

#define SWIFT_LANGUAGE @"Swift"
#define BASE_URL @"https://api.github.com/"
#define REPOSITORIES_PATH @"search/repositories"
#define COMMITS_PATH @"repos/%@/%@/commits"
#define BRANCHES_PATH @"repos/%@/%@/branches"



@implementation RequestManager


AFHTTPSessionManager * manager;

+ (RequestManager *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
+ (NSString *) repositoryPath {
    return REPOSITORIES_PATH;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //settting of the custom request/response handler
        NSMutableArray * protocolsArray = [sessionConfiguration.protocolClasses mutableCopy];
        [protocolsArray insertObject:[CustomURLProtocol class] atIndex:0];
        sessionConfiguration.protocolClasses = protocolsArray;
        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    }
    return self;
}

- (void) getPopularRepositoriesForSwiftAtPage: (NSInteger) pageIndex
                                       sucess: (OperationSuccessCompletionBlock) success
                                      failure: (OperationFailureCompletionBlock) failure {
    [self getPopularRepositoriesForLanguage:SWIFT_LANGUAGE atPage:pageIndex sucess:success failure:failure];
}

- (void) getPopularRepositoriesForLanguage: (NSString*) language
                                    atPage: (NSInteger) pageIndex
                                    sucess: (OperationSuccessCompletionBlock) success
                                   failure: (OperationFailureCompletionBlock) failure {
    NSDictionary *params = @{@"q": @"language:Swift", @"page": @(pageIndex), @"per_page": REPO_PAGE_SIZE};
    [manager GET:[NSString stringWithFormat:@"%@%@", BASE_URL, REPOSITORIES_PATH] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        success(responseObject[@"items"]);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}

- (void) getCommitsForRepo: (Repo*) repository
                    sucess: (OperationSuccessCompletionBlock) success
                   failure: (OperationFailureCompletionBlock) failure {
    __block NSArray *commits;
    __block NSArray *branches;
    __block NSError *branchesError;
    __block NSError *commitsError;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    NSString *urlPath = [NSString stringWithFormat:[NSString stringWithFormat:@"%@%@", BASE_URL, COMMITS_PATH], repository.ownerName, repository.name];
    //get the latest commits
    [manager GET:urlPath parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"______________________");
        if ([responseObject isKindOfClass:[NSArray class]])
            commits = [[NSArray alloc] initWithArray:responseObject];
        dispatch_group_leave(group);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        commitsError = error;
        NSLog(@"Error: %@", error);
        dispatch_group_leave(group);
    }];
    //FYI GET /repos/:owner/:repo/commits/:commit_sha/branches-where-head wouldn't be more helpfull
    //get the names of branches
    NSString *urlPathBranches = [NSString stringWithFormat:[NSString stringWithFormat:@"%@%@", BASE_URL, BRANCHES_PATH], repository.ownerName, repository.name];
    [manager GET:urlPathBranches parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject isKindOfClass:[NSArray class]])
            branches = [[NSArray alloc] initWithArray:responseObject];
        dispatch_group_leave(group);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        branchesError = error;
        NSLog(@"Error: %@", error);
        dispatch_group_leave(group);
    }];
    
    //assigning the branches names to the commits
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (commitsError != nil) {
            failure(commitsError);
        } else {
            NSArray *result = [self getCommitsModelsWithCommitResponse:commits andBrancheResponse:branches];
            success(result);
        }
    });
}

- (NSArray*) getCommitsModelsWithCommitResponse: (NSArray *)commits andBrancheResponse: (NSArray *)branches {
    NSMutableArray *commitsModelsArray = [NSMutableArray new];
    if (commits != nil) {
        for (NSDictionary *commitItem in commits) {
            NSString *hash = @"";
            NSString *comment = @"";
            NSString *author = @"";
            NSString *authorUrl;
            NSString *parentsSha = @"";
            
            if (![commitItem[@"sha"] isKindOfClass:[NSNull class]]) {
                hash = commitItem[@"sha"];
            }
            if (![commitItem[@"commit"] isKindOfClass:[NSNull class]]) {
                if (commitItem[@"commit"][@"message"] != nil) {
                    comment = commitItem[@"commit"][@"message"];
                }
            }
            if (![commitItem[@"author"] isKindOfClass:[NSNull class]]) {
                if (![commitItem[@"author"][@"login"] isKindOfClass:[NSNull class]]) {
                    author = commitItem[@"author"][@"login"];
                }
                if (commitItem[@"author"][@"login"] != nil) {
                    authorUrl = commitItem[@"author"][@"avatar_url"];
                }
            }
            if (![commitItem[@"parents"] isKindOfClass:[NSNull class]]) {
                if (![commitItem[@"parents"][0][@"sha"] isKindOfClass:[NSNull class]]) {
                    parentsSha = commitItem[@"parents"][0][@"sha"];
                }
            }
            Commit *commitModel = [Commit new];
            commitModel.branchName = @"";
            commitModel.hash = hash;
            commitModel.comment = comment;
            commitModel.authorName = author;
            commitModel.authorAvatarUrl = authorUrl;
            commitModel.parentHash = parentsSha;
            [commitsModelsArray addObject:commitModel];
        }
    }
    if (branches != nil) {
        //find the branches' names for theirs latest commits
        for (NSDictionary *branchItem in branches) {
            if (branchItem[@"commit"] != nil) {
                NSString *latestCommitHash = branchItem[@"commit"][@"sha"];
                for (Commit *inst in commitsModelsArray) {
                    if ([inst.hash isEqualToString:latestCommitHash]) {
                        inst.branchName = branchItem[@"name"];
                        break;
                    }
                }
            }
        }
        //find the branches' names for the rest commits
        for (Commit *inst in commitsModelsArray) {
            if ([inst.branchName isEqualToString:@""]) {
                for (Commit *inst2 in commitsModelsArray) {
                    if ([inst2.branchName isEqualToString:@""])
                        continue;
                    if ([inst2.parentHash isEqualToString:inst.hash]) {
                        inst.branchName = inst2.branchName;
                        break;
                    }
                }
            }
        }
        
    }
    return commitsModelsArray;
}

@end
