//
//  ItemInfo.h
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ItemInfoType) {
    ItemInfoTypeBlue,
    ItemInfoTypeGreen,
    ItemInfoTypeOrange,
    ItemInfoTypePurple,
    ItemInfoTypeRed,
    ItemInfoTypeWhite,
    ItemInfoTypeYellow,
};

@interface ItemInfo : NSObject

+ (UIColor *) getColorByType:(ItemInfoType)type;

+ (NSString *) getTextByType:(ItemInfoType)type;

+ (UIImage *) getPicByType:(ItemInfoType)type;

@end
