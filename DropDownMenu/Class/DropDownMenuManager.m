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
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, retain) UIView *targetView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, retain) NSMutableArray *selectIndexArray;
@property (nonatomic, assign) Mode mode;
@property (nonatomic, assign) BOOL isShow;
@end

@implementation DropDownMenuManager

-(instancetype)initWithMode:(Mode)mode dataSource:(NSArray*)dataSource{
    if ([super init]) {
        _mode = mode;
        _dataSource = dataSource;
        _checkMark = YES;
        _isShow = NO;
    }
    return self;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.layer.borderWidth = 1;
        _tableView.layer.cornerRadius = 5;
    }
    return _tableView;
}

-(NSMutableArray *)selectIndexArray{
    if (!_selectIndexArray) {
        _selectIndexArray = [NSMutableArray array];
    }
    return _selectIndexArray;
}

-(void)setDataSource:(NSArray *)dataSource{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource= dataSource;
    [self resetSelectState];
}

-(void)resetSelectState{
    if (self.mode == DropDownMenuSingle) {
        self.selectIndex = -1;
    }else{
        [self.selectIndexArray removeAllObjects];
    }
    [self.tableView reloadData];
}

-(void)selectCellIndex:(NSInteger)row{
    if (self.mode == DropDownMenuSingle) {
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
    if (self.mode == DropDownMenuSingle) {
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
    if (self.dataSource.count > 0 && !self.isShow) {
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.coverView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.coverView addGestureRecognizer:tap];
        tap.delegate = self;
        
        CGRect rect=[targetView convertRect:targetView.bounds toView:window];
        self.tableView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, 0);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.layer.borderColor = self.targetView.layer.borderColor;
        [self.coverView addSubview:self.tableView];
        
        [UIView animateWithDuration:AnimationContant animations:^{
            self.tableView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, [self caculateTableViewHeight:rect]);
        }];
        self.isShow = YES;
    }
    [self.tableView reloadData];
    
    
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
    if (self.isShow) {
        [self.coverView removeFromSuperview];
        self.coverView = nil;
        self.isShow = NO;
    }
    
}

- (UIFont*)fontOfView:(UIView *)view{
    if ([view isMemberOfClass:[UILabel class]]) {
        return ((UILabel *)view).font;
    }else if([view isMemberOfClass:[UITextField class]]){
        return ((UITextField *)view).font;
    }else if([view isMemberOfClass:[UIButton class]]){
        return ((UIButton *)view).titleLabel.font;
    }else{
        return [UIFont systemFontOfSize:15];
    }
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
        cell.textLabel.textColor = [UIColor colorWithCGColor:self.targetView.layer.borderColor];
        cell.textLabel.font = [self fontOfView:self.targetView];
    }
    
    if (self.checkMark) {
        if ([self isRowSelected:indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
