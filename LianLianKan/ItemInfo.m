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
@property(nonatomic, strong, readwrite) UIImage *pic;
@end

@implementation ItemInfo

+ (NSString *)getTextByType:(ItemInfoType)type
{
    return [NSString stringWithFormat:@"%d",type + 1];
}

+ (UIColor *) getColorByType:(ItemInfoType)type
{
    if (type == ItemInfoTypeBlue) {
        return [UIColor redColor];
    }else if (type == ItemInfoTypeGreen){
        return [UIColor greenColor];
    }else if (type == ItemInfoTypeOrange){
        return [UIColor blueColor];
    }else if (type == ItemInfoTypePurple){
        return [UIColor brownColor];
    }else if (type == ItemInfoTypeRed){
        return [UIColor purpleColor];
    }else if (type == ItemInfoTypeWhite){
        return [UIColor yellowColor];
    }else if (type == ItemInfoTypeYellow){
        return [UIColor cyanColor];
    }
    return nil;
}

+ (UIImage *) getPicByType:(ItemInfoType)type
{
    if (type == ItemInfoTypeBlue) {
        return [UIImage imageNamed:@"StyleBlue"];
    }else if (type == ItemInfoTypeGreen){
        return [UIImage imageNamed:@"StyleGreen"];
    }else if (type == ItemInfoTypeOrange){
        return [UIImage imageNamed:@"StyleOrange"];
    }else if (type == ItemInfoTypePurple){
        return [UIImage imageNamed:@"StylePurple"];
    }else if (type == ItemInfoTypeRed){
        return [UIImage imageNamed:@"StyleRed"];
    }else if (type == ItemInfoTypeWhite){
        return [UIImage imageNamed:@"StyleWhite"];
    }else if (type == ItemInfoTypeYellow){
        return [UIImage imageNamed:@"StyleYellow"];
    }
    return nil;
}

@end
