//
//  Const.h
//  shrb
//
//  Created by PayBay on 15/5/21.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

#ifndef shrb_Const_h
#define shrb_Const_h

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define IsiPhone4s   [UIScreen mainScreen].bounds.size.width<=320
#define IsiPhone6   [UIScreen mainScreen].bounds.size.width==375

#define IsIOS8   [[[UIDevice currentDevice] systemVersion] floatValue]>=8.0

#define IsIOS7   [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0

//#define shrbPink      [UIColor colorWithRed:253.0/255.0 green:99.0/255.0 blue:93.0/255.0 alpha:1]
#define shrbPink      [UIColor colorWithRed:235.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:1]
#define shrbPinkAlpha8      [UIColor colorWithRed:235.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:0.8]
#define shrbLightPink      [UIColor colorWithRed:235.0/255.0 green:75.0/255.0 blue:75.0/255.0 alpha:0.3]
#define shrbTableViewColor      [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]
#define shrbSectionColor      [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1]
#define shrbText      [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1]
#define shrbLightText      [UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1]

#define shrbLightCell      [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define baseUrl @"http://121.40.222.162:8080/tongbao"

#endif
