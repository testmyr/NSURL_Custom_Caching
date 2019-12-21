//
//  PopularRepositoriesVC.m
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import "PopularRepositoriesVC.h"
#import "PopularRepositoriesViewModel.h"
#import "PopularRepoCell.h"
#import <SDWebImage/SDWebImage.h>
#import "CommitsVC.h"

@interface PopularRepositoriesVC () <UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching, PopularRepositoriesViewModelViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblVw;


@end

@implementation PopularRepositoriesVC

@synthesize viewModel;

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.viewModel = [[PopularRepositoriesViewModel alloc] initWithView:self];
    [self.viewModel start];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tblVw addSubview:refreshControl];
    self.tblVw.prefetchDataSource = self;
}
- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self.viewModel cleanReposCache];
    [refreshControl endRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRepositories];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopularRepoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popularRepoCell" forIndexPath:indexPath];
    Repo *currentItem = [self.viewModel repoForRowAtIndex:indexPath.row];
    cell.lblRepoName.text = currentItem.name;
    cell.lblRepoDescr.text = currentItem.descr;
    cell.lblOwnerName.text = currentItem.ownerName;
    
    if (currentItem.ownerAvatarUrl != nil) {
        NSURL *imageURL = [NSURL URLWithString: currentItem.ownerAvatarUrl];
        [cell.imgOwner sd_setImageWithURL:imageURL];
    } else {
        cell.imgOwner.image = nil;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    CommitsVC * vc = [storyboard instantiateViewControllerWithIdentifier:@"CommitsVC"];
    vc.viewModel.repository = [self.viewModel repoForRowAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.tblVw.frame.size.width;
    CGFloat hight = self.tblVw.frame.size.height;
    CGFloat cellHeight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (width > hight) {
            cellHeight = 80;
        } else {
            cellHeight = 100;
        }
    } else {
        cellHeight = 120;//TODO
    }
    return cellHeight;
}


#pragma mark - UITableViewDataSourcePrefetching

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSInteger latestRowNumber = [self.viewModel numberOfRepositories] - 1;
    for (int i = 0; i < indexPaths.count; ++i) {
        if(indexPaths[i].row == latestRowNumber) {
            [self.viewModel loadNextPage];
        }
    }
}

#pragma mark - PopularRepositoriesViewModelViewDelegate

- (void) updateView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblVw reloadData];
    });
}

- (void) insertRowAtIndex: (NSInteger) index {
    
}

- (void) updateRowAtIndex: (NSInteger) index {
    
}


@end
