//
//  SelectPersonViewController.h
//  wmnt
//
//  Created by yuanxuan on 2018/10/22.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import "YXViewController.h"

typedef void(^UserMultiSelect)(NSMutableArray *selectedlist);
@interface SelectUserViewController : YXViewController
@property (nonatomic, copy) UserMultiSelect userMultiSelect;
@end
