//
//  DropDownMenuManager.h
//  DropDownMenu
//
//  Created by 胡焘坤 on 2017/9/26.
//  Copyright © 2017年 htk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownMenuManager : NSObject

@property (nonatomic, retain) id<UITableViewDelegate,UITableViewDataSource> tableViewDelegate;

-(void)showDropDownMenuWithTargetView:(UIView*)targetView;
-(void)dismissDropDownMenu;
@end
