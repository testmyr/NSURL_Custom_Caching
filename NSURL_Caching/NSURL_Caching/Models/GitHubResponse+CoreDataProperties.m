//
//  GitHubResponse+CoreDataProperties.m
//  
//
//  Created by sdk on 5/4/19.
//
//

#import "GitHubResponse+CoreDataProperties.h"

@implementation GitHubResponse (CoreDataProperties)

+ (NSFetchRequest<GitHubResponse *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"GitHubResponse"];
}

@dynamic data;
@dynamic mimeType;
@dynamic timestamp;
@dynamic url;
@dynamic encoding;
@dynamic etag;

@end
