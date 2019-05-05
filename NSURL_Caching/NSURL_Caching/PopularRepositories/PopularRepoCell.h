//
//  PopularRepoCell.h
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopularRepoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblRepoName;
@property (weak, nonatomic) IBOutlet UILabel *lblRepoDescr;
@property (weak, nonatomic) IBOutlet UILabel *lblOwnerName;
@property (weak, nonatomic) IBOutlet UIImageView *imgOwner;

@end

NS_ASSUME_NONNULL_END
