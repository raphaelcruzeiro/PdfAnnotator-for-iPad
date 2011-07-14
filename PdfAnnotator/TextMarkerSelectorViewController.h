//
//  TextMarkerSelectorViewController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/14/11.
//  Copyright 2011 Inspira Tecnologia e Mkt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingViewController.h"

@protocol TextMarkerMenuDelegate;

@interface TextMarkerSelectorViewController : UIViewController {
}

@property (readwrite, nonatomic, retain) id<TextMarkerMenuDelegate> delegate;

- (id)initWithObserver:(id<TextMarkerMenuDelegate>)observer;
- (void)buttonClicked:(id)sender;

@end


@protocol TextMarkerMenuDelegate <NSObject>

- (void)brushSelected:(TextMarkerBrush)brush;

@end
