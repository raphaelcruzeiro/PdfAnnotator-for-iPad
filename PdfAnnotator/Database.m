//
//  Database.m
//  PdfAnnotator
//
//  Created by Raphael Cruzeiro on 7/17/11.
//  Copyright 2011 Raphael Cruzeiro. All rights reserved.
//

#import "Database.h"


@implementation Database

- (NSString*)filePath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"database.sql"];
}

- (void)open
{
    if(sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"Database failed to open.");
    }
}

- (void)createTable:(NSString *)name WithFields:(NSArray *)fields
{
    if([fields count] < 1) {
        NSLog(@"Cannot create table with empty fields.");
        return;
    }
    
    char *err;
    
    NSString *cmd = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' TEXT PRIMARY KEY", name, [fields objectAtIndex:0]];
    
    for(NSInteger i = 1 ; i < [fields count] ; i++) {
        cmd = [NSString stringWithFormat:@"%@ , '%@' TEXT", cmd, [fields objectAtIndex:i]];
    }
    
    cmd = [NSString stringWithFormat:@"%@)", cmd];
    
    if(sqlite3_exec(db, [cmd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog([NSString stringWithFormat:@"Failed to create table with command: %@"], cmd);
    }
}

- (void)insertInto:(NSString *)tableName Fields:(NSArray *)fields Values:(NSArray *)values
{
    NSString *cmd = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@'", tableName];
    
    NSString *_fields = [NSString stringWithFormat: @"('%@'", [fields objectAtIndex:0]];
    NSString *_values = [NSString stringWithFormat:@"(?", [values objectAtIndex:0]];
    
    for(NSInteger i = 1 ; i < [fields count] && i < [values count] ; i++) {
        _fields = [NSString stringWithFormat:@"%@, '%@'", _fields, [fields objectAtIndex:i]];
        _values = [NSString stringWithFormat:@"%@, ?", _values];
    }
    
    _fields = [NSString stringWithFormat:@"%@)", _fields];
    _values = [NSString stringWithFormat:@"%@)", _values];
    
    cmd = [NSString stringWithFormat:@"%@ %@ VALUES %@", cmd, _fields, _values];
    
    const char* sql = [cmd UTF8String];
    
    sqlite3_stmt *stmt;
    
    if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        for(NSInteger i = 0 ; i < [values count] ; i++) {
            sqlite3_bind_text(stmt, (i + 1), [[values objectAtIndex:i] UTF8String], -1, NULL);
        }
    } else {
        NSLog(@"Could not prepare SQL command.");
    }
    
    if(sqlite3_step(stmt) != SQLITE_DONE)
        NSLog(@"Error when nserting row into table.");
    
    sqlite3_finalize(stmt);
}

- (NSArray*)selectFrom:(NSString *)table
{
    NSString *cmd = [NSString stringWithFormat:@"SELECT * FROM %@", table];
    
    sqlite3_stmt *stmt;
    
    if(sqlite3_prepare_v2(db, [cmd UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        
        int columnCount = sqlite3_column_count(stmt);
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableArray *row = [[NSMutableArray alloc ] init];
            
            for(int i = 0 ; i < columnCount ; i++) {
                char *field = (char*) sqlite3_column_text(stmt, i);
                
                if(field == NULL) {
                    [row addObject:nil];
                    continue;
                }
                
                NSString *fieldString = [[NSString alloc] initWithUTF8String:field];
                
                [row addObject:fieldString];
            }
            
            [result addObject:row];
        }
        
        return result;
    }         
    
    NSLog(@"Could not prepare SQL command.");
    
    return nil;
}

@end
