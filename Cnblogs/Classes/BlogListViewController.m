//
//  BlogListViewController.m
//  Cnblogs
//
//  Created by Lei Sun on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlogListViewController.h"
#import "HTMLParser.h"


#define urlBlogBase @"http://www.cnblogs.com"
#define urlBlogBase2 @"http://www.cnblogs.com/mv?id="
#define urlBlogHome @"http://m.cnblogs.com/mobile.aspx?page=%d"
#define urlBlogPick @"http://m.cnblogs.com/mobile.aspx?page=%d"
#define urlBlogCandidate @"http://m.cnblogs.com/mobile.aspx?page=%d"


@implementation BlogListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)addStandardTabView;
{
    JMTabView * tabView = [[[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)] autorelease];    
    //[tabView setDelegate:self];    
    [tabView addTabItemWithTitle:@"首页" icon:[UIImage imageNamed:@"icon1.png"]];
    [tabView addTabItemWithTitle:@"精华" icon:[UIImage imageNamed:@"icon2.png"]];
    [tabView addTabItemWithTitle:@"候选" icon:[UIImage imageNamed:@"icon3.png"]];    
    [tabView setSelectedIndex:0];
    
    [self.view addSubview:tabView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataArray=[[NSMutableArray alloc] init];
    
    self.view.frame=self.view.bounds;
    [self addStandardTabView];
    
    
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width,self.view.bounds.size.height-60) style:UITableViewStylePlain];
    tableView.dataSource=(id<UITableViewDataSource>)self;
    tableView.delegate=(id<UITableViewDelegate>)self;
    //tableView.contentInset=UIEdgeInsetsMake(0, 5, 0, 5); 
    //tableView.backgroundView=[[[UIView alloc] init] autorelease];
    tableView.backgroundColor=[UIColor clearColor];
    
        
    [self.view addSubview:tableView];
    // [self appendNews];
    
    pageIndex=1;
    [self beginAppendData];
}
-(void)beginAppendData
{
    
    if (HUD) {
        [HUD removeFromSuperview];
        [HUD release];
    }    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = (id<MBProgressHUDDelegate>)self;
	[self.view addSubview:HUD];
    
    blogUrlString=[self urlForBlogType];
    [HUD showWhileExecuting:@selector(appendData) onTarget:self withObject:nil animated:YES];
}
-(void)appendData
{    
    request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:blogUrlString]];    
    request.delegate=(id<ASIHTTPRequestDelegate>)self;
    [request startSynchronous];
}
-(NSString*)urlForBlogType
{
    
    NSString* str=urlBlogBase;
    
    switch (blogType) {
        case BlogTypeHome:
        {    
            str=[NSString stringWithFormat:urlBlogHome,pageIndex];
            break;
        }
        case BlogTypePick:
        {    
            str=[NSString stringWithFormat:urlBlogPick,pageIndex];
            break;
        } 
        case BlogTypeCandidate:
        {    
            str=[NSString stringWithFormat:urlBlogCandidate,pageIndex];
            break;
        } 
        default:
            str=[NSString stringWithFormat:urlBlogHome,pageIndex];
            break;
    }
    return str;
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];       
    tableView.frame=CGRectMake(0, 40, self.view.bounds.size.width,self.view.bounds.size.height-60);
    [tableView reloadData];
    
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
-(void)loadMore:(UIButton*)btn
{
    pageIndex++;     
    [self beginAppendData];
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"%@",responseHeaders);
}
- (void)requestFinished:(ASIHTTPRequest *)request_
{
    NSLog(@"%@",request_.responseString); 
    paraser=[[HTMLParser alloc] initWithString:request_.responseString error:nil];       
    NSArray* contentArray= [paraser.body findChildrenOfClass:@"list_item"] ;
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







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([dataArray count]==0) {
        return 0;
    }
    return [dataArray count]+1;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
 //   HTMLNode* node= [dataArray objectAtIndex:indexPath.row];
//    NSString* newID=[[[[node findChildTag:@"a"] getAttributeNamed:@"href"]stringByReplacingOccurrencesOfString:@"/n/" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    
//    NewsDetailController* detail=[[NewsDetailController alloc] initWithUrlString:[urlNewsBase2 stringByAppendingString:newID]];  
//    
//    
//    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    [app.navigationController pushViewController:detail animated:YES];
//    [detail release];
    
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
        [btnLoadMore setFrame:CGRectMake(5, 10, tableView.bounds.size.width-10, tableView_.rowHeight)];
        [btnLoadMore setTitle:@"Load More" forState:UIControlStateNormal];
        [btnLoadMore addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnLoadMore];
        
    }else {
        
        
        HTMLNode* node= [dataArray objectAtIndex:indexPath.row] ;
        NSLog(@"%@",[node allContents]);
        
        NSString* newsName= [[[node findChildTag:@"a"] allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //NSString* newsSummary= [[[node findChildOfClass:@"entry_summary"] allContents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString* newsFooter= [[[[node findChildTag:@"a"] nextSibling ] allContents ] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        //newsFooter=[[newsFooter substringFromIndex:10] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView_.bounds.size.width-45, 20)];
        [title setText:newsName];
        [title setFont:[UIFont systemFontOfSize:14]];
        [title setTextAlignment:UITextAlignmentLeft];
        title.backgroundColor=[UIColor clearColor];
        
//        UILabel* summary=[[UILabel alloc] initWithFrame:CGRectMake(5, 15, tableView_.bounds.size.width-45, 40)];
//        [summary setText:[@"    " stringByAppendingString:newsSummary ]];
//        [summary setFont:[UIFont systemFontOfSize:8]];
//        summary.numberOfLines=3;
//        summary.textColor=[UIColor colorWithWhite:0.2 alpha:1];
//        //summary.lineBreakMode=UILineBreakModeMiddleTruncation;
//        [summary setTextAlignment:UITextAlignmentLeft];
//        summary.backgroundColor=[UIColor clearColor];
        
        UILabel* footer=[[UILabel alloc] initWithFrame:CGRectMake(5, 50, tableView_.bounds.size.width-45, 15)];
        [footer setText:newsFooter];
        [footer setFont:[UIFont systemFontOfSize:8]];
        footer.textColor=[UIColor lightGrayColor];
        [footer setTextAlignment:UITextAlignmentLeft];
        footer.backgroundColor=[UIColor clearColor];
        
        [cell.contentView addSubview:title];  
        [title release];
//        [cell.contentView addSubview:summary];
//        [summary release];
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





- (void)dealloc
{
    [paraser release];
    [super dealloc];
}
@end
