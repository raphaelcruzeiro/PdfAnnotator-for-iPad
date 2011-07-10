//
//  PDFPagingViewController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/10/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import "PDFPagingViewController.h"

@implementation PDFPagingViewController

@synthesize collapseButton;

- (id)init
{
    if(self = [super init]){
        expanded = false;
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
    collapsedFrame = CGRectMake(0, 966, 768, 270);
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 0.2;
    self.view.frame = collapsedFrame;
    
    collapseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [collapseButton setTitle:@"ˆ" forState:UIControlStateNormal];
    [collapseButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchDown];
    
    [collapseButton setFrame:CGRectMake(25, 10, 40, 20)];
    [self.view addSubview:collapseButton];
    
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
    [collapseButton release];
    
    [super dealloc];
}
@end
