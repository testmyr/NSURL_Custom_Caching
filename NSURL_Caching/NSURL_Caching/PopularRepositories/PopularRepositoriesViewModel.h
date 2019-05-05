//
//  PopularRepositoriesViewModel.h
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PopularRepositoriesViewModelProtocol;

//adopted by View(PopularRepositoriesVC)
@protocol PopularRepositoriesViewModelViewDelegate <NSObject>

@property (nonatomic, strong) id<PopularRepositoriesViewModelProtocol> viewModel;

- (void) updateView;
- (void) updateRowAtIndex: (NSInteger) index;

@end

//adopted by ModelView(PopularRepositoriesViewModel)
@protocol PopularRepositoriesViewModelProtocol <NSObject>

@property (nonatomic, weak) id<PopularRepositoriesViewModelViewDelegate> delegate;
- (void)start;
- (NSInteger) numberOfRepositories;
- (Repo*) repoForRowAtIndex: (NSInteger) index;
- (void) loadNextPage;
- (void) cleanReposCache;
- (void) didSelectItemAt: (NSInteger) index;

@end


@interface PopularRepositoriesViewModel : NSObject<PopularRepositoriesViewModelProtocol>

- (instancetype)initWithView: (id<PopularRepositoriesViewModelViewDelegate>) owner;

@end

NS_ASSUME_NONNULL_END
