//
//  CommitsVC.m
//  NSURL_Caching
//
//  Created by sdk on 5/5/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import "CommitsVC.h"
#import "CommitCell.h"
#import <SDWebImage/SDWebImage.h>

@interface CommitsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblVw;


@end

@implementation CommitsVC

@synthesize viewModel;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewModel = [[CommitsViewModel alloc] initWithView:self];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.viewModel start];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfCommits];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commitCell" forIndexPath:indexPath];
    Commit *currentItem = [self.viewModel commitForRowAtIndex:indexPath.row];
    NSString *branchName = currentItem.branchName;
    if ([branchName isEqual:@""]) {
        cell.lblBranchName.text = @"The branch was deleted.";
        cell.lblBranchName.textColor = [UIColor redColor];
    } else {
        cell.lblBranchName.text = branchName;
        cell.lblBranchName.textColor = [UIColor blackColor];
    }
    cell.lblComment.text = currentItem.comment;
    cell.lblHash.text = currentItem.hash;
    cell.lblAuthor.text = currentItem.authorName;

    if (currentItem.authorAvatarUrl != nil) {
        NSURL *imageURL = [NSURL URLWithString: currentItem.authorAvatarUrl];
        [cell.imgAuthorAvatar sd_setImageWithURL:imageURL];
    } else {
        cell.imgAuthorAvatar.image = nil;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

#pragma mark - CommitsViewModelViewDelegate

- (void) updateView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblVw reloadData];
    });
}

- (void) updateRowAtIndex: (NSInteger) index {
    
}


@end
