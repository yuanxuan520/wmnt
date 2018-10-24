//
//  SetPopNumTextView.h
//  wmnt
//
//  Created by yuanxuan on 2018/10/23.
//  Copyright © 2018 wmnt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetNumText)(NSString *numText);
@interface SetPopNumTextView : UIScrollView
- (void)show:(UIView *)view setTitle:(NSString *)title setSetNumText:(SetNumText )setNumText;
@end
