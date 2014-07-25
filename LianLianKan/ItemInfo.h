//
//  ItemInfo.h
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ItemInfoType) {
    ItemInfoTypeOne,
    ItemInfoTypeTwo,
    ItemInfoTypeThree,
    ItemInfoTypeFour,
    ItemInfoTypeFive,
    ItemInfoTypeSix,
    ItemInfoTypeSeven,
    ItemInfoTypeDefault
};

@interface ItemInfo : NSObject

+ (UIColor *) getColorByType:(ItemInfoType)type;

+ (NSString *) getTextByType:(ItemInfoType)type;

@end
