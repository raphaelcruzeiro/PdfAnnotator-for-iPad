//
//  PDFPagingViewController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/10/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import "PDFPagingViewController.h"
#import "PDFDocument.h"
#import "PDFThumbnailFactory.h"

@implementation PDFPagingViewController

@synthesize delegate;
@synthesize _document;
@synthesize thumbFactory;
@synthesize collapseButton;

- (id)initWithDocument:(PDFDocument *)document AndObserver:(id<PDFPagingViewProtocol>)observer
{
    if(self = [super init]){
        self.delegate = observer;
        expanded = false;
        self._document = document;
        self.thumbFactory = [[PDFThumbnailFactory alloc] initWithDocument:self._document];
        thumbs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    expandedFrame = CGRectMake(0, 754, 768, 270);
    collapsedFrame = CGRectMake(0, 946, 768, 270);
    
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    // self.view.alpha = 0.2;
    self.view.frame = collapsedFrame;
    
    collapseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [collapseButton setTitle:@"ˆ" forState:UIControlStateNormal];
    [collapseButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchDown];
    
    [collapseButton setFrame:CGRectMake(25, 10, 40, 20)];
    [collapseButton setAlpha:0.2];
    [self.view addSubview:collapseButton];
    
    CGFloat startingX = 10;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 768, 170)];
    scrollView.contentSize = CGSizeMake([self._document pageCount] * 130, 170);
    
    for(NSInteger i = 1 ; i <= [self._document pageCount] && i; i++) {
        
        if(i > 10) {
            UIButton * thumbButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [thumbButton setBackgroundColor:[UIColor whiteColor]];
            [thumbButton setImage:[UIImage imageNamed:@"progressIndicator_roller.gif"] forState:UIControlStateNormal];
            [thumbButton setTag:i];
            
            [thumbButton addTarget:self action:@selector(pageItemClicked:) forControlEvents:UIControlEventTouchDown];
            
            [thumbButton setFrame:CGRectMake(startingX, 0, 120, 160)];
            
            [scrollView addSubview:thumbButton];
            
            startingX += 130;
            
            continue;
        }
        
        UIImage * thumb = [thumbFactory generateThumbnailForPage:i withSize:(CGSize){120, 160}];
        
        [thumbs addObject:thumb];
        
        UIButton * thumbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [thumbButton setBackgroundColor:[UIColor whiteColor]];
        [thumbButton setImage:thumb forState:UIControlStateNormal];
        [thumbButton setTag:i];
        
        [thumbButton addTarget:self action:@selector(pageItemClicked:) forControlEvents:UIControlEventTouchDown];
        
        [thumbButton setFrame:CGRectMake(startingX, 0, thumb.size.width, thumb.size.height)];
        
        [scrollView addSubview:thumbButton];
        
        startingX += thumb.size.width + 10;
    }
    
    [self.view addSubview:scrollView];
    
    [self expand];
}

- (void)expand
{
    [UIView animateWithDuration:0.5 
                     delay:0 
                     options:UIViewAnimationCurveEaseOut 
                     animations:^{
                         self.view.frame = expandedFrame;
                     } 
                     completion:^(BOOL finished) {
                         expanded = true;
                     }
     ];
}

- (void)collapse
{
    [UIView animateWithDuration:0.5 
                     delay:0
                     options:UIViewAnimationCurveEaseOut 
                     animations:^{
                         self.view.frame = collapsedFrame;
                     } 
                     completion:^(BOOL finished) {
                         expanded = false;
                     }
     ];
}

- (void) toggle
{
    if(expanded)
        [self collapse];
    else
        [self expand];
}

- (void)pageItemClicked:(id)sender
{
    NSLog(@"Clicked %d", [((UIButton*)sender) tag]);
    [delegate pageSelected:[((UIButton*)sender) tag]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc
{
    NSLog(@"%s", "Cleaning paging view...");
    
    [collapseButton release];
    
    for(UIImage *img in thumbs) {
        [img release];
    }
    
    [super dealloc];
}
@end
