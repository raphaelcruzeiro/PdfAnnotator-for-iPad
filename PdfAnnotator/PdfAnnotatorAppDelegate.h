//
//  PdfAnnotatorAppDelegate.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PdfAnnotatorViewController;

@interface PdfAnnotatorAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PdfAnnotatorViewController *viewController;

@end
