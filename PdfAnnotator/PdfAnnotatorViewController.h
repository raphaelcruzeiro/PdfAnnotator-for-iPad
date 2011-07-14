//
//  PdfAnnotatorViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMenuController.h"

@class PDFDocument;
@class PDFPageViewController;

@interface PdfAnnotatorViewController : UIViewController <LoadMenuDelegate> {
    UIView *contentView;
}

- (void)loadClicked:(id)sender;
- (void)handClicked:(id)sender;
- (void)penClicked:(id)sender;

@property (nonatomic, retain) PDFPageViewController *pageViewController;
@property (nonatomic, retain) LoadMenuController *loadMenu;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *load;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *hand;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pen;
@property (nonatomic, retain) PDFDocument *document;

@property (nonatomic, retain) IBOutlet UIView *documentView;

@end
