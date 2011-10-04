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
        
        self.files = [[[NSMutableArray alloc] init] autorelease];
        
        NSString *defaultDoc = [[NSBundle mainBundle] pathForResource:@"Pdf Marker Manual" ofType:@"pdf"];
        [self.files addObject:defaultDoc];
        
        NSArray *_files = [fileManager contentsOfDirectoryAtURL:documents includingPropertiesForKeys:NULL options:0 error:NULL];
        
        for(NSURL *url in _files) {
            if(![[url pathExtension] compare:@"pdf"])
                [self.files addObject:[url absoluteString]];
        }
            
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
    NSString *selectedUrl = [self.files objectAtIndex:indexPath.row];
    [delegate documentChoosen:selectedUrl];
}

@end
