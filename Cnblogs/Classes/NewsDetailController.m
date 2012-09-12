//
//  NewsDetailController.m
//  Cnblogs
//
//  Created by Lei Sun on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailController.h"
#import "CustomNoiseBackgroundView.h"

@interface NewsDetailController ()

@end

@implementation NewsDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUrlString:(NSString*)string
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
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    CustomNoiseBackgroundView * noiseBackgroundView = [[[CustomNoiseBackgroundView alloc] init] autorelease];
    noiseBackgroundView.frame=self.view.bounds;
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    [self.view addSubview:noiseBackgroundView];
    
    [self addStandardTabView];
    
    CGRect rect=CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40);
    UIWebView* web=[[UIWebView alloc] initWithFrame:rect];
    [self.view addSubview:web];
    web.backgroundColor=[UIColor clearColor];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newsUrl]]];
    
}
-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
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
