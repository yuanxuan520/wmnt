//
//  SetPopTextView.m
//  ParkProject
//
//  Created by yuanxuan on 2018/7/5.
//  Copyright © 2018年 yuanxuan. All rights reserved.
//

#import "SetPopTextView.h"
#import "UIPlaceHolderTextView.h"

@interface SetPopTextView()<UITextViewDelegate>
@property (nonatomic, copy) SetText setText;
//标题显示:
@property (nonatomic, strong) UILabel *titleLabel;

//文本输入
@property (nonatomic, strong) UIPlaceHolderTextView *completionTextView;

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *showView;

@property (nonatomic, strong) NSString *title;
@end

@implementation SetPopTextView
@synthesize titleLabel,saveBtn,completionTextView,closeBtn;
@synthesize backView,showView;
- (void)show:(UIView *)view setTitle:(NSString *)title setSetText:(SetText)setText
{
    self.frame = view.frame;
    self.alpha = 0.0f;
    self.title = title;
    self.setText = setText;
    [self createView];
    [view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0f;
        self.showView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2.5);
    } completion:^(BOOL finished) {
        [self.completionTextView becomeFirstResponder];
    }];
}

- (void)createView
{
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    backView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [backView addGestureRecognizer:tap];
    
    showView = [[UIView alloc] init];
    showView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    showView.frame = CGRectMake(0, 0, self.bounds.size.width-60, self.bounds.size.height/3);
    showView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height);
    showView.layer.shadowOpacity = 0.1;
    showView.layer.shadowColor = [UIColor blackColor].CGColor;
    showView.layer.shadowRadius = 10;
    showView.layer.cornerRadius = 3;
    showView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:showView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(showView.frame) -40, 25)];
    titleLabel.textColor = [UIColor colorFromHexRGB:@"303133"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 1;
    titleLabel.text = self.title;
    titleLabel.font = SystemFoldFont(16);
    [self.showView addSubview:titleLabel];
    
    completionTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(titleLabel.frame)+10, CGRectGetWidth(showView.frame)-40, CGRectGetHeight(showView.frame) - 110)];
    completionTextView.textColor = [UIColor colorFromHexRGB:@"494949"];
    completionTextView.placeholder = @"请输入内容";
    completionTextView.delegate = self;
    //    completionTextView.hidden = YES;
    completionTextView.layer.borderWidth = 1;
    completionTextView.layer.borderColor = [UIColor colorFromHexRGB:@"dcdfe6"].CGColor;
    completionTextView.layer.cornerRadius = 5;
    completionTextView.contentInset = UIEdgeInsetsMake(0, 5, 5, 5);
    completionTextView.keyboardType = UIKeyboardTypeDefault;
    completionTextView.font = SystemFont(15);
    [completionTextView.layer setMasksToBounds:YES];
    completionTextView.returnKeyType = UIReturnKeyDone;
    [self.showView addSubview:completionTextView];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(CGRectGetWidth(showView.frame)-100, CGRectGetHeight(showView.frame)-50, 80, 40);
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.clipsToBounds = YES;
    saveBtn.layer.cornerRadius = 8;
    [saveBtn setBackgroundImage:[self imageWithColor:[UIColor colorFromHexRGB:@"46a0fc"] size:saveBtn.bounds.size] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:saveBtn];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeBtn.frame = CGRectMake(CGRectGetWidth(showView.frame)-190, CGRectGetHeight(showView.frame)-50, 80, 40);
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorFromHexRGB:@"606265"] forState:UIControlStateNormal];
    closeBtn.layer.borderColor = [UIColor colorFromHexRGB:@"dcdfe6"].CGColor;
    closeBtn.layer.borderWidth = 1;
    closeBtn.layer.cornerRadius = 8;
    closeBtn.clipsToBounds = YES;
    [closeBtn setBackgroundImage:[self imageWithColor:[UIColor colorFromHexRGB:@"ffffff"] size:closeBtn.bounds.size] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:closeBtn];
}

- (void)closeView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)saveContent:(UIButton *)btn
{
    if ([self.completionTextView.text isEqualToString:@""]) {
        [WSProgressHUD showShimmeringString:@"填写内容不能为空!" maskType:WSProgressHUDMaskTypeBlack];
        [WSProgressHUD autoDismiss:2];
        return;
    }
    if (self.setText) {
        self.setText(self.completionTextView.text);
    }
    [self closeView];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    [UIView animateWithDuration:0.3 animations:^{
        textField.layer.borderWidth = 2;
    } completion:^(BOOL finished) {
    }];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        textField.layer.borderWidth = 0;
    } completion:^(BOOL finished) {
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
