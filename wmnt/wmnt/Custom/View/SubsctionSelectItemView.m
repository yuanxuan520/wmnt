//
//  SubsctionSelectItemView.m
//  ParkProject
//
//  Created by yuanxuan on 2017/3/31.
//  Copyright © 2017年 yuanxuan. All rights reserved.
//

#import "SubsctionSelectItemView.h"
#import "IndexPathDataButton.h"

#define sectionXSpace 20  //块视图x
#define sectionSpace 10   //块视图上下间隔
#define sectioitemW self.bounds.size.width //块视图宽

#define sectionTitleXSpace 10
#define sectionTitleH 35
#define sectionTitleFontSize 14
#define sectionBottomSpace 20
#define DefaultHigh 90

#define subSectionH 35
#define subSectionXSpace 15
#define subSectionYSpace 10
#define subSectionTopSpace 5
#define FontBorderSize 12 //字体两边的多余空间 *2
#define subSectionTitleFontSize 13



@interface SubsctionSelectItemView()

@property (nonatomic, strong) NSMutableArray *itemDataList;
@property (nonatomic, strong) NSString *itemTitleKey;
@property (nonatomic, strong) NSString *itemListKey;
@property (nonatomic, strong) NSString *itemSubTitleKey;

@property (nonatomic, strong) NSMutableArray *selectedDataList;
@property (nonatomic, assign) NSInteger curSelectedSection;

@property (nonatomic, strong) NSMutableArray *allItems;
@property (strong, nonatomic) SubsctionSelectItemCallback callback;

@end
@implementation SubsctionSelectItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.curSelectedSection = 0;
        self.selectedDataList = [NSMutableArray arrayWithCapacity:0];
        self.allItems = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)buildFormDataList:(NSMutableArray *)dataList sectionTitleKey:(NSString *)titleKey subListKey:(NSString *)listKey subTitleKey:(NSString *)subTitleKey
{
    self.itemDataList = dataList;
    self.itemTitleKey = titleKey;
    self.itemListKey = listKey;
    self.itemSubTitleKey = subTitleKey;

    [self buildView];
}
- (void)setSubsctionSelectItemCallback:(SubsctionSelectItemCallback)callback
{
    self.callback = callback;
}

- (void)buildSelectImgView
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat curSectionY = 0;
    for(int j=0; j<self.itemDataList.count; j++){//tabList.count
        NSDictionary *dataDict = [self.itemDataList objectAtIndex:j];
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(sectionXSpace, curSectionY, sectioitemW-sectionXSpace*2, DefaultHigh)];
        sectionView.tag = j;
        sectionView.backgroundColor = [UIColor whiteColor];
        sectionView.layer.cornerRadius = 3;
        sectionView.layer.borderColor = [UIColor colorFromHexRGB:@"dedfe5"].CGColor;
        sectionView.layer.borderWidth = 0.5;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, sectionTitleH)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = SystemFont(sectionTitleFontSize);
        titleLabel.textColor = [UIColor colorFromHexRGB:@"131313"];
        titleLabel.text = [dataDict objectForKey:self.itemTitleKey];
        [sectionView addSubview:titleLabel];
        [self addSubview:sectionView];
        
        CGFloat xindex = 0;
        CGFloat yindex = sectionTitleH + subSectionTopSpace;
        CGFloat curSectionH = 0;
        NSArray *personList = [dataDict objectForKey:self.itemListKey];
        for (int i=0; i<personList.count; i++) {
            NSDictionary *personDict = [personList objectAtIndex:i];
            
            NSString *itemTitle = [personDict objectForKey:self.itemSubTitleKey];
            
            CGSize itemtitlesize = GetWTextSizeFont(itemTitle, subSectionH, subSectionTitleFontSize);
            
            CGFloat curMaxW = xindex + (subSectionH+FontBorderSize+itemtitlesize.width) + subSectionXSpace;
            if (curMaxW > (sectioitemW-sectionXSpace*2)) {
                xindex = 0 + subSectionXSpace;
                yindex += subSectionH+subSectionYSpace;
            }else{
                xindex = xindex + subSectionXSpace;
            }
            
            IndexPathDataButton *itemBtn = [IndexPathDataButton buttonWithType:UIButtonTypeCustom];
            itemBtn.isCustom = YES;
            itemBtn.frame = CGRectMake(xindex, yindex, subSectionH+10+itemtitlesize.width, subSectionH);
            [itemBtn setSelectImg];
            itemBtn.titleLabel.font = SystemFont(subSectionTitleFontSize);
            itemBtn.layer.cornerRadius = 3;
            itemBtn.layer.borderColor = [UIColor colorFromHexRGB:@"dedfe5"].CGColor;
            itemBtn.layer.borderWidth = 0.5;
            [itemBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];

            itemBtn.section = j;
            itemBtn.row = i;
            itemBtn.curInfoData = personDict;
            itemBtn.clipsToBounds = YES;
            [itemBtn setTitle:itemTitle forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor colorFromHexRGB:@"888888"] forState:UIControlStateNormal];
            [sectionView addSubview:itemBtn];
            
            [self.allItems addObject:itemBtn];
            xindex += itemBtn.bounds.size.width;
        }
        curSectionH += yindex + subSectionH + 10;
        
        sectionView.frame = CGRectMake(sectionXSpace, curSectionY, sectioitemW-sectionXSpace*2, curSectionH);
        curSectionY += curSectionH + sectionSpace;
    }
    if (self.itemDataList.count == 0) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(sectionXSpace, curSectionY, sectioitemW-sectionXSpace*2, DefaultHigh)];
        sectionView.backgroundColor = [UIColor whiteColor];
        sectionView.layer.cornerRadius = 5;
        sectionView.layer.borderColor = [UIColor colorFromHexRGB:@"dedfe5"].CGColor;
        sectionView.layer.borderWidth = 0.5;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, sectionTitleH)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = SystemFont(sectionTitleFontSize);
        titleLabel.textColor = [UIColor colorFromHexRGB:@"131313"];
        titleLabel.text = @"暂无数据";
        [sectionView addSubview:titleLabel];
        [self addSubview:sectionView];
        curSectionY += DefaultHigh;
    }
    //重新设置总高度
    CGRect frame = self.frame;
    frame.size.height = curSectionY;
    self.frame = frame;
}

- (void)buildView
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat curSectionY = 0;
    for(int j=0; j<self.itemDataList.count; j++){//tabList.count
        NSDictionary *dataDict = [self.itemDataList objectAtIndex:j];
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(sectionXSpace, curSectionY, sectioitemW-sectionXSpace*2, DefaultHigh)];
        sectionView.tag = j;
        sectionView.backgroundColor = [UIColor whiteColor];
        sectionView.layer.cornerRadius = 5;
        sectionView.layer.borderColor = [UIColor colorFromHexRGB:@"dedfe5"].CGColor;
        sectionView.layer.borderWidth = 0.5;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, sectionTitleH)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = SystemFont(sectionTitleFontSize);
        titleLabel.textColor = [UIColor colorFromHexRGB:@"131313"];
        titleLabel.text = [dataDict objectForKey:self.itemTitleKey];
        [sectionView addSubview:titleLabel];
        [self addSubview:sectionView];
        
        CGFloat xindex = 0;
        CGFloat yindex = sectionTitleH + subSectionTopSpace;
        CGFloat curSectionH = 0;
        NSArray *personList = [dataDict objectForKey:self.itemListKey];
        for (int i=0; i<personList.count; i++) {
            NSDictionary *personDict = [personList objectAtIndex:i];
            
            NSString *itemTitle = [personDict objectForKey:self.itemSubTitleKey];
            
            CGSize itemtitlesize = GetWTextSizeFont(itemTitle, subSectionH, subSectionTitleFontSize);
            
            CGFloat curMaxW = xindex + (FontBorderSize+itemtitlesize.width) + subSectionXSpace;
            if (curMaxW > (sectioitemW-sectionXSpace*2)) {
                xindex = 0 + subSectionXSpace;
                yindex += subSectionH+subSectionYSpace;
            }else{
                xindex = xindex + subSectionXSpace;
            }
            
            IndexPathDataButton *itemBtn = [IndexPathDataButton buttonWithType:UIButtonTypeCustom];
            itemBtn.frame = CGRectMake(xindex, yindex, FontBorderSize+itemtitlesize.width, subSectionH);
            [itemBtn setSelectImg];
            itemBtn.titleLabel.font = SystemFont(subSectionTitleFontSize);
            itemBtn.layer.cornerRadius = 3;
            itemBtn.layer.borderColor = [UIColor colorFromHexRGB:@"dedfe5"].CGColor;
            itemBtn.layer.borderWidth = 0.5;
            [itemBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.section = j;
            itemBtn.row = i;
            itemBtn.curInfoData = personDict;
            itemBtn.clipsToBounds = YES;
            [itemBtn setTitle:itemTitle forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor colorFromHexRGB:@"888888"] forState:UIControlStateNormal];
            [sectionView addSubview:itemBtn];
            
            xindex += itemBtn.bounds.size.width;
            [self.allItems addObject:itemBtn];
        }
        curSectionH += yindex + subSectionH + 10;
        
        sectionView.frame = CGRectMake(sectionXSpace, curSectionY, sectioitemW-sectionXSpace*2, curSectionH);
        curSectionY += curSectionH + sectionSpace;
    }
    
    if (self.itemDataList.count == 0) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(sectionXSpace, curSectionY, sectioitemW-sectionXSpace*2, DefaultHigh)];
        sectionView.backgroundColor = [UIColor whiteColor];
        sectionView.layer.cornerRadius = 5;
        sectionView.layer.borderColor = [UIColor colorFromHexRGB:@"dedfe5"].CGColor;
        sectionView.layer.borderWidth = 0.5;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, sectionTitleH)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = SystemFont(sectionTitleFontSize);
        titleLabel.textColor = [UIColor colorWithWhite:0.722 alpha:1.000];
        titleLabel.text = @"暂无发送人";
        titleLabel.center = CGPointMake(sectionView.bounds.size.width/2, sectionView.bounds.size.height/2);
        [sectionView addSubview:titleLabel];
        [self addSubview:sectionView];
        curSectionY += DefaultHigh;
    }
    
    
    //重新设置总高度
    CGRect frame = self.frame;
    frame.size.height = curSectionY;
    self.frame = frame;
}

- (void)selectItem:(IndexPathDataButton *)item
{
    if (!item.selected) {//当前未选择
        if (self.curSelectedSection != item.section) {//如果当前未选择 选择别的节点
            self.curSelectedSection = item.section;
            [self cancelallItemSelected];
            [self.selectedDataList removeAllObjects];
            [self.selectedDataList addObject:item.curInfoData];
        }else{
            [self.selectedDataList addObject:item.curInfoData];
        }
        item.selected = !item.selected;
    }else{//当前已选择
        
        [self.selectedDataList removeObject:item.curInfoData];
        item.selected = !item.selected;
    }
    if (self.callback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.callback(self.selectedDataList);
        });
    }
}

- (void)selectItemSection:(NSInteger)section row:(NSInteger)row
{
    for (IndexPathDataButton *itemBtn in self.allItems) {
        if (itemBtn.section == section && itemBtn.row == row) {
            if (self.curSelectedSection != section) {
                [self.selectedDataList removeAllObjects];
                [self cancelallItemSelected];
                self.curSelectedSection = section;
                [self.selectedDataList addObject:itemBtn.curInfoData];
            }else{
                [self.selectedDataList addObject:itemBtn.curInfoData];
            }
            itemBtn.selected = YES;
        }
    }
    if (self.callback) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.callback(self.selectedDataList);
        });
    }
}

- (void)cancelallItemSelected
{
    for (IndexPathDataButton *itemBtn in self.allItems) {
        itemBtn.selected = NO;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
