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

#import "NSFileManagerExtension.h"

@interface CBlockEnumerator : NSEnumerator
@property (readwrite, nonatomic, copy) id (^block)(void);
@end;

@implementation NSFileManager (NSFileManagerExtension)


- (NSString*)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSEnumerator *)tx_enumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *, NSError *))handler
{
    NSAssert(mask == 0, @"We don't handle masks");
    NSAssert(keys == NULL, @"We don't handle non-null keys");
    
    NSDirectoryEnumerator *innerEnumerator = [self enumeratorAtPath:[url path]];
    
    CBlockEnumerator *enumerator = [[[CBlockEnumerator alloc] init] autorelease];
    enumerator.block = ^id(void) {
        NSString *path = [innerEnumerator nextObject];
        
        if(path != NULL) {
            return [url URLByAppendingPathComponent:path];
        } else {
            return NULL;
        }
    };
    
    return enumerator;
}

@end

@implementation CBlockEnumerator

@synthesize block;

- (void)dealloc
{
    [block release];
    block = NULL;
    
    [super dealloc];
}

- (id)nextObject
{
    id object = self.block;
    return object;
}

@end