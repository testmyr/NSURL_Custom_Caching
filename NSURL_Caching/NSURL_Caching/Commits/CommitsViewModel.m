//
//  CommitsViewModel.m
//  NSURL_Caching
//
//  Created by sdk on 5/5/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import "CommitsViewModel.h"
#import "RequestManager.h"
#import "CoreDataHelper.h"

@interface CommitsViewModel()

@property (strong, nonatomic) NSMutableArray *commits;

@end

@implementation CommitsViewModel

@synthesize repository, delegate, commits;


- (instancetype)initWithView: (id<CommitsViewModelViewDelegate>) owner
{
    self = [super init];
    if (self) {
        self.delegate = owner;
    }
    return self;
}

- (void)start {
    commits = [NSMutableArray new];
    
    [[RequestManager sharedInstance] getCommitsForRepo:repository
                                                sucess:^(id result){
                                                    if (result != nil) {
                                                        NSArray *recivedItems = (NSArray*) result;
                                                        if (recivedItems != nil) {
                                                            [self->commits addObjectsFromArray:recivedItems];
                                                            [self.delegate updateView];
                                                        }
                                                    }
                                                }
                                               failure:^(NSError *result){
                                                   
                                               }];
}

//pragma mark: - CommitsViewModelProtocol

- (NSInteger) numberOfCommits {
    return commits.count;
}

- (Commit*) commitForRowAtIndex: (NSInteger) index {
    return commits[index];
}

@end
