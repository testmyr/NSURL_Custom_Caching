//
//  CoreDataHelper.m
//  NSURL_Caching
//
//  Created by sdk on 5/4/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "RequestManager.h"

@implementation CoreDataHelper

+ (GitHubResponse *)cachedResponseForUrl: (NSString*) urlPath {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GitHubResponse" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", urlPath];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (result && result.count > 0) {
        return result[0];
    }
    return nil;
}

+ (void)addResponseEnityBasedOn: (NSURLResponse*) response data: (NSData*) data andUrlPath: (NSString*) urlPath {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    GitHubResponse *cachedResponse = [NSEntityDescription insertNewObjectForEntityForName:@"GitHubResponse" inManagedObjectContext:context];
    cachedResponse.url = urlPath;
    if ([urlPath containsString:[RequestManager repositoryPath]]) {
        cachedResponse.cleanableManually = YES;
    }
    cachedResponse.data = data;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSMutableDictionary *headers = [httpResponse.allHeaderFields mutableCopy];
    cachedResponse.etag = headers[@"Etag"];
    
    NSString *dateStr = headers[@"Date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    //will be used in the future to prevent too often saving data in case they are requested every time
    cachedResponse.timestamp = date;
    
    cachedResponse.mimeType = response.MIMEType;
    cachedResponse.encoding = response.textEncodingName;
    NSError *error;
    BOOL const success = [context save:&error];
    if (!success) {
        NSLog(@"Could not cache the response.");
    }
}

+ (void) cleanCleanable {
    //FYI cleanableManually could be changed into Int and array of cleanable group(template) of path urls could be mapped into that Int value(which would be a R-tree in core data)
    //thus every urlPath group could be cleaned separately
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cleanableManually == YES"];
    NSFetchRequest *fetchRequest = [GitHubResponse fetchRequest];
    [fetchRequest setPredicate:predicate];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    deleteRequest.resultType = NSBatchDeleteResultTypeCount;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSError *error = nil;
    NSBatchDeleteResult *deletedResult = [context executeRequest:deleteRequest error:&error];
    if (error) {
        NSLog(@"Unable to delete the data");
    }
    else {
        NSLog(@"%@ deleted", deletedResult.result);
    }
}

@end
