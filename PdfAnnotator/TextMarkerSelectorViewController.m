//
//  TextMarkerSelectorViewController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/14/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import "TextMarkerSelectorViewController.h"

@implementation TextMarkerSelectorViewController

@synthesize delegate;

- (id)initWithObserver:(id<TextMarkerMenuDelegate>)observer
{
    self = [super init];
    if (self) {
        self.delegate = observer;
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
    
    [self.view setFrame:CGRectMake(0, 0, 250, 60)];
    
    UIButton *yellowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yellowButton setBackgroundColor:[UIColor darkGrayColor]];
    [yellowButton setImage:[UIImage imageNamed:@"yellowMarker.png"] forState:UIControlStateNormal];
    [yellowButton setFrame:CGRectMake(3, 3, 50, 42)];
    
    UIButton *greenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [greenButton setBackgroundColor:[UIColor darkGrayColor]];
    [greenButton setImage:[UIImage imageNamed:@"greenMarker.png"] forState:UIControlStateNormal];
    [greenButton setFrame:CGRectMake(56, 3, 50, 42)];
    
    UIButton *redButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redButton setBackgroundColor:[UIColor darkGrayColor]];
    [redButton setImage:[UIImage imageNamed:@"redMarker.png"] forState:UIControlStateNormal];
    [redButton setFrame:CGRectMake(109, 3, 50, 42)];
    
    UIButton *blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blueButton setBackgroundColor:[UIColor darkGrayColor]];
    [blueButton setImage:[UIImage imageNamed:@"blueMarker.png"] forState:UIControlStateNormal];
    [blueButton setFrame:CGRectMake(162, 3, 50, 42)];
    
    yellowButton.tag = TextMarkerBrushYellow;
    greenButton.tag = TextMarkerBrushGreen;
    redButton.tag = TextMarkerBrushRed;
    blueButton.tag = TextMarkerBrushBlue;
    
    [yellowButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [greenButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [redButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [blueButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:yellowButton];
    [self.view addSubview:greenButton];
    [self.view addSubview:redButton];
    [self.view addSubview:blueButton];
}

- (void)buttonClicked:(id)sender
{
    [delegate brushSelected:(TextMarkerBrush)[((UIButton*)sender) tag]];
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
