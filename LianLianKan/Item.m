//
//  Item.m
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id) initWithType:(ItemInfoType)type
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, ITEM_SIZE, ITEM_SIZE)];
        [self setType:type];
        
        self.img = [ItemInfo getPicByType:type];
        
//        self.image = [ItemInfo getPicByType:type];
//        [self setText:[ItemInfo getTextByType:type]];
//        [self setBackgroundColor:[ItemInfo getColorByType:type]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:self.bounds];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void) buttonAction
{
    self.selected = !self.selected;
    if (self.selectBlock) {
        self.selectBlock(self);
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.img drawInRect:rect];
    
    if (self.selected) {
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    }else{
        CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    }
    CGContextStrokeRectWithWidth(ctx, self.bounds, 3);
    
    /*
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:30], NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize size = [self.text sizeWithAttributes:attributes];//只适用于单行显示的UILabel
    [self.text drawAtPoint:CGPointMake((self.bounds.size.width - size.width) / 2.0f, (self.bounds.size.height - size.height) / 2.0f) withAttributes:attributes];
     */
}

@end
