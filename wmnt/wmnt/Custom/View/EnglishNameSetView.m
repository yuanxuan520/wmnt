//
//  EnglishNameSetView.m
//  Manly Student
//
//  Created by yuanxuan on 2018/4/23.
//  Copyright © 2018年 topflames. All rights reserved.
//

#import "EnglishNameSetView.h"
#define SURLFONTSIZE 18

@interface EnglishNameSetView()<UITextFieldDelegate>
@property (nonatomic, copy) SetFirstLastName setName;
//标题显示:
@property (nonatomic, strong) UILabel *titleLabel;

//英文名
@property (nonatomic, strong) UITextField *firstNameTextField;
@property (nonatomic, strong) UITextField *lastNameTextField;

@property (nonatomic, strong) UIButton *saveBtn;

//其他地址
//@property (strong, nonatomic) UIVisualEffectView *backView;
@property (strong, nonatomic) UIView *backView;

@property (strong, nonatomic) UIView *showView;

@end

@implementation EnglishNameSetView
@synthesize titleLabel,saveBtn,firstNameTextField,lastNameTextField;
@synthesize backView,showView;
- (void)show:(UIView *)view setFirstLastName:(SetFirstLastName )setName
{
    self.frame = view.frame;
    self.alpha = 0.0f;
    self.setName = setName;
    [self createView];
    [view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0f;
        showView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2.5);
    } completion:^(BOOL finished) {
        [lastNameTextField becomeFirstResponder];
    }];
}

- (void)createView
{
    //    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    backView = [[UIVisualEffectView alloc] initWithEffect:blur];
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    backView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:backView];
    
    
    showView = [[UIView alloc] init];
    showView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    showView.frame = CGRectMake(0, 0, self.bounds.size.width-60, self.bounds.size.height/2);
    showView.center = CGPointMake(self.bounds.size.width/2, -(self.bounds.size.height/2));
    showView.layer.shadowOpacity = 0.1;
    showView.layer.shadowColor = [UIColor blackColor].CGColor;
    showView.layer.shadowRadius = 10;
    showView.layer.cornerRadius = 10;
    showView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:showView];
    //    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    backbtn.frame = CGRectMake(self.bounds.size.width-50, 20, 50, 44);
    //    backbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    backbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [backbtn setImage:[UIImage imageNamed:@"pp_zs_close"] forState:UIControlStateNormal];
    //    [backbtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    //    backbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    //    [self addSubview:backbtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(showView.frame) -40, 60)];
    titleLabel.textColor = UIColorHex(0xb327e0);
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.text = [NSString stringWithFormat:@"设置显示名称"];
    titleLabel.font = SystemFont(SURLFONTSIZE);
    [self.showView addSubview:titleLabel];
    
    UILabel *lastNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(titleLabel.frame)+20, CGRectGetWidth(showView.frame)-40, 20)];
    lastNamelabel.font = SystemFoldFont(16);
    lastNamelabel.text = @"姓";
    [self.showView addSubview:lastNamelabel];
    
    self.lastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lastNamelabel.frame)+5, CGRectGetWidth(showView.frame)-40, 44)];
    lastNameTextField.placeholder = @"请输入拼音字母";
    UIColor *lastColor = [UIColor colorWithWhite:0.8 alpha:1];
    [lastNameTextField setValue:lastColor forKeyPath:@"_placeholderLabel.textColor"];
    lastNameTextField.textColor = [UIColor blackColor];
    lastNameTextField.text = @"";
    lastNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    lastNameTextField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    lastNameTextField.delegate = self;
    lastNameTextField.tag = 102;
    lastNameTextField.returnKeyType = UIReturnKeyDone;
//    [lastNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [lastNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    lastNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    lastNameTextField.font = SystemFont(16);
    
    UIView *left1View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    left1View.backgroundColor = [UIColor whiteColor];
    lastNameTextField.leftView = left1View;
    lastNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    lastNameTextField.font = SystemFont(16);
    lastNameTextField.layer.borderColor = UIColorHexAndAlpha(0xb327e0, 0.2).CGColor;
    lastNameTextField.layer.cornerRadius = 5;
    
    [self.showView addSubview:lastNameTextField];
    
//    UIView *lastlineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(lastNameTextField.frame)-0.5, CGRectGetWidth(firstNameTextField.frame), 0.5)];
//    lastlineView.backgroundColor = [UIColor whiteColor];
//    [lastNameTextField addSubview:lastlineView];
    
    //
    
    UILabel *firstNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(lastNameTextField.frame)+20, CGRectGetWidth(showView.frame)-40, 20)];
    firstNamelabel.font = SystemFoldFont(16);
    firstNamelabel.text = @"名";
    [self.showView addSubview:firstNamelabel];
    
    self.firstNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstNamelabel.frame)+5, CGRectGetWidth(showView.frame)-40, 44)];
    firstNameTextField.placeholder = @"请输入拼音字母";
    UIColor *firstColor = [UIColor colorWithWhite:0.8 alpha:1];
    [firstNameTextField setValue:firstColor forKeyPath:@"_placeholderLabel.textColor"];
    firstNameTextField.textColor = [UIColor blackColor];
    firstNameTextField.text = @"";
    firstNameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    firstNameTextField.delegate = self;
    firstNameTextField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    firstNameTextField.tag = 102;
    firstNameTextField.returnKeyType = UIReturnKeyDone;
//    [firstNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [firstNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    firstNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    leftView.backgroundColor = [UIColor whiteColor];
    firstNameTextField.leftView = leftView;
    firstNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    firstNameTextField.font = SystemFont(16);
    firstNameTextField.layer.borderColor = UIColorHexAndAlpha(0xb327e0,0.2).CGColor;
    firstNameTextField.layer.cornerRadius = 5;
    [self.showView addSubview:firstNameTextField];
//    UIView *firstlineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(firstNameTextField.frame)-0.5, CGRectGetWidth(firstNameTextField.frame), 0.5)];
//    firstlineView.backgroundColor = [UIColor whiteColor];
//    [firstNameTextField addSubview:firstlineView];
    
    
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(0, CGRectGetHeight(showView.frame)-60, CGRectGetWidth(showView.frame), 40);
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:UIColorHexAndAlpha(0xb327e0,0.2) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:saveBtn];
}

- (void)closeView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)saveName:(UIButton *)btn
{
    if (self.setName) {
        self.setName(self.firstNameTextField.text, self.lastNameTextField.text);
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
