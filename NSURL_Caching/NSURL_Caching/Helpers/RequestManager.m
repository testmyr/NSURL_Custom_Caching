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
        NSLog(@"JSON: %@", responseObject);
        success(responseObject[@"items"]);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
}

- (void) getCommitsForRepo: (Repo*) repository {
    NSString *urlPath = [NSString stringWithFormat:[NSString stringWithFormat:@"%@%@", BASE_URL, COMMITS_PATH], repository.ownerName, repository.name];
    [manager GET:urlPath parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"______________________");
        [self getBranchesForRepo:repository];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) getBranchesForRepo: (Repo*) repository {
    NSString *urlPath = [NSString stringWithFormat:[NSString stringWithFormat:@"%@%@", BASE_URL, BRANCHES_PATH], repository.ownerName, repository.name];
    [manager GET:urlPath parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
