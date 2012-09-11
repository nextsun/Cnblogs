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
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CustomNoiseBackgroundView * noiseBackgroundView = [[[CustomNoiseBackgroundView alloc] init] autorelease];
    self.view = noiseBackgroundView;
    self.view.frame=CGRectMake(0, 0, 320, 480-60);
    UIWebView* web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [self.view addSubview:web];
    web.backgroundColor=[UIColor clearColor];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newsUrl]]];
    NSLog(@"%@",newsUrl);
    web.opaque=NO;
    //[web setUserInteractionEnabled:NO];
    
    
    //    UIView* maskView=[[UIView alloc] initWithFrame:CGRectMake(0, 10+30, 150, 300-30)];
    //    [self.view addSubview:maskView];

   
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
