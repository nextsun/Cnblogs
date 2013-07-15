//
//  NewsViewController.m
//  Cnblogs
//
//  Created by Lei Sun on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsListController.h"
#import "NewsDetailController.h"
#import "NewsItemCell.h"
#import "AppDelegate.h"
#import "HTMLParser.h"




#define urlNewsBase @"http://news.cnblogs.com"
#define urlNewsBase2 @"http://news.cnblogs.com/mv?id="
#define urlNewsLatest @"http://news.cnblogs.com/n/page/%d/"
#define urlNewsRecmmend @"http://news.cnblogs.com/n/recommend?page=%d"
#define urlNewsDigg @"http://news.cnblogs.com/n/digg?page=%d"


@interface NewsListController ()

@end

@implementation NewsListController

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
    
    dataArray=[[NSMutableArray alloc] init];
    
    
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
    tableView.backgroundView=[[[UIView alloc] init] autorelease];
    tableView.backgroundColor=[UIColor clearColor];
    //tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    pageIndex=1;    
    newsUrlString=[NSString stringWithFormat:urlNewsLatest,pageIndex];
    [self.view addSubview:tableView];
   // [self appendNews];
    

    [self beginAppendNews];

    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];   
    
    

    //[tableView setNeedsLayout];
    //[tableView layoutSubviews];
    tableView.frame=CGRectMake(0, 40, self.view.bounds.size.width,self.view.bounds.size.height-60);
    [tableView reloadData];
    
    
 
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([dataArray count]==0) {
        return 0;
    }
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
    UIView* sepView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5)];
    sepView.backgroundColor=[UIColor lightGrayColor];
    [cell.contentView addSubview:sepView];
    if (indexPath.row==[dataArray count]) {
        
        
        UIButton* btnLoadMore=[UIButton  buttonWithType:UIButtonTypeRoundedRect ];
        [btnLoadMore setFrame:CGRectMake(5, 10, tableView.bounds.size.width-10, tableView_.rowHeight)];
        [btnLoadMore setTitle:@"Load More" forState:UIControlStateNormal];
        [btnLoadMore addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnLoadMore];
        
    }else {
        
        
        HTMLNode* node= [dataArray objectAtIndex:indexPath.row] ;
        
        NSString* newsName= [[[[node findChildOfClass:@"news_entry"] findChildTag:@"a"] allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
         NSString* newsSummary= [[[node findChildOfClass:@"entry_summary"] allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString* newsFooter= [[[node findChildOfClass:@"entry_footer"] allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
      
        newsFooter=[[newsFooter substringFromIndex:10] stringByReplacingOccurrencesOfString:@" " withString:@""];

        
        UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(5, 1, tableView_.bounds.size.width-45, 20)];
        [title setText:newsName];
        [title setFont:[UIFont systemFontOfSize:14]];
        [title setTextAlignment:UITextAlignmentLeft];
        title.backgroundColor=[UIColor clearColor];
        
        UILabel* summary=[[UILabel alloc] initWithFrame:CGRectMake(5, 15, tableView_.bounds.size.width-45, 40)];
        [summary setText:[@"    " stringByAppendingString:newsSummary ]];
        [summary setFont:[UIFont systemFontOfSize:8]];
        summary.numberOfLines=3;
        summary.textColor=[UIColor colorWithWhite:0.2 alpha:1];
        //summary.lineBreakMode=UILineBreakModeMiddleTruncation;
        [summary setTextAlignment:UITextAlignmentLeft];
        summary.backgroundColor=[UIColor clearColor];
        
        UILabel* footer=[[UILabel alloc] initWithFrame:CGRectMake(5, 50, tableView_.bounds.size.width-45, 15)];
        [footer setText:newsFooter];
        [footer setFont:[UIFont systemFontOfSize:8]];
        footer.textColor=[UIColor lightGrayColor];
        [footer setTextAlignment:UITextAlignmentLeft];
        footer.backgroundColor=[UIColor clearColor];
        
        [cell.contentView addSubview:title];  
        [title release];
        [cell.contentView addSubview:summary];
        [summary release];
        [cell.contentView addSubview:footer];
        [footer release];
        cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    }

    
    
    
    return [cell autorelease];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    newsType=(NewsType)itemIndex;
    [dataArray removeAllObjects];
    [tableView reloadData];
    
    [self beginAppendNews];
    
    
    if (tableView&&[tableView numberOfRowsInSection:0]>0) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
}


-(NSString*)urlForNewsType
{
    
    NSString* str=urlNewsBase;
    
    switch (newsType) {
        case NewsTypeLastes:
        {    
            str=[NSString stringWithFormat:urlNewsLatest,pageIndex];
            break;
        }
        case NewsTypeRecommemd:
        {    
            str=[NSString stringWithFormat:urlNewsRecmmend,pageIndex];
            break;
        } 
        case NewsTypeDigg:
        {    
            str=[NSString stringWithFormat:urlNewsDigg,pageIndex];
            break;
        } 
        default:
            str=[NSString stringWithFormat:urlNewsLatest,pageIndex];
            break;
    }
    return str;
    
}
-(void)beginAppendNews
{
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
    }    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = (id<MBProgressHUDDelegate>)self;
	[self.view addSubview:HUD];
    
     newsUrlString=[self urlForNewsType];
    [HUD showWhileExecuting:@selector(appendNews) onTarget:self withObject:nil animated:YES];
}
-(void)appendNews
{    
    request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:newsUrlString]];    
    request.delegate=(id<ASIHTTPRequestDelegate>)self;
    [request startSynchronous];
}
-(void)loadMore:(UIButton*)btn
{
    pageIndex++;     
    [self beginAppendNews];
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"%@",responseHeaders);
}
- (void)requestFinished:(ASIHTTPRequest *)request_
{
    NSLog(@"%@",request_.responseString); 
     paraser=[[HTMLParser alloc] initWithString:request_.responseString error:nil];       
    NSArray* contentArray= [paraser.body findChildrenOfClass:@"content"] ;
    //[paraser release];
    for (HTMLNode* node in contentArray) {   
        [dataArray addObject:node];
    };
    //[paraser release];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tableView animated:YES];
    
    hud.mode = MBProgressHUDModeText;
	hud.labelText = @"   网络连接异常   ";
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;	
	[hud hide:YES afterDelay:2];

    //[tableView removeFromSuperview];
}

// When a delegate implements this method, it is expected to process all incoming data itself
// This means that responseData / responseString / downloadDestinationPath etc are ignored
// You can have the request call a different method by setting didReceiveDataSelector


- (void)hudWasHidden:(MBProgressHUD *)hud {
    [tableView reloadData];
    if (pageIndex==1) {
        [tableView reloadSections:[[[NSIndexSet alloc] initWithIndex:0] autorelease] withRowAnimation:UITableViewRowAnimationFade];        
    }
}
- (void)dealloc
{
    [paraser release];
    [super dealloc];
}
@end
