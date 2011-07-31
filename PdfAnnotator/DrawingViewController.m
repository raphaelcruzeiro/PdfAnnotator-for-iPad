//
//  DrawingViewController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/14/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "DrawingViewController.h"
#import "memoryreport.h"

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
            self._paths = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

- (void)setDrawable:(BOOL)enabled
{
    eraserMode = !enabled;
    drawable = enabled;
}

- (void)setEraserMode:(BOOL)enabled
{
    drawable = !enabled;
    eraserMode = enabled;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(drawable || eraserMode) {
        UITouch *touch = [touches anyObject];
        lastPoint = [touch locationInView:self.view];
        
        if(drawable) {
            currentPath = [[MarkerPath alloc] initWithPoint:lastPoint AndBrush:_brush];
            [self._paths addObject:currentPath];
            
            [self prepareBrush];
        } else {
            [self eraseAtPoint:&lastPoint];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(drawable || eraserMode) {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        
        if(drawable) {
            CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
            
            CGContextStrokePath(context);
            CGContextFillPath(context);
            
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            [currentPath addPoint:currentPoint];
            
            lastPoint = currentPoint;
        } else {
            [self eraseAtPoint:&currentPoint];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(drawable) {
        firstTime = YES;
        [self drawPaths];
        
        [delegate changed];
        
        NSInteger markerCount = [self._paths count];
        
        for(NSInteger i = markerCount - 1 ; i > -1 ; i--) {
            MarkerPath *path = [self._paths objectAtIndex:i];
            
            if(!path.active) {
                [_paths removeObject:path];
                [path release];
            }
        }
        
        [delegate canUndo:[self canUndo]];
    }
}

- (void)eraseAtPoint:(CGPoint*)point
{
    for(MarkerPath *path in self._paths) {
        for(MrkPoint *pt in path.points) {
            CGPoint point2 = CGPointMake(pt.x, pt.y);
            
            if ([self calculateDistanceBetween:point And:&point2] < 10) {
                
                path.active = NO;
                [self drawPaths];
                [delegate changed];
                [delegate canUndo:[self canUndo]];
                [delegate canRedo:[self canRedo]];
                
                return;
            }
        }
    }
}

- (CGFloat)calculateDistanceBetween:(CGPoint*)point1 And:(CGPoint*)point2
{
    return sqrt(pow(point2->x - point1->x, 2) + pow(point2->y - point1->y, 2));
}

- (void)drawPaths
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    for(MarkerPath *path in self._paths) {
        if(path.active) {
            _brush = [path getBrush];
            [self prepareBrush];
            
            CGContextAddPath(context, [path getPath]);
            
            CGContextStrokePath(context);
            CGContextFillPath(context);
        } 
    }
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
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

- (void)undo
{
    NSInteger markerCount = [self._paths count];
    
    for(NSInteger i = markerCount - 1 ; i > -1 ; i--) {
        MarkerPath *path = [self._paths objectAtIndex:i];
        
        if(path.active && !path.loadedFromFile) {
            path.active = NO;
            [self drawPaths];
            [delegate changed];
            [delegate canUndo:[self canUndo]];
            [delegate canRedo:[self canRedo]];
            return;
        }
    }
}

- (void)redo
{
    NSInteger markerCount = [self._paths count];
    
    for(NSInteger i = 0 ; i < markerCount ; i++) {
        MarkerPath *path = [self._paths objectAtIndex:i];
        
        if(!path.active && !path.loadedFromFile) {
            path.active = YES;
            [self drawPaths];
            [delegate changed];
            [delegate canUndo:[self canUndo]];
            [delegate canRedo:[self canRedo]];
            return;
        }
    }
}

- (BOOL)canUndo
{
    NSInteger markerCount = [self._paths count];
    
    for(NSInteger i = markerCount - 1 ; i > -1 ; i--) {
        MarkerPath *path = [self._paths objectAtIndex:i];
        
        if(path.active && !path.loadedFromFile)
            return YES;
    }
    
    return NO;
}

- (BOOL)canRedo
{
    NSInteger markerCount = [self._paths count];
    
    for(NSInteger i = markerCount - 1 ; i > -1 ; i--) {
        MarkerPath *path = [self._paths objectAtIndex:i];
        
        if(!path.active) 
            return YES;
    }
    
    return NO;
}

- (void)setBrush:(TextMarkerBrush)brush
{
    _brush = brush;
}

- (void)didReceiveMemoryWarning
{
    memoryReport();
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    for(MarkerPath *path in _paths) {
        if(!path.active) {
            [_paths removeObject:path];
            [path release];
        }
    }
    
    [delegate canRedo:[self canRedo]];
    [delegate canUndo:[self canUndo]];
    
    memoryReport();
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
    
    self.imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    
    [self.view addSubview:self.imageView];
   
    [self drawPaths];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
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
