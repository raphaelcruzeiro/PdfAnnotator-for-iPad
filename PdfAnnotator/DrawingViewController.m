//
//  DrawingViewController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/14/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "DrawingViewController.h"

@implementation DrawingViewController

@synthesize imageView;
@synthesize _paths;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame AndPaths:(NSMutableArray*)paths AndDelegate:(id<DrawingViewControllerDelegate>)_delegate
{
    if((self = [super init])) {
        drawable = NO;
        firstTime = YES;
        viewFrame = frame;
        self.delegate = _delegate;
        if(paths) {
            self._paths = paths;
        }
        else
            self._paths = [[NSMutableArray alloc] init];
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
        
        NSLog(@"Writing paths on path array with count%d", [self._paths count]);
        
        currentPath = [[MarkerPath alloc] initWithPoint:lastPoint AndBrush:_brush];
        [self._paths addObject:currentPath];
        
        [self prepareBrush];
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
        
        [currentPath addPoint:currentPoint];
        
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(drawable) {
        firstTime = YES;
        [self drawPaths];
        
        [delegate changed];
    }
}

- (void)drawPaths
{
    for(MarkerPath *path in self._paths) {
        _brush = [path getBrush];
        [self prepareBrush];
        
        CGContextAddPath(context, [path getPath]);
        
        CGContextStrokePath(context);
        CGContextFillPath(context);
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    }
}

- (void)prepareBrush
{
    if(firstTime) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        firstTime = NO;
    }
    context = UIGraphicsGetCurrentContext();
    
    switch (_brush) {
        case TextMarkerBrushYellow:
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255 green:255 blue:0 alpha:0.4f].CGColor);
            break;
        case TextMarkerBrushGreen:
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:230 blue:0 alpha:0.4f].CGColor);
            break;
        case TextMarkerBrushRed:
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:230 green:0 blue:0 alpha:0.4f].CGColor);
            break;
        case TextMarkerBrushBlue:
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:230 alpha:0.4f].CGColor);
            break;
    }
    
	CGContextSetLineWidth(context, 10.0);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
}

- (void)setBrush:(TextMarkerBrush)brush
{
    _brush = brush;
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
   
    [self drawPaths];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [imageView release];
    [_paths release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc
{
    [super dealloc];
}

@end
