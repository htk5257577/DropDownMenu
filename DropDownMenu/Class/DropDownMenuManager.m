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

@interface DropDownMenuManager ()<UIGestureRecognizerDelegate>
@property (nonatomic, retain) UIView *targetView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *coverView;
@end

@implementation DropDownMenuManager


-(instancetype)initWithView:(UIView*)view{
    if ([super init]) {
        _targetView = view;
        
    }
    return self;
}

-(void)showDropDownMenu{
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.coverView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.coverView addGestureRecognizer:tap];
    tap.delegate = self;
    
    CGRect rect=[self.targetView convertRect:self.targetView.bounds toView:window];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, 0) style:UITableViewStylePlain];
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
    [self.coverView addSubview:self.tableView];

    [UIView animateWithDuration:AnimationContant animations:^{
        self.tableView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, [self caculateTableViewHeight:rect]);
    }];
}


-(NSInteger)caculateTableViewHeight:(CGRect)rect{
    NSInteger screenMaxHeight = [UIScreen mainScreen].bounds.size.height - (rect.origin.y + rect.size.height) - 20;
    NSInteger actualMaxHeight = screenMaxHeight < MaxHeight ? screenMaxHeight : MaxHeight;
    NSInteger totalHeight = [self.tableViewDelegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] * [self.tableViewDelegate tableView:self.tableView numberOfRowsInSection:0];

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
@end
