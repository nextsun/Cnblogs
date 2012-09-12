//
//  RootTabViewController.m
//  Cnblogs
//
//  Created by Lei Sun on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootTabViewController.h"
#import "CustomTabItem.h"
#import "CustomSelectionView.h"
#import "CustomBackgroundLayer.h"
#import "CustomNoiseBackgroundView.h"
#import "UIView+Positioning.h"
#import "FirstViewController.h"



#define fTabViewBottom 101

@interface RootTabViewController()
-(UIView*)createStandardTabView;
-(void)addCustomTabView;
@end

@implementation RootTabViewController


-(UIView*)createStandardTabView;
{
    JMTabView * tabView = [[[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60.)] autorelease];
    
    [tabView setDelegate:self];
    // tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [tabView addTabItemWithTitle:@"首页" icon:[UIImage imageNamed:@"icon1.png"]];
    [tabView addTabItemWithTitle:@"Two" icon:[UIImage imageNamed:@"icon2.png"]];
    [tabView addTabItemWithTitle:@"Three" icon:[UIImage imageNamed:@"icon3.png"]];
    
    //    You can run blocks by specifiying an executeBlock: paremeter
    //    #if NS_BLOCKS_AVAILABLE
    //    [tabView addTabItemWithTitle:@"One" icon:nil executeBlock:^{NSLog(@"abc");}];
    //    #endif
    
    [tabView setSelectedIndex:0];
    
    //[self.view addSubview:tabView];
    return tabView ;
}

-(void)addCustomTabView;
{
    JMTabView * tabView = [[[JMTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60., self.view.bounds.size.width, 60.)] autorelease];
    tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    tabView.tag=fTabViewBottom;
    
    [tabView setDelegate:self];
    
    UIImage * standardIcon = [UIImage imageNamed:@"icon3.png"];
    UIImage * highlightedIcon = [UIImage imageNamed:@"icon2.png"];
    
    CustomTabItem * tabItem1 = [CustomTabItem tabItemWithTitle:@"博客" icon:standardIcon alternateIcon:highlightedIcon];
    CustomTabItem * tabItem2 = [CustomTabItem tabItemWithTitle:@"新闻" icon:standardIcon alternateIcon:highlightedIcon];
    CustomTabItem * tabItem3 = [CustomTabItem tabItemWithTitle:@"搜索" icon:standardIcon alternateIcon:highlightedIcon];
    CustomTabItem * tabItem4 = [CustomTabItem tabItemWithTitle:@"配置" icon:standardIcon alternateIcon:highlightedIcon];
    CustomTabItem * tabItem5 = [CustomTabItem tabItemWithTitle:@"更多" icon:standardIcon alternateIcon:highlightedIcon];
    
    [tabView addTabItem:tabItem1];
    [tabView addTabItem:tabItem2];
    [tabView addTabItem:tabItem3];
    [tabView addTabItem:tabItem4];
    [tabView addTabItem:tabItem5];
    
    [tabView setSelectionView:[CustomSelectionView createSelectionView]];
    [tabView setItemSpacing:1.];
    [tabView setBackgroundLayer:[[[CustomBackgroundLayer alloc] init] autorelease]];
    
    [tabView setSelectedIndex:0];
    
    [self.view addSubview:tabView];
    
    
}

-(void)loadView;
{
    CustomNoiseBackgroundView * noiseBackgroundView = [[[CustomNoiseBackgroundView alloc] init] autorelease];
    self.view = noiseBackgroundView;
    contentView=[[UIView alloc] init];         
    [self.view addSubview:contentView];
    
    topTabView=(JMTabView*)[self  createStandardTabView];
    //[self.view addSubview:topTabView];  
    
   
    
    
    [self addCustomTabView];
    
    
    
    
}
-(void)viewDidLoad
{
    
    [super viewDidLoad];
}

-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
     NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    contentView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-40+10);
    
    for (UIView* v in contentView.subviews) {
        [v removeFromSuperview];
    }     
    news=[[NewsViewController alloc] init];
    news.view.frame=contentView.bounds;
    [contentView addSubview:news.view];
    
   
}
-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex;
{
    NSLog(@"Selected Tab Index: %d", itemIndex);
    
    if (tabView.tag==fTabViewBottom) {
        
        
        for (UIView* v in contentView.subviews) {
            [v removeFromSuperview];
        } 
        
        switch (itemIndex) {
            case 0:
            {
                news=[[NewsViewController alloc] init]; 
                news.view.frame=contentView.bounds;
                [contentView addSubview:news.view];
                break;
            }  
            case 1:
            {
                
                news=[[NewsViewController alloc] init]; 
                news.view.frame=contentView.bounds;
                [contentView addSubview:news.view];
                break;
            }
            case 2:
            {
                
                news=[[NewsViewController alloc] init]; 
                news.view.frame=contentView.bounds;
                [contentView addSubview:news.view];
                break;            }
            case 3:
            {
                
                news=[[NewsViewController alloc] init]; 
                news.view.frame=contentView.bounds;
                [contentView addSubview:news.view];
                break;            }
            case 4:
            {
                NewsViewController* sec=[[[NewsViewController alloc] init]autorelease];  
                [contentView addSubview:sec.view];
                news.view.frame=contentView.bounds;
                break;
            }
            default:
                break;
        }
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}
- (void)dealloc
{
    if (news) {
        [news release];
        news=nil;
    }
    [super dealloc];
}
@end
