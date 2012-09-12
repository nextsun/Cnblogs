//
//  NewsViewController.m
//  Cnblogs
//
//  Created by Lei Sun on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "HTMLParser.h"
#import "NewsDetailController.h"
#import "NewsItemCell.h"
#import "AppDelegate.h"

#define urlNewsBase @"http://news.cnblogs.com"
#define urlNewsBase2 @"http://news.cnblogs.com/mv?id="
#define urlNewsLatest @"http://news.cnblogs.com/n/page/%d/"
#define urlNewsRecmmend @"http://news.cnblogs.com/n/recommend?page=%d"
#define urlNewsDigg @"http://news.cnblogs.com/n/digg?page=%d"


@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view. 
    
    
}

-(void)loadView
{
    [super loadView];    
    self.view.frame=self.view.bounds;
    [self addStandardTabView];
    
    
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width,self.view.bounds.size.height-60) style:UITableViewStylePlain];
    tableView.dataSource=(id<UITableViewDataSource>)self;
    tableView.delegate=(id<UITableViewDelegate>)self;
    //tableView.contentInset=UIEdgeInsetsMake(0, 5, 0, 5); 
    //tableView.backgroundView=[[[UIView alloc] init] autorelease];
    //tableView.backgroundColor=[UIColor clearColor];
    
    
    
    
    //[self reloadNews];
    
    [self.view addSubview:tableView];
    pageIndex=1;    
    newsUrlString=[NSString stringWithFormat:urlNewsLatest,pageIndex];
    [self reloadNews];
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
   
    tableView.frame=CGRectMake(0, 40, self.view.bounds.size.width,self.view.bounds.size.height-60);
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated]; 
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"aaaaaaaa");
    return [dataArray count]+1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    HTMLNode* node= [dataArray objectAtIndex:indexPath.row];
    NSString* newID=[[[[node findChildTag:@"a"] getAttributeNamed:@"href"]stringByReplacingOccurrencesOfString:@"/n/" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""];

    
    NewsDetailController* detail=[[NewsDetailController alloc] initWithUrlString:[urlNewsBase2 stringByAppendingString:newID]];  
    
    
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController pushViewController:detail animated:YES];
    [detail release];
    
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    UITableViewCell* cell=[[UITableViewCell alloc] init] ;
    
    //UITextView* text=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    //[text setText:[dataArray objectAtIndex:indexPath.row]];
    
    
    // NSString* newID=[[node findChildTag:@"a"] getAttributeNamed:@"href"];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    if (indexPath.row==[dataArray count]) {
        
        
        UIButton* btnLoadMore=[UIButton  buttonWithType:UIButtonTypeRoundedRect ];
        [btnLoadMore setFrame:CGRectMake(5, 0, tableView.bounds.size.width-10, tableView_.rowHeight)];
        [btnLoadMore setTitle:@"Load More" forState:UIControlStateNormal];
        [btnLoadMore addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnLoadMore];
        
    }else {
        
        
        HTMLNode* node= [dataArray objectAtIndex:indexPath.row];
        
        NSString* newName= [[[node findChildTag:@"a"] allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        
        UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView_.bounds.size.width-20, 20)];
        [title setText:newName];
        [title setTextAlignment:UITextAlignmentLeft];
        title.backgroundColor=[UIColor clearColor];
        
        [cell.contentView addSubview:title];
        cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    }

    
    
    
    return [cell autorelease];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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


-(void)addStandardTabView;
{
    JMTabView * tabView = [[[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)] autorelease];
    
    [tabView setDelegate:self];    
    [tabView addTabItemWithTitle:@"时间" icon:[UIImage imageNamed:@"icon1.png"]];
    [tabView addTabItemWithTitle:@"推荐" icon:[UIImage imageNamed:@"icon2.png"]];
    [tabView addTabItemWithTitle:@"热门" icon:[UIImage imageNamed:@"icon3.png"]];    
    [tabView setSelectedIndex:0];
    
    [self.view addSubview:tabView];
}
-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex
{
    pageIndex=1;
    switch (itemIndex) {
        case 0:
        {    
            newsUrlString=[NSString stringWithFormat:urlNewsLatest,pageIndex];
            break;
        }
        case 1:
        {    
            newsUrlString=[NSString stringWithFormat:urlNewsRecmmend,pageIndex];
            break;
        } 
        case 2:
        {    
            newsUrlString=[NSString stringWithFormat:urlNewsDigg,pageIndex];
            break;
        } 
        default:
            break;
    }
    [self reloadNews];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

-(void)reloadNews
{
    
    NSString* htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString:newsUrlString] encoding:NSUTF8StringEncoding error:nil] ;    
    HTMLParser* paraser=[[HTMLParser alloc] initWithString:htmlString error:nil];   
    
    NSArray* contentArray= [paraser.body findChildrenOfClass:@"content"];
    
    if (!dataArray) {
        dataArray=[[NSMutableArray alloc] initWithCapacity:[contentArray count]];
    } 
    [dataArray removeAllObjects];
    
    for (HTMLNode* node in contentArray) {   
         [dataArray addObject:[node findChildOfClass:@"news_entry"]];  
    };
    [tableView reloadData];
    
}
-(void)loadMore:(UIButton*)btn
{
    pageIndex++;
    newsUrlString=[NSString stringWithFormat:urlNewsLatest,pageIndex];
    [self appendNews];
    
}
-(void)appendNews
{
    NSLog(@"%@",newsUrlString);
    NSString* htmlString=[NSString stringWithContentsOfURL:[NSURL URLWithString:newsUrlString] encoding:NSUTF8StringEncoding error:nil] ;    
    HTMLParser* paraser=[[HTMLParser alloc] initWithString:htmlString error:nil];   
    
    NSArray* contentArray= [paraser.body findChildrenOfClass:@"content"];
    
//    if (!dataArray) {
//        dataArray=[[NSMutableArray alloc] initWithCapacity:[contentArray count]];
//    } 
//    [dataArray removeAllObjects];
    
    for (HTMLNode* node in contentArray) {   
        [dataArray addObject:[node findChildOfClass:@"news_entry"]];   
        //NSLog(@"%@",[node rawContents]);
    };
    [tableView reloadData];
    
}
@end
