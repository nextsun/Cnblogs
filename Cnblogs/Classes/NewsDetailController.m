//
//  NewsDetailController.m
//  Cnblogs
//
//  Created by Lei Sun on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailController.h"
#import "CustomNoiseBackgroundView.h"



@implementation NewsDetailController
-(id)initWithUrlString:(NSString*)string
{
    
    self=[super init];
    if (self) {
        newsUrl=[string retain];
    }
    return self;
}

-(void)addStandardTabView;
{
    JMTabView * tabView = [[[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)] autorelease];
    
    //[tabView setDelegate:(id<JMTabViewDelegate>)self];    
    [ tabView addTabItemWithTitle:@"返回" icon:[UIImage imageNamed:@"icon1.png"] executeBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [tabView addTabItemWithTitle:@"评论" icon:[UIImage imageNamed:@"icon2.png"]];
    [tabView setSelectedIndex:0];
    
    [self.view addSubview:tabView];
    //return tabView ;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)loadView
{
    [super loadView];
    
    CustomNoiseBackgroundView * noiseBackgroundView = [[[CustomNoiseBackgroundView alloc] init] autorelease];
    noiseBackgroundView.frame=self.view.bounds;
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    [self.view addSubview:noiseBackgroundView];    
    [self addStandardTabView];
    
    webView=[[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    webView.backgroundColor=[UIColor clearColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newsUrl]]];
    
    
    
    
}
-(void)viewDidLayoutSubviews
{    
    [super viewDidLayoutSubviews];
    CGRect rect=CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40);
    webView.frame=rect;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
