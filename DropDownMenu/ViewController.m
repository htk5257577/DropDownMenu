//
//  ViewController.m
//  DropDownMenu
//
//  Created by 胡焘坤 on 2017/9/25.
//  Copyright © 2017年 htk. All rights reserved.
//

#import "ViewController.h"
#import "DropDownMenuManager.h"


@interface ViewController ()<UITableViewDelegate ,UITableViewDataSource>;

@property (nonatomic, retain)NSArray * dataSource;
@property (nonatomic, retain)DropDownMenuManager *manager;
@end

@implementation ViewController


-(DropDownMenuManager *)manager{
    if (!_manager) {
        _manager = [[DropDownMenuManager alloc] initWithView:self.button];
        _manager.tableViewDelegate = self;
    }
    return _manager;
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onButtonClick:(UIButton *)button {
    [self.manager showDropDownMenu];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.button setTitle:self.dataSource[indexPath.row] forState:UIControlStateNormal];
    [self.manager dismissDropDownMenu];
}






@end
