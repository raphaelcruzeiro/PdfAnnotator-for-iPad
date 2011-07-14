//
//  PdfAnnotatorViewController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "PdfAnnotatorViewController.h"
#import "LoadMenuController.h"
#import "PDFDocument.h"
#import "PDFPageViewController.h"
#import "PDFPagingViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation PdfAnnotatorViewController

@synthesize pageViewController;
@synthesize loadMenu;
@synthesize popOver;
@synthesize toolbar;
@synthesize load;
@synthesize pen;
@synthesize hand;
@synthesize document;

@synthesize documentView;

- (void)dealloc
{
    [pageViewController release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.load.target = self;
    self.load.action = @selector(loadClicked:);
    
    self.pen.target = self;
    self.pen.action = @selector(penClicked:);
    
    self.hand.target = self;
    self.hand.action = @selector(handClicked:);
    
    [self.toolbar setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    
    self.documentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundTile"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)loadClicked:(id)sender
{
    self.loadMenu = [[LoadMenuController alloc] initWithObserver:self];
    self.popOver = [[UIPopoverController alloc] initWithContentViewController:loadMenu];
    
    [self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)penClicked:(id)sender
{
    if(pageViewController) {
        NSLog(@"Entering pen mode");
        [pageViewController setPenMode:YES];
    }
}

- (void)handClicked:(id)sender
{
    if(pageViewController) {
        NSLog(@"Entering hand mode");
        [pageViewController setHandMode:YES];
    }
}

- (void)documentChoosen:(NSURL *)_document
{
    NSLog(@"%s", [[_document absoluteString] UTF8String]);
    
    [self.popOver dismissPopoverAnimated:YES];
    
    [self.loadMenu release];
    [self.popOver release];
    
    if(self.document != NULL) {
        [pageViewController.view removeFromSuperview];
        [pageViewController release];
    }
    
    self.document = [[[PDFDocument alloc] initWithDocument:_document] autorelease];
    
    pageViewController = [[PDFPageViewController alloc] initWithNibName:Nil bundle:Nil];
    [pageViewController loadDocument:self.document];
    
    [self.view addSubview:[pageViewController view]];
    [self.view bringSubviewToFront:toolbar];
}

@end
