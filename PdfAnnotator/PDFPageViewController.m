//
//  PDFPageViewController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/2/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import "PDFPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PDFDocument.h"
#import "PDFPagingViewController.h"

@implementation PDFPageViewController

@synthesize _document;
@synthesize pagingViewController;

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

- (void)loadDocument:(PDFDocument *)document
{
    self._document = document;
    
    CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(self._document.page, kCGPDFCropBox));
    
    pageRect.origin.x = (((self.view.frame.size.width / 2) - (pageRect.size.width / 2)) / 2);
    
    NSLog(@"Page width: %f", pageRect.size.width);
    NSLog(@"View width: %f", self.view.frame.size.width);
    
    NSLog(@"X: %f", pageRect.origin.x);
    
    CATiledLayer *tiledLayer = [CATiledLayer layer];
    tiledLayer.delegate = self;
    tiledLayer.tileSize = CGSizeMake(1024.0, 1024.0);
    tiledLayer.levelsOfDetail = 1000;
    tiledLayer.levelsOfDetailBias = 1000;
    tiledLayer.frame = pageRect;
    
    contentView = [[UIView alloc] initWithFrame:pageRect];
    [contentView.layer addSublayer:tiledLayer];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin = CGPointZero;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:viewFrame];
    scrollView.delegate = self;
    scrollView.contentSize = pageRect.size;
    scrollView.maximumZoomScale = 1000;
    [scrollView addSubview:contentView];
    
    [self.view addSubview:scrollView];   
    
    pagingViewController = [[PDFPagingViewController alloc] init];
    [self.view addSubview:pagingViewController.view];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contentView;
}

- (void)drawLayer:inContext:(CGContextRef)ctx
{}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if(self._document) {
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx));
        CGContextTranslateCTM(ctx, 0.0, layer.bounds.size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(self._document.page, kCGPDFCropBox, layer.bounds, 0, true));
        CGContextDrawPDFPage(ctx, self._document.page);
    }
}

- (void)dealloc
{
    [pagingViewController release];
    
    [super dealloc];
}

@end
