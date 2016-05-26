//
//  ViewController.m
//  clearup
//
//  Created by hesc on 15/8/7.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()<NSXMLParserDelegate>{
    NSMutableArray *_files;
    NSString *_file;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)analysis:(id)sender {
    NSString *path = [self.txtProjPath stringValue];
    if(path == nil || path.length == 0){
        [self alert:@"请输入项目根目录"];
        return;
    }
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setPrompt:@"确定"];
    [panel setMessage:@"选择一个文件"];
    [panel setCanChooseDirectories:NO];
    [panel setCanCreateDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:NO];
    
    NSArray *fileTypes = [[NSArray alloc] initWithObjects:@"xml", @"txt", nil];
    [panel setAllowedFileTypes:fileTypes];
    NSInteger result = [panel runModal];
    if(result == NSFileHandlingPanelOKButton){
        //解析xml文件，获取文件名
        [self parseXml:[panel URL]];
    }
    
}

-(void)parseXml:(NSURL *)url{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    [parser parse];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    _files = [[NSMutableArray alloc] init];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    if(_files != nil && _files.count > 0){
        NSMutableString *mutableString = [[NSMutableString alloc] init];
        for (int i=0; i<_files.count; i++) {
            [mutableString appendFormat:@"%@\n", _files[i] ];
        }
        [self.txtFiles setString:mutableString];
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    _file = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    _file = string;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"file"] && _file != nil && _file.length > 0){
        NSString *path = [[_file stringByReplacingOccurrencesOfString:@"file://" withString:@""] stringByReplacingOccurrencesOfString:@"$PROJECT_DIR$"withString:[self.txtProjPath stringValue]];
        
        [_files addObject:path];
    }
}

-(void)alert:(NSString *)message{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:message];
    [alert setAlertStyle:NSAlertFirstButtonReturn];
    [alert runModal];
}

- (IBAction)deleteFile:(id)sender {
    if(_files == nil || _files.count == 0){
        [self alert:@"没有可删除的文件"];
        return;
    }
    
    NSString *title = self.title;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(int i = 0; i<_files.count; i++){
        if([fileManager fileExistsAtPath:_files[i] isDirectory:NO]){
            [self setTitle:[NSString stringWithFormat:@"正在删除 %@", _files[i]]];
            NSURL *url = [[NSURL alloc] initFileURLWithPath:_files[i] isDirectory:NO];
            [fileManager removeItemAtURL:url error:nil];
        }
    }
    [self setTitle:title];
    [self alert:@"删除文件完成"];
}
@end
