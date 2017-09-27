//
//  DropDownMenuManager.h
//  DropDownMenu
//
//  Created by 胡焘坤 on 2017/9/26.
//  Copyright © 2017年 htk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownMenuManager : NSObject
@property (nonatomic, retain) NSArray *dataSource;


/**
  tableViewCell选中回调，dataSource为tableView当前的数据源，row为tableView当前选中的行号
 */
@property (nonatomic ,copy) void (^cellDidSelectBlock) (NSArray *dataSource, NSInteger row);


/**
 tableViewCell样式回调，dataSource为tableView当前的数据源，row为tableView需要赋予样式的的行号
 (若想自定义cell样式以及内容则给此block赋值，否则无需赋值以显示默认样式)
 */
@property (nonatomic ,copy) UITableViewCell * (^cellForRowBlock) (NSArray *dataSource, NSInteger row);



-(void)showDropDownMenuWithTargetView:(UIView*)targetView;
@end
