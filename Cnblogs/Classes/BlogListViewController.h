//
//  BlogListViewController.h
//  Cnblogs
//
//  Created by Lei Sun on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMTabView/JMTabView.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@class HTMLParser;

typedef enum 
{
    BlogTypeHome=0,
    BlogTypePick=1,
    BlogTypeCandidate=2
}BlogType;
@interface BlogListViewController : UIViewController
{
    
    UITableView* tableView;
    NSMutableArray* dataArray;
    NSMutableArray* dataArrayRecommemd;
    NSMutableArray* dataArrayDigg;
    NSString* blogUrlString;
    int pageIndex;
    BlogType blogType;
    MBProgressHUD* HUD;
    ASIHTTPRequest* request;
    HTMLParser* paraser;
}

@end
