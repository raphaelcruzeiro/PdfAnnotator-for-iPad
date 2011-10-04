// Copyright (C) 2011 by Raphael Cruzeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PDFPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PDFDocument.h"
#import "DrawingViewController.h"
#import "Annotation.h"
#import "PageAnnotation.h"
#import "DocumentSerializer.h"
#import "DocumentDeserializer.h"

@implementation PDFPageViewController

@synthesize _document;
@synthesize pagingViewController;
@synthesize drawingViewController;
@synthesize delegate;

- (id)initWithDelegate:(id<PDFPageViewControllerDelegate>)_delegate
{
    self = [super init];
    
    if(self) {
        self.delegate = _delegate;
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
    
    [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [contentView release];
    [scrollView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)loadDocument:(PDFDocument *)document
{
    self._document = document;
    [self refreshPage];
}

- (void)refreshPage
{  
    [self._document save];
    
    [delegate canRedo:NO];
    [delegate canUndo:NO];
    [delegate switchToHandMode];
    
    if(contentView) {
        for(UIView *v in self.view.subviews) {
            [v removeFromSuperview];
        }
    }
    
    [self._document loadDocumentRef];
    
    if(!pagingViewController)
        pagingViewController = [[PDFPagingViewController alloc] initWithDocument:self._document AndObserver:self];
        
    CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(self._document.page, kCGPDFCropBox));
    
    pageRect.origin.x = 0;
    pageRect.origin.y = 0;
    
    NSInteger pageNumber = CGPDFPageGetPageNumber(_document.page);
    
    PageAnnotation *pageAnnotation = [self._document.annotation annotationForPage:pageNumber];
    
    if(!pageAnnotation) {
        pageAnnotation = [[[PageAnnotation alloc] initWithPageNumber:pageNumber] autorelease];
        [self._document.annotation._pageAnnotations addObject:pageAnnotation];
    }
    
    self.drawingViewController = [[[DrawingViewController alloc] initWithFrame:pageRect AndPaths:pageAnnotation._paths AndDelegate:self] autorelease];
    
    pageRect.origin.x = 1;
    pageRect.origin.y = 1;

    CATiledLayer *tiledLayer = [CATiledLayer layer];
    tiledLayer.delegate = self;
    tiledLayer.tileSize = CGSizeMake(1024.0, 1024.0);
    tiledLayer.levelsOfDetail = 1000;
    tiledLayer.levelsOfDetailBias = 1000;
    tiledLayer.frame = pageRect;
    
    pageRect.origin.x = 0;
    
    pageRect.origin.y = 60;
    pageRect.origin.x = ((self.view.frame.size.width / 2) - ((pageRect.size.width + 2) / 2));
    
    pageRect.size.width += 2;
    pageRect.size.height += 2;
    
    contentView = [[UIView alloc] initWithFrame:pageRect];
    [contentView.layer addSublayer:tiledLayer];
    
    [contentView addSubview:self.drawingViewController.view];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin = CGPointZero;
    
    scrollView = [[UIScrollView alloc] initWithFrame:viewFrame];
    
    [contentView setBackgroundColor:[UIColor darkGrayColor]];
    
    scrollView.delegate = self;
    scrollView.contentSize = pageRect.size;
    scrollView.maximumZoomScale = 1000;
    [scrollView setMaximumZoomScale:4];
    [scrollView addSubview:contentView];
    
    [self.view addSubview:scrollView];   
    [self.view addSubview:pagingViewController.view];
    
    [self._document releaseDocumentRef];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contentView;
}

- (void)pageSelected:(NSInteger)page
{
    [self._document loadPage:page];
    [self refreshPage];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if(self._document) {
        [self._document loadDocumentRef];
        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
        CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx));
        CGContextTranslateCTM(ctx, 0.0, layer.bounds.size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(self._document.page, kCGPDFCropBox, layer.bounds, 0, true));
        CGContextDrawPDFPage(ctx, self._document.page);
        [self._document releaseDocumentRef];
    }
}

- (void)setPenMode:(BOOL)enabled
{
    [scrollView setScrollEnabled:!enabled];
    [drawingViewController setDrawable:enabled];
}

- (void)setHandMode:(BOOL)enabled
{
    [scrollView setScrollEnabled:enabled];
    [drawingViewController setDrawable:!enabled];
}

- (void)setEraserMode:(BOOL)enabled
{
    [scrollView setScrollEnabled:!enabled];
    [drawingViewController setEraserMode:enabled];
}

- (void)setBrush:(TextMarkerBrush)brush
{
    [drawingViewController setBrush:brush];
}

- (void)undo
{
    [drawingViewController undo];
}

- (void)redo
{
    [drawingViewController redo];
}

- (void)changed
{
    [delegate changed];
}

- (void)canUndo:(BOOL)value;
{
    [delegate canUndo:value];
}

- (void)canRedo:(BOOL)value
{
    [delegate canRedo:value];
}

- (void)dealloc
{
    [pagingViewController release];
    
    [super dealloc];
}

@end
