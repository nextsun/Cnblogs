//
//  RootTabViewController.m
//  Cnblogs
//
//  Created by Lei Sun on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMTabView/JMTabView.h>
#import "NewsListController.h"
#import "BlogListViewController.h"

@interface RootTabViewController : UIViewController <JMTabViewDelegate>
{
    
    UIView* contentView;
    NewsListController* news;
    BlogListViewController* blogs;
    UIViewController* currentControlle;
    JMTabView* topTabView;
}
@end
