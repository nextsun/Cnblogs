//
//  NewsViewController.h
//  Cnblogs
//
//  Created by Lei Sun on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMTabView/JMTabView.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
//#import "HTMLParser.h"

@class HTMLParser;
typedef enum 
{
    NewsTypeLastes=0,
    NewsTypeRecommemd=1,
    NewsTypeDigg=2
}NewsType;

@interface NewsListController : UIViewController<JMTabViewDelegate,ASIHTTPRequestDelegate>
{
    UITableView* tableView;
    NSMutableArray* dataArray;
    NSMutableArray* dataArrayRecommemd;
    NSMutableArray* dataArrayDigg;
    NSString* newsUrlString;
    int pageIndex;
    NewsType newsType;
    MBProgressHUD* HUD;
    ASIHTTPRequest* request;
    HTMLParser* paraser;
    
}
@end
