//
//  LoadMenuController.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 6/25/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "LoadMenuController.h"
#import "NSFileManagerExtension.h"


@implementation LoadMenuController

@synthesize files;
@synthesize delegate;

- (id)initWithObserver:(id<LoadMenuDelegate>)observer
{
    if((self = [super init]) != NULL) {
        self.delegate = observer;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSURL *documents = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSURL *inbox = [documents URLByAppendingPathComponent:@"Inbox"];
        NSError *_error = NULL;
        id errorHandler = ^(NSURL *url, NSError *error) { NSLog(@"Error: %@", error); return YES; };
        
        if([fileManager fileExistsAtPath:inbox.path]) {
            for(NSURL *url in [fileManager tx_enumeratorAtURL:inbox includingPropertiesForKeys:NULL options:0 errorHandler:errorHandler]) {
                NSURL *destinationUrl = [documents URLByAppendingPathComponent:[url lastPathComponent]];
                BOOL result = [fileManager moveItemAtURL:url toURL:destinationUrl error:&_error];
                NSLog(@"MOVING %@ %d %@", url, result, _error);
            }
        }
        
        self.files = [fileManager contentsOfDirectoryAtURL:documents includingPropertiesForKeys:NULL options:0 error:NULL];
            
        count = [self.files count];
        
        NSLog(@"Got %d files.", count);
    }
    
    return self;
}

- (void)dealloc
{
    [files release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSString *cellValue = [[files objectAtIndex:indexPath.row] lastPathComponent];
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *selectedUrl = [self.files objectAtIndex:indexPath.row];
    [delegate documentChoosen:selectedUrl];
}

@end
