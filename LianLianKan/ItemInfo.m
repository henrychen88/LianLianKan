//
//  ItemInfo.m
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import "ItemInfo.h"

@interface ItemInfo ()
@property(nonatomic, assign, readwrite) NSString *text;
@property(nonatomic, strong, readwrite) UIColor *backgroundColor;
@end

@implementation ItemInfo

+ (NSString *)getTextByType:(ItemInfoType)type
{
    return [NSString stringWithFormat:@"%d",type + 1];
}

+ (UIColor *) getColorByType:(ItemInfoType)type
{
    if (type == ItemInfoTypeOne) {
        return [UIColor redColor];
    }else if (type == ItemInfoTypeTwo){
        return [UIColor greenColor];
    }else if (type == ItemInfoTypeThree){
        return [UIColor blueColor];
    }else if (type == ItemInfoTypeFour){
        return [UIColor brownColor];
    }else if (type == ItemInfoTypeFive){
        return [UIColor purpleColor];
    }else if (type == ItemInfoTypeSix){
        return [UIColor yellowColor];
    }else if (type == ItemInfoTypeSeven){
        return [UIColor cyanColor];
    }else{
        return [UIColor blackColor];
    }
}

@end
