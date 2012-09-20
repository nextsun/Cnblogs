//
//  NewsDetailController.h
//  Cnblogs
//
//  Created by Lei Sun on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMTabView/JMTabView.h>

@interface NewsDetailController : UIViewController{
    NSString* newsUrl;
    UIWebView* webView;
}
- (id)initWithUrlString:(NSString*)string;
@end
