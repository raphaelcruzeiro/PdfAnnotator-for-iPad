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

#import <QuartzCore/QuartzCore.h>

@implementation PdfAnnotatorViewController

@synthesize pageViewController;
@synthesize loadMenu;
@synthesize popOver;
@synthesize load;
@synthesize document;

@synthesize documentView;

- (void)dealloc
{
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
    
    self.documentView.backgroundColor = [UIColor blackColor];
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
    self.loadMenu = [[[LoadMenuController alloc] initWithObserver:self] autorelease];
    self.popOver = [[[UIPopoverController alloc] initWithContentViewController:loadMenu] autorelease];
    
    [self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)documentChoosen:(NSURL *)_document
{
    NSLog(@"%s", [[_document absoluteString] UTF8String]);
    
    [self.popOver dismissPopoverAnimated:YES];
    
    if(self.document != NULL) {
        UIView * subView = [[self.documentView subviews] lastObject];
        [subView removeFromSuperview];
        [subView dealloc];
        
        self.document = NULL;
    }
    
    self.document = [[[PDFDocument alloc] initWithDocument:_document] autorelease];
    
    CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(self.document.page, kCGPDFCropBox));
    
    pageRect.origin.x = (self.documentView.frame.size.width / 2) - (pageRect.size.width / 2) - 35;
    
    CATiledLayer *tiledLayer = [CATiledLayer layer];
    tiledLayer.delegate = self;
    tiledLayer.tileSize = CGSizeMake(1024.0, 1024.0);
    tiledLayer.levelsOfDetail = 1000;
    tiledLayer.levelsOfDetailBias = 1000;
    tiledLayer.frame = pageRect;
    
    contentView = [[UIView alloc] initWithFrame:pageRect];
    [contentView.layer addSublayer:tiledLayer];
    
    CGRect viewFrame = self.documentView.frame;
    viewFrame.origin = CGPointZero;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:viewFrame];
    scrollView.delegate = self;
    scrollView.contentSize = pageRect.size;
    scrollView.maximumZoomScale = 1000;
    [scrollView addSubview:contentView];
    
    [self.documentView addSubview:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contentView;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if(self.document != NULL) {
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx));
        CGContextTranslateCTM(ctx, 0.0, layer.bounds.size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(self.document.page, kCGPDFCropBox, layer.bounds, 0, true));
        CGContextDrawPDFPage(ctx, self.document.page);
    }
}

@end
