//
//  DropDownMenuManager.h
//  DropDownMenu
//
//  Created by 胡焘坤 on 2017/9/26.
//  Copyright © 2017年 htk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Mode)
{
    DropDownMenuSingle = 0,
    DropDownMenuMutiple
};

@interface DropDownMenuManager : NSObject
@property (nonatomic, retain) NSArray *dataSource;


/**
 可以设置tableView的样式 包括borderColor borderWith cornerRadius等
 */
@property (nonatomic, retain) UITableView *tableView;


/**
 是否需要cell选中标记 默认为YES
 */
@property (nonatomic, assign) BOOL checkMark;
/**
  tableViewCell选中回调，dataSource为tableView当前的数据源，单选模式下selectIndex为tableView当前选中的行号，多选模式下selectIndexArray为tableView当前选中的行号数组
 */
@property (nonatomic ,copy) void (^cellDidSelectBlock) (NSArray *dataSource, NSInteger selectIndex, NSArray<NSNumber *>* selectIndexArray);


/**
 tableViewCell样式回调，dataSource为tableView当前的数据源，row为tableView需要赋予样式的的行号
 (若想自定义cell样式以及内容则给此block赋值，否则无需赋值以显示默认样式)
 */
@property (nonatomic ,copy) UITableViewCell * (^cellForRowBlock) (NSArray *dataSource, NSInteger row);


-(instancetype)initWithMode:(Mode)mode dataSource:(NSArray*)dataSource;

-(void)showDropDownMenuWithTargetView:(UIView*)targetView;
@end
