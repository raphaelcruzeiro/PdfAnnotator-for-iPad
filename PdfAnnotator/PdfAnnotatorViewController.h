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

#import <UIKit/UIKit.h>
#import "LoadMenuController.h"
#import "PDFPageViewController.h"
#import "TextMarkerSelectorViewController.h"

@class PDFDocument;

@interface PdfAnnotatorViewController : UIViewController <LoadMenuDelegate, TextMarkerMenuDelegate, PDFPageViewControllerDelegate> {
    UIView *contentView;
}

- (void)loadClicked:(id)sender;
- (void)handClicked:(id)sender;
- (void)textMarkerClicked:(id)sender;
- (void)saveClicked:(id)sender;
- (void)undoClicked:(id)sender;
- (void)redoClicked:(id)sender;
- (void)eraserClicked:(id)sender;

- (void)resetButtonStates;

@property (nonatomic, retain) PDFPageViewController *pageViewController;
@property (nonatomic, retain) LoadMenuController *loadMenu;
@property (nonatomic, retain) TextMarkerSelectorViewController *textMarkerController;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *load;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *hand;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *textMarker;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *undo;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *redo;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *eraser;
@property (nonatomic, retain) PDFDocument *document;

@property (nonatomic, retain) IBOutlet UIView *documentView;

@end
