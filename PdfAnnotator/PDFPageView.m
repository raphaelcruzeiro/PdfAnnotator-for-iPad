//
//  PDFPageView.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/2/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import "PDFPageView.h"
#import "PDFDocument.h"
#import <QuartzCore/QuartzCore.h>

@implementation PDFPageView

@synthesize _document;

- (id)initWithDocument:(PDFDocument *)document
{
    if(self = [super init]){
        self._document = document;
    
    }
    
    return self;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contentView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx));
    CGContextTranslateCTM(ctx, 0.0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(self._document.page, kCGPDFCropBox, self.bounds, 0, true));
    CGContextDrawPDFPage(ctx, self._document.page);
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

@end
