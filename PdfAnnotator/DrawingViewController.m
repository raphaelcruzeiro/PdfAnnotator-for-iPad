//
//  DrawingViewController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/14/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import "DrawingViewController.h"

@implementation DrawingViewController

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super init]) {
        drawable = NO;
        viewFrame = frame;
    }
    
    return self;
}

- (void)setDrawable:(BOOL)enabled
{
    drawable = enabled;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(drawable) {
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:self.view];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(drawable) {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        
        CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        
        CGContextStrokePath(context);
        CGContextFillPath(context);
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        lastPoint = currentPoint;
    }
}

- (void)prepareBrush
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255 green:255 blue:0 alpha:0.4f].CGColor);
	CGContextSetLineWidth(context, 10.0);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
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
    
    [self.view setFrame:viewFrame];
    
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    
    [self.view addSubview:self.imageView];
    
    [self prepareBrush];
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

@end
