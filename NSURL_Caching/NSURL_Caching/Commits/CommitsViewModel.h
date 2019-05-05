//
//  CommitsViewModel.h
//  NSURL_Caching
//
//  Created by sdk on 5/5/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repo.h"
#import "Commit.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CommitsViewModelProtocol;

//adopted by View(CommitsVC)
@protocol CommitsViewModelViewDelegate <NSObject>

@property (nonatomic, strong) id<CommitsViewModelProtocol> viewModel;

- (void) updateView;
- (void) updateRowAtIndex: (NSInteger) index;

@end

//adopted by ModelView(CommitsViewModel)
@protocol CommitsViewModelProtocol <NSObject>

@property (nonatomic, strong) Repo *repository;
@property (nonatomic, weak) id<CommitsViewModelViewDelegate> delegate;
- (void)start;
- (NSInteger) numberOfCommits;
- (Commit*) commitForRowAtIndex: (NSInteger) index;

@end


@interface CommitsViewModel : NSObject<CommitsViewModelProtocol>

- (instancetype)initWithView: (id<CommitsViewModelViewDelegate>) owner;

@end

NS_ASSUME_NONNULL_END
