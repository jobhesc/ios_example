//
//  ViewController.h
//  clearup
//
//  Created by hesc on 15/8/7.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSButton *btnAnalysis;
@property (weak) IBOutlet NSButton *btnDelete;
@property (unsafe_unretained) IBOutlet NSTextView *txtFiles;
@property (weak) IBOutlet NSTextField *txtProjPath;

- (IBAction)analysis:(id)sender;
- (IBAction)deleteFile:(id)sender;

@end

