//
//  Common_Font.h
//  Resident
//
//  Created by wenjun on 2017/6/26.
//  Copyright © 2017年 XingKang. All rights reserved.
//

#ifndef Common_Font_h
#define Common_Font_h

#define kFontSize(size) [UIFont systemFontOfSize:size]
#define kFontSizeBold(size) [UIFont boldSystemFontOfSize:size]

#define kFontNavText [UIFont systemFontOfSize:17]

//获取宽度高度无限的字符串位置大小
#define GetHTextSizeFoldFont(htitle,wsize,hfont) [htitle boundingRectWithSize:CGSizeMake(wsize, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFoldFont(hfont)} context:nil].size;

#define GetWTextSizeFoldFont(wtitle,hsize,wfont) [wtitle boundingRectWithSize:CGSizeMake(MAXFLOAT, hsize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFoldFont(wfont)} context:nil].size;

#define GetHTextSizeFont(htitle,wsize,hfont) [htitle boundingRectWithSize:CGSizeMake(wsize, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFont(hfont)} context:nil].size;

#define GetWTextSizeFont(wtitle,hsize,wfont) [wtitle boundingRectWithSize:CGSizeMake(MAXFLOAT, hsize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFont(wfont)} context:nil].size;
#endif /* Common_Font_h */
