//
//  GitHubResponse+CoreDataProperties.h
//  
//
//  Created by sdk on 5/4/19.
//
//

#import "GitHubResponse+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GitHubResponse (CoreDataProperties)

+ (NSFetchRequest<GitHubResponse *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, copy) NSString *mimeType;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *encoding;
@property (nullable, nonatomic, copy) NSString *etag;

@end

NS_ASSUME_NONNULL_END
