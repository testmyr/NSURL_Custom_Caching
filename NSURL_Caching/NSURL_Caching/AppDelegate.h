//
//  AppDelegate.h
//  NSURL_Caching
//
//  Created by sdk on 5/2/19.
//  Copyright © 2019 Sdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

