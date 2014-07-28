//
//  Item.h
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemInfo.h"

#define ITEM_SIZE 40

@interface Item : UIView

typedef void (^SelectBlock) (Item *item);

@property(nonatomic, strong) ItemInfo *itemInfo;
@property(nonatomic, assign) ItemInfoType type;
@property(nonatomic, strong) UIImage *img;
@property(nonatomic) BOOL selected;
@property(nonatomic, copy) SelectBlock selectBlock;

- (id) initWithType:(ItemInfoType)type;

- (void) setSelectBlock:(SelectBlock)selectBlock;

@end
