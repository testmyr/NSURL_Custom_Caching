//
//  CommitCell.h
//  NSURL_Caching
//
//  Created by sdk on 5/5/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblBranchName;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblHash;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UIImageView *imgAuthorAvatar;


@end

NS_ASSUME_NONNULL_END
