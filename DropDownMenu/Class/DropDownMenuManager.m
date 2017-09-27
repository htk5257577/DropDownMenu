//
//  DropDownMenuManager.m
//  DropDownMenu
//
//  Created by 胡焘坤 on 2017/9/26.
//  Copyright © 2017年 htk. All rights reserved.
//

#import "DropDownMenuManager.h"

static double AnimationContant = 0.3;
static NSInteger MaxHeight = 400;
static NSInteger CellHeight = 40;
static NSString *CellIdentifier = @"DefalutCell";

@interface DropDownMenuManager ()<UIGestureRecognizerDelegate,UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, retain) UIView *targetView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, retain) NSMutableArray *selectIndexArray;
@property (nonatomic, assign) Mode mode;
@end

@implementation DropDownMenuManager

-(instancetype)initWithMode:(Mode)mode dataSource:(NSArray*)dataSource{
    if ([super init]) {
        _mode = mode;
        _dataSource = dataSource;
    }
    return self;
}

-(NSMutableArray *)selectIndexArray{
    if (!_selectIndexArray) {
        _selectIndexArray = [NSMutableArray array];
    }
    return _selectIndexArray;
}

-(void)selectCellIndex:(NSInteger)row{
    if (self.mode == Single) {
        self.selectIndex = row;
        [self dismissDropDownMenu];
    }else{
        if ([self.selectIndexArray containsObject:[NSNumber numberWithInteger:row]]) {
            [self.selectIndexArray removeObject:[NSNumber numberWithInteger:row]];
        }else{
            [self.selectIndexArray addObject:[NSNumber numberWithInteger:row]];
        }
    }
    [self.tableView reloadData];
}

-(BOOL)isRowSelected:(NSInteger)row{
    if (self.mode == Single) {
        if (self.selectIndex == row) {
            return YES;
        }
    }else{
        if ([self.selectIndexArray containsObject:[NSNumber numberWithInteger:row]]) {
            return YES;
        }
    }
    return NO;
}

-(void)showDropDownMenuWithTargetView:(UIView*)targetView{
    self.targetView = targetView;
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.coverView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.coverView addGestureRecognizer:tap];
    tap.delegate = self;
    
    CGRect rect=[targetView convertRect:targetView.bounds toView:window];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, 0) style:UITableViewStylePlain];
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.coverView addSubview:self.tableView];

    [UIView animateWithDuration:AnimationContant animations:^{
        self.tableView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, [self caculateTableViewHeight:rect]);
    }];
}


-(NSInteger)caculateTableViewHeight:(CGRect)rect{
    NSInteger screenMaxHeight = [UIScreen mainScreen].bounds.size.height - (rect.origin.y + rect.size.height) - 20;
    NSInteger actualMaxHeight = screenMaxHeight < MaxHeight ? screenMaxHeight : MaxHeight;
    NSInteger totalHeight = CellHeight * self.dataSource.count;

    return totalHeight < actualMaxHeight ? totalHeight : actualMaxHeight;
}

-(void)tap:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self dismissDropDownMenu];
}

-(void)dismissDropDownMenu{
    [self.coverView removeFromSuperview];
    self.coverView = nil;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (self.cellForRowBlock) {
        cell = self.cellForRowBlock(self.dataSource, indexPath.row);
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    }
    if ([self isRowSelected:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectCellIndex:indexPath.row];
    if (self.cellDidSelectBlock) {
        self.cellDidSelectBlock(self.dataSource, self.selectIndex, self.selectIndexArray);
    }
    
}

@end
