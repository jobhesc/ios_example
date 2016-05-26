//
//  ViewController.m
//  CustomTableViewCell
//
//  Created by hesc on 15/8/9.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#import "Status.h"
#import "StatusTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_status;
    NSMutableArray *_statusCells;   //存储cell,用于计算高度
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"statusinfo" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    _status = [NSMutableArray new];
    _statusCells = [NSMutableArray new];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_status addObject:[Status initWithDictionary:obj]];
        [_statusCells addObject:[StatusTableViewCell new]];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _status.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewIdentifier";
    StatusTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[StatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.status = _status[indexPath.row];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusTableViewCell *cell = _statusCells[indexPath.row];
    cell.status = _status[indexPath.row];
    return cell.height;
}
@end
