//
//  YXSelectItem.m
//  ParkProject
//
//  Created by yuanxuan on 2017/2/6.
//  Copyright © 2017年 yuanxuan. All rights reserved.
//

#import "YXSelectItem.h"

#define DEFAULT_TITLE_FONTSIZE 14
#define DEFAULT_TITLE_SELECTED_FONTSIZE 15
#define DEFAULT_TITLE_COLOR [UIColor blackColor]
#define DEFAULT_TITLE_SELECTED_COLOR [UIColor orangeColor]

#define HORIZONTAL_MARGIN 5
@interface YXSelectItem ()

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat selectedFontSize;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *selectedColor;

@end

@implementation YXSelectItem

#pragma mark - Lifecircle

- (instancetype) init {
    if (self = [super init]) {
        _fontSize = DEFAULT_TITLE_FONTSIZE;
        _selectedFontSize = DEFAULT_TITLE_SELECTED_FONTSIZE;
        _color = DEFAULT_TITLE_COLOR;
        _selectedColor = DEFAULT_TITLE_SELECTED_COLOR;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect {
//    CGFloat titleX = (CGRectGetWidth(self.frame) - [self titleSize].width) * 0.5;
//    CGFloat titleY = (CGRectGetHeight(self.frame) - [self titleSize].height) * 0.5;
//    
//    CGRect titleRect = CGRectMake(titleX, titleY, [self titleSize].width, [self titleSize].height);
//    NSDictionary *attributes = @{NSFontAttributeName : [self titleFont], NSForegroundColorAttributeName : [self titleColor]};
//    [_title drawInRect:titleRect withAttributes:attributes];
//}

#pragma mark - Custom Accessors

//- (void)setSelected:(BOOL)selected {
//    _selected = selected;
//    [self setNeedsDisplay];
//}

#pragma mark - Public

- (void)setItemTitle:(NSString *)title {
    _title = title;
    [self setTitle:_title forState:UIControlStateNormal];
    [self setTitle:_title forState:UIControlStateHighlighted];
    [self setTitle:_title forState:UIControlStateSelected];
    [self setNeedsDisplay];
}

- (NSString *)getitemTitle{
    return _title;
}

- (void)setItemDisableTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateDisabled];

}

- (void)setItemTitleFont:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:_fontSize];
    [self setNeedsDisplay];
}

- (void)setItemSelectedTileFont:(CGFloat)fontSize {
    _selectedFontSize = fontSize;
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Oblique" size:_selectedFontSize];
    [self setNeedsDisplay];
}

- (void)setItemTitleColor:(UIColor *)color {
    _color = color;
    [self setTitleColor:_color forState:UIControlStateNormal];
    [self setTitleColor:_color forState:UIControlStateHighlighted];
    [self setNeedsDisplay];
}

- (void)setItemSelectedTitleColor:(UIColor *)color {
    _selectedColor = color;
    [self setTitleColor:_selectedColor forState:UIControlStateSelected];
    [self setNeedsDisplay];
}

#pragma mark - Private

- (CGSize)titleSize {
    NSDictionary *attributes = @{NSFontAttributeName : [self titleFont]};
    CGSize size = [_title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

- (UIFont *)titleFont {
    UIFont *font;
    if (self.selected) {
        font = [UIFont fontWithName:@"Avenir-Oblique" size:_selectedFontSize];
    } else {
        font = [UIFont fontWithName:@"Avenir-Light" size:_fontSize];
    }
    return font;
}

- (UIColor *)titleColor {
    UIColor *color;
    if (self.selected) {
        color = _selectedColor;
    } else {
        color = _color;
    }
    return color;
}

#pragma mark - Public Class Method

+ (CGFloat)widthForTitle:(NSString *)title {
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Light" size:DEFAULT_TITLE_FONTSIZE]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width) + HORIZONTAL_MARGIN * 2;
    
    return size.width;
}

//#pragma mark - Responder
//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectItemSelected:)]) {
        [self.delegate selectItemSelected:self];
    }
}


@end
