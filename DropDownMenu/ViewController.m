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
@property (nonatomic, retain)DropDownMenuManager *manager2;
@end

@implementation ViewController


-(DropDownMenuManager *)manager{
    if (!_manager) {
        _manager = [[DropDownMenuManager alloc] initWithMode:Single dataSource:self.dataSource];
    }
    return _manager;
}

-(DropDownMenuManager *)manager2{
    if (!_manager2) {
        _manager2 = [[DropDownMenuManager alloc] initWithMode:Mutiple dataSource:self.dataSource2];
    }
    return _manager2;
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
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
    self.manager.cellDidSelectBlock = ^(NSArray *dataSource, NSInteger selectIndex, NSArray<NSNumber *>* selectIndexArray) {
        [button setTitle:dataSource[selectIndex] forState:UIControlStateNormal];
    };
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.manager2.dataSource = self.dataSource2;
    [self.manager2 showDropDownMenuWithTargetView:textField];
    self.manager2.cellDidSelectBlock = ^(NSArray *dataSource, NSInteger selectIndex, NSArray<NSNumber *>* selectIndexArray) {
        textField.text = nil;
        for (NSNumber *selectIndex in selectIndexArray) {
            textField.text = [textField.text stringByAppendingString:dataSource[selectIndex.integerValue]];
        }
        
    };
    return NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end
