//
//  LoadMenuController.h
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadMenuDelegate;

@interface LoadMenuController : UITableViewController {
    NSInteger count;
}

@property (readwrite, nonatomic, retain) NSMutableArray *files;
@property (readwrite, nonatomic, retain) id<LoadMenuDelegate> delegate;

- (id)initWithObserver:(id<LoadMenuDelegate>)observer;

@end

@protocol LoadMenuDelegate <NSObject>

- (void)documentChoosen:(NSURL *)document;

@end
