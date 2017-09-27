//
//  ViewController.m
//  DropDownMenu
//
//  Created by 胡焘坤 on 2017/9/25.
//  Copyright © 2017年 htk. All rights reserved.
//

#import "ViewController.h"
#import "DropDownMenuManager.h"


@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, retain)NSArray * dataSource;
@property (nonatomic, retain)NSArray * dataSource2;
@property (nonatomic, retain)DropDownMenuManager *manager;
@end

@implementation ViewController


-(DropDownMenuManager *)manager{
    if (!_manager) {
        _manager = [[DropDownMenuManager alloc] init];
    }
    return _manager;
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"];
    }
    return _dataSource;
}

-(NSArray *)dataSource2{
    if (!_dataSource2) {
        _dataSource2 = @[@"上海",@"北京",@"杭州",@"武汉"];
    }
    return _dataSource2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
}

- (IBAction)onButtonClick:(UIButton *)button {
    self.manager.dataSource = self.dataSource;
    [self.manager showDropDownMenuWithTargetView:button];
    self.manager.cellDidSelectBlock = ^(NSArray *dataSource, NSInteger row) {
        [button setTitle:dataSource[row] forState:UIControlStateNormal];
    };
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.manager.dataSource = self.dataSource2;
    [self.manager showDropDownMenuWithTargetView:textField];
    self.manager.cellDidSelectBlock = ^(NSArray *dataSource, NSInteger row) {
        textField.text = dataSource[row];
    };
    return NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end
