//
//  ViewController.m
//  UITableView
//
//  Created by hesc on 15/8/6.
//  Copyright (c) 2015年 hesc. All rights reserved.
//

#import "ViewController.h"
#import "Contact.h"
#import "ContactGroup.h"

#define ContactToolbarHeight 44
#define ContactSearchBarHeight 44

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate>{
    UITableView *_tableView;
    NSMutableArray *_contacts;
    NSMutableArray *_searchContacts;
    NSIndexPath *_indexPath;
    UIToolbar *_toolbar;
    UISearchBar *_searchBar;
    BOOL isInsert;
    BOOL _isSearching;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(ContactToolbarHeight, 0, 0, 0);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [self addToolbar];
    [self addSearchBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addSearchBar{
    CGRect searchBarRect = CGRectMake(0, 0, self.view.frame.size.width, ContactSearchBarHeight);
    _searchBar = [[UISearchBar alloc] initWithFrame:searchBarRect];
    _searchBar.placeholder = @"请输入查询信息";
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    _tableView.tableHeaderView = _searchBar;
    
}

-(void)addToolbar{
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ContactToolbarHeight)];
    [self.view addSubview:_toolbar];
    
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(remove)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action: nil];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    _toolbar.items = @[removeButton, flexibleButton, addButton];
}

-(void)add{
    isInsert = YES;
    [_tableView setEditing:![_tableView isEditing] animated:YES];
}

-(void)remove{
    isInsert = NO;
    [_tableView setEditing:![_tableView isEditing] animated:YES];
}

-(void)initData{
    _contacts = [[NSMutableArray alloc] init];
    
    Contact *contact1 = [Contact initWithFirstName:@"he" andLastName:@"shengcheng" andPhoneNumber:@"15010002426"];
    Contact *contact2 = [Contact initWithFirstName:@"he" andLastName:@"ning" andPhoneNumber:@"13812231343"];
    ContactGroup *group1 = [ContactGroup initWIthName:@"H" andDetail:@"name begin with H" andContacts:[NSMutableArray arrayWithObjects:contact1, contact2, nil]];
    [_contacts addObject:group1];

    Contact *contact3 = [Contact initWithFirstName:@"yao" andLastName:@"cuicui" andPhoneNumber:@"13811196172"];
    Contact *contact4 = [Contact initWithFirstName:@"yao" andLastName:@"xunan" andPhoneNumber:@"13920003123"];
    Contact *contact5 = [Contact initWithFirstName:@"yang" andLastName:@"xue" andPhoneNumber:@"15020003123"];
    ContactGroup *group2 = [ContactGroup initWIthName:@"Y" andDetail:@"name begin with Y" andContacts:[NSMutableArray arrayWithObjects:contact3, contact4, contact5, nil]];
    [_contacts addObject:group2];

    Contact *contact6 = [Contact initWithFirstName:@"zhang" andLastName:@"sanfeng" andPhoneNumber:@"13811196172"];
    Contact *contact7 = [Contact initWithFirstName:@"zhang" andLastName:@"fei" andPhoneNumber:@"13811196173"];
    Contact *contact8 = [Contact initWithFirstName:@"zhou" andLastName:@"yu" andPhoneNumber:@"13811196174"];
    Contact *contact9 = [Contact initWithFirstName:@"zhao" andLastName:@"zilong" andPhoneNumber:@"13811196175"];
    Contact *contact10 = [Contact initWithFirstName:@"zhao" andLastName:@"pu" andPhoneNumber:@"13811196176"];
    ContactGroup *group3 = [ContactGroup initWIthName:@"Z" andDetail:@"name begin with Z" andContacts:[NSMutableArray arrayWithObjects:contact6, contact7, contact8, contact9, contact10, nil]];
    [_contacts addObject:group3];
    
    Contact *contact11 = [Contact initWithFirstName:@"li" andLastName:@"shimin" andPhoneNumber:@"13811196177"];
    Contact *contact12 = [Contact initWithFirstName:@"li" andLastName:@"yuanji" andPhoneNumber:@"13811196178"];
    Contact *contact13 = [Contact initWithFirstName:@"liu" andLastName:@"bei" andPhoneNumber:@"13811196179"];
    Contact *contact14 = [Contact initWithFirstName:@"liu" andLastName:@"hulan" andPhoneNumber:@"13811196180"];
    Contact *contact15 = [Contact initWithFirstName:@"liang" andLastName:@"youliang" andPhoneNumber:@"13811196181"];
    ContactGroup *group4 = [ContactGroup initWIthName:@"L" andDetail:@"name begin with L" andContacts:[NSMutableArray arrayWithObjects:contact11, contact12, contact13, contact14, contact15, nil]];
    [_contacts addObject:group4];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isSearching){
        return 1;
    }
    return _contacts.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isSearching){
        return _searchContacts.count;
    }
    ContactGroup *group = _contacts[section];
    return group.contacts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Contact *contact = nil;
    
    if(_isSearching){
        contact = _searchContacts[indexPath.row];
    } else {
        ContactGroup *group = _contacts[indexPath.section];
        contact = group.contacts[indexPath.row];
    }
    
    //由于此方法调用非常频繁，声明为static更有利于性能优化
    static NSString *cellIdentifier = @"UITableViewIdentifier";
    static NSString *cellIdentifierForFirstRow = @"UITableViewIdentifierForFirstRow";
    UITableViewCell *cell = nil;
    if(indexPath.row == 0 && !_isSearching){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForFirstRow];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierForFirstRow];
            
            UISwitch *sw = [[UISwitch alloc] init];
            [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sw;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
        }
    }
    
    cell.textLabel.text = [contact getName];
    cell.detailTextLabel.text = contact.phoneNumber;
    NSLog(@"cell:%@", cell);
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_isSearching){
        return @"搜索结果";
    } else {
        ContactGroup *group = _contacts[section];
        return group.name;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(_isSearching)
        return nil;
    else {
        ContactGroup *group = _contacts[section];
        return group.detail;
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(_isSearching){
        return nil;
    } else {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for(ContactGroup *group in _contacts){
            [array addObject:group.name];
        }
        return array;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 50;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

//点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    Contact *contact = nil;
    if(_isSearching){
        contact = _searchContacts[indexPath.row];
    } else {
        ContactGroup *group = _contacts[indexPath.section];
        contact = group.contacts[indexPath.row];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"system info" message:[contact getName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = contact.phoneNumber;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        
        Contact *contact = nil;
        if(_isSearching){
            contact = _searchContacts[_indexPath.row];
        } else {
            ContactGroup *group = _contacts[_indexPath.section];
            contact = group.contacts[_indexPath.row];
        }
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        contact.phoneNumber = textField.text;
//        [_tableView reloadData];
        
        NSArray *indexPaths = @[_indexPath];
        [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        
    }
}

-(void)switchValueChanged:(UISwitch *)sw{
    NSLog(@"SwitchValueChange");
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isSearching){
        return;
    }
    
    ContactGroup *group = _contacts[_indexPath.section];
    Contact *contact = group.contacts[_indexPath.row];
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [group.contacts removeObject:contact];
        
        //考虑到性能这里不建议使用reloadData
        //[tableView reloadData];
        //使用下面的方法既可以局部刷新又有动画效果
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        //如果当前组中没有数据则移除组刷新整个表格
        if(group.contacts.count == 0){
            [_contacts removeObject:group];
            [tableView reloadData];
        }
    } else if(editingStyle == UITableViewCellEditingStyleInsert){
        Contact *newContact = [Contact initWithFirstName:@"first" andLastName:@"last" andPhoneNumber:@"123456789"];
        [group.contacts insertObject:newContact atIndex:indexPath.row];
        
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if(_isSearching) return;
    ContactGroup *sourceGroup = _contacts[sourceIndexPath.section];
    ContactGroup *destGroup = _contacts[destinationIndexPath.section];
    
    Contact *sourceContact = sourceGroup.contacts[sourceIndexPath.row];
    [sourceGroup.contacts removeObject:sourceContact];
    [destGroup.contacts insertObject:sourceContact atIndex:destinationIndexPath.row];
    
    //如果当前组中没有数据则移除组刷新整个表格
    if(sourceGroup.contacts.count == 0){
        [_contacts removeObject:sourceGroup];
        [tableView reloadData];
    }

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_isSearching)
        return UITableViewCellEditingStyleNone;
    else if(isInsert){
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     _searchBar.text=@"";
    [self cancelSearch];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self doSearch];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self doSearch];
    //放弃第一响应者对象，关闭虚拟键盘
    [_searchBar resignFirstResponder];
}

-(void)doSearch{
    if([_searchBar.text isEqual:@""]){
        [self cancelSearch];
    } else {
        [self searchWithKeyWord:_searchBar.text];
    }
}

-(void)searchWithKeyWord:(NSString *)keyword{
    _isSearching = YES;
    _searchContacts = [NSMutableArray new];
    [_contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ContactGroup *group = obj;
        [group.contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Contact * contact = obj;
            if([contact.firstName.uppercaseString containsString:keyword.uppercaseString] || [contact.lastName.uppercaseString containsString:keyword.uppercaseString] || [contact.phoneNumber.uppercaseString containsString:keyword.uppercaseString]){
                [_searchContacts addObject:contact];
            }
        }];
    }];
    
    [_tableView reloadData];
}

-(void)cancelSearch{
    _isSearching = NO;
    [_searchContacts removeAllObjects];
    [_tableView reloadData];
}

- (IBAction)loadImage:(id)sender {
}
@end