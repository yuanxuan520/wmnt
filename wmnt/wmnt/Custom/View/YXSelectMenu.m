//
//  YXSelectMenu.m
//  ParkProject
//
//  Created by yuanxuan on 2017/2/4.
//  Copyright © 2017年 yuanxuan. All rights reserved.
//

#import "YXSelectMenu.h"
#import "YXSelectItem.h"

#define DEVICE_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define DEFAULT_SLIDER_COLOR [UIColor orangeColor]
#define SLIDER_VIEW_HEIGHT 1

@interface YXSelectMenu ()<YXSelectItemDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIView *sliderView;
@property (strong, nonatomic) UIView *linelabel;

@property (strong, nonatomic) YXSelectItem *selectedItem;
@property (strong, nonatomic) YXSelectMenuItemSelectedCallback callback;

@end

@implementation YXSelectMenu

#pragma mark - Lifecircle

- (instancetype)init {
    self.selectType = kSelectLandscapeType;
    CGRect frame = CGRectMake(0, 0, DEVICE_WIDTH, 44);
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _items = [NSMutableArray array];
        self.clipsToBounds = YES;
        [self initScrollView];
        [self initSliderView];
        [self initlineView];
    }
    return self;
}

#pragma - mark Custom Accessors
//
//- (void)setItemsTitles:(NSArray *)itemsTitles {
//    _itemsTitles = itemsTitles;
//    [self setupTitlesItems];
//}
//
//
- (void)setItemColor:(UIColor *)itemColor {
    for (YXSelectItem *item in _items) {
        [item setItemTitleColor:itemColor];
    }
}
//
- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    for (YXSelectItem *item in _items) {
        [item setItemSelectedTitleColor:itemSelectedColor];
    }
}
//
- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = _sliderColor;
}
//
- (void)setSelectedItem:(YXSelectItem *)selectedItem {
    _selectedItem.selected = NO;
    _selectedItem = selectedItem;
}


#pragma - mark Private

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.clipsToBounds = NO;
    [self addSubview:_scrollView];
}
//
- (void)initSliderView {
    _sliderView = [[UIView alloc] init];
    _sliderColor = DEFAULT_SLIDER_COLOR;
    _sliderView.backgroundColor = _sliderColor;
    [_scrollView addSubview:_sliderView];
}
//
- (void)initlineView
{
    _linelabel = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    _linelabel.backgroundColor = UIColorHex(0xf0f0f0);
    [self addSubview:_linelabel];
}
//
//- (void)setupTitlesItems {

    //横向
//    CGFloat itemX = 0;
//    for (NSInteger i = 0; i < [_itemsTitles count] ; i ++) {
//        NSString *title = [_itemsTitles objectAtIndex:i];
//        
//        FDSlideBarItem *item = [[FDSlideBarItem alloc] init];
//        item.delegate = self;
//        // Init the current item's frame
//        CGFloat itemW = _scrollView.bounds.size.width/[_itemsTitles count];
//        //        [FDSlideBarItem widthForTitle:title];
//        item.frame = CGRectMake(itemX, 0, itemW, _scrollView.bounds.size.height);
//        [item setItemTitle:title];
//        [_items addObject:item];
//        
//        [_scrollView addSubview:item];
//        
//        // Caculate the origin.x of the next item
//        itemX = CGRectGetMaxX(item.frame);
//    }
//    
//    // Cculate the scrollView 's contentSize by all the items
//    _scrollView.contentSize = CGSizeMake(itemX, CGRectGetHeight(_scrollView.frame));
//    
//    // Set the default selected item, the first item
//    FDSlideBarItem *firstItem = [self.items firstObject];
//    firstItem.selected = YES;
//    _selectedItem = firstItem;
//    
//    // Set the frame of sliderView by the selected item //self.frame.size.height - SLIDER_VIEW_HEIGHT
//    //
//    CGFloat firsttitleW = [FDSlideBarItem widthForTitle:[_selectedItem getitemTitle]];
//    CGFloat firstLocation = (_selectedItem.bounds.size.width - firsttitleW)/2;
//    
//    _sliderView.frame = CGRectMake(firstLocation, firstItem.frame.size.height - 3, firsttitleW, SLIDER_VIEW_HEIGHT);
//}

- (void)createView
{
    [self setupItems];
}
//创建按钮 及相关的箭头
- (void)setupItems {
    CGFloat itemX = 0;
    for (int i = 0; i < [self.dataList count]; i++) {
        NSDictionary *itemsInfo = [self.dataList objectAtIndex:i];
        NSString *title = [itemsInfo objectForKey:@"Name"];
        BOOL itemEnable = [[itemsInfo objectForKey:@"Enable"] boolValue];
//        NSDictionary *iteminfo = [itemsInfo objectForKey:@"Datadetail"];
        
        YXSelectItem *item = [[YXSelectItem alloc] init];
        item.delegate = self;
        
        // Init the current item's frame
        CGFloat itemW = [YXSelectItem widthForTitle:title];
        item.frame = CGRectMake(itemX, 0, itemW, CGRectGetHeight(_scrollView.frame));
        [item setItemTitle:title];
        [item setItemTitleFont:14];
        [item setItemTitleColor:UIColorHex(0x000000)]; //232323
        [item setItemDisableTitleColor:UIColorHex(0xbcbcbc)];
        [item setItemSelectedTitleColor:UIColorHex(0x38adff)];

        if (itemEnable) {
            [item setUserInteractionEnabled:!itemEnable];
            item.enabled = !itemEnable;
        }
        [_items addObject:item];
        itemX = CGRectGetMaxX(item.frame);
        [_scrollView addSubview:item];

        if ([self.dataList count] > 0) {
            if (i < [self.dataList count]-1) {
                UIImageView *yxsArrowimg =  [[UIImageView alloc] initWithFrame:CGRectMake(itemX, 0, 20, CGRectGetHeight(_scrollView.frame))];
                yxsArrowimg.contentMode = UIViewContentModeScaleAspectFit;
                [yxsArrowimg setImage:[UIImage imageNamed:@"yxselect_arrow"]];
                [_scrollView addSubview:yxsArrowimg];
                
                itemX = CGRectGetMaxX(yxsArrowimg.frame);
            }
        }
        // Caculate the origin.x of the next item
        
    }
    
    // Cculate the scrollView 's contentSize by all the items
    _scrollView.contentSize = CGSizeMake(itemX, CGRectGetHeight(_scrollView.frame));
    
    // Set the default selected item, the first item
    YXSelectItem *firstItem = [self.items firstObject];
    firstItem.selected = YES;
    _selectedItem = firstItem;
    
    // Set the frame of sliderView by the selected item //self.frame.size.height - SLIDER_VIEW_HEIGHT
    //firstItem.frame.size.height - 3
    //1
    
    _sliderView.frame = CGRectMake(0, firstItem.frame.size.height - 3, firstItem.frame.size.width, SLIDER_VIEW_HEIGHT);
}
//
- (void)scrollToVisibleItem:(YXSelectItem *)item {
    NSInteger selectedItemIndex = [self.items indexOfObject:_selectedItem];
    NSInteger visibleItemIndex = [self.items indexOfObject:item];
    
    // If the selected item is same to the item to be visible, nothing to do
    if (selectedItemIndex == visibleItemIndex) {
        return;
    }
    
    CGPoint offset = _scrollView.contentOffset;
    
    // If the item to be visible is in the screen, nothing to do
    if (CGRectGetMinX(item.frame) > offset.x && CGRectGetMaxX(item.frame) < (offset.x + CGRectGetWidth(_scrollView.frame))) {
        return;
    }
    
    // Update the scrollView's contentOffset according to different situation
    if (selectedItemIndex < visibleItemIndex) {
        // The item to be visible is on the right of the selected item and the selected item is out of screeen by the left, also the opposite case, set the offset respectively
        if (CGRectGetMaxX(_selectedItem.frame) < offset.x) {
            offset.x = CGRectGetMinX(item.frame);
        } else {
            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
        }
    } else {
        // The item to be visible is on the left of the selected item and the selected item is out of screeen by the right, also the opposite case, set the offset respectively
        if (CGRectGetMinX(_selectedItem.frame) > (offset.x + CGRectGetWidth(_scrollView.frame))) {
            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
        } else {
            offset.x = CGRectGetMinX(item.frame);
        }
    }
    _scrollView.contentOffset = offset;
}
//
- (void)addAnimationWithSelectedItem:(YXSelectItem *)item {
    // Caculate the distance of translation
    CGFloat dx = CGRectGetMidX(item.frame) - CGRectGetMidX(_selectedItem.frame);
    
    // Add the animation about translation
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(_sliderView.layer.position.x);
    positionAnimation.toValue = @(_sliderView.layer.position.x + dx);
    
    // Add the animation about size
    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds.size.width";
    boundsAnimation.fromValue = @(CGRectGetWidth(_sliderView.layer.bounds));
    boundsAnimation.toValue = @(CGRectGetWidth(item.frame));
    
    // Combine all the animations to a group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, boundsAnimation];
    animationGroup.duration = 0.2;
    [_sliderView.layer addAnimation:animationGroup forKey:@"basic"];
    
    // Keep the state after animating
    _sliderView.layer.position = CGPointMake(_sliderView.layer.position.x + dx, _sliderView.layer.position.y);
    CGRect rect = _sliderView.layer.bounds;
    rect.size.width = CGRectGetWidth(item.frame);
    _sliderView.layer.bounds = rect;
}
//
- (void)addAnimationWithSelectedItemNew:(YXSelectItem *)item {
    // Caculate the distance of translation
    CGFloat itemtitleW = [YXSelectItem widthForTitle:[item getitemTitle]];
    
    CGFloat dx = CGRectGetMidX(item.frame) - CGRectGetMidX(_selectedItem.frame);
    // Add the animation about translation
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(_sliderView.layer.position.x);
    positionAnimation.toValue = @(_sliderView.layer.position.x + dx);
    
    // Add the animation about size
    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds.size.width";
    boundsAnimation.fromValue = @(CGRectGetWidth(_sliderView.layer.bounds));
    boundsAnimation.toValue = @(itemtitleW);
    
    // Combine all the animations to a group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, boundsAnimation];
    animationGroup.duration = 0.2;
    [_sliderView.layer addAnimation:animationGroup forKey:@"basic"];
    
    // Keep the state after animating
    _sliderView.layer.position = CGPointMake(_sliderView.layer.position.x + dx, _sliderView.layer.position.y);
    CGRect rect = _sliderView.layer.bounds;
    rect.size.width = itemtitleW;
    _sliderView.layer.bounds = rect;
}

#pragma mark - Public

- (void)selectMenuItemSelectedCallback:(YXSelectMenuItemSelectedCallback)callback {
    _callback = callback;
}

- (void)selectMenuItemAtIndex:(NSUInteger)index {
    YXSelectItem *item = [self.items objectAtIndex:index];
    if (item == _selectedItem) {
        return;
    }
    
    [self selectItemSelected:item];
}

#pragma mark - FDSlideBarItemDelegate

- (void)selectItemSelected:(YXSelectItem *)item {
    if (item == _selectedItem) {
        return;
    }
    [self scrollToVisibleItem:item];
    if (_dataList) {
        [self addAnimationWithSelectedItem:item];
    }else{
        [self addAnimationWithSelectedItemNew:item];
    }
    [self.selectedItem setItemTitleFont:14];
    self.selectedItem = item;
    [self.selectedItem setItemSelectedTileFont:15];

    _callback([self.items indexOfObject:item]);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
