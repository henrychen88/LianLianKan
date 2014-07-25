//
//  GameView.m
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import "GameView.h"
#import "WiredView.h"

@interface GameView ()
@property(nonatomic, assign) NSInteger numberOfRows;
@property(nonatomic, assign) NSInteger numberOfSections;
@property(nonatomic, strong) NSMutableArray *outOfOrderArray;
@property(nonatomic, strong) Item *seletedItem;
@property(nonatomic, strong) NSMutableArray *existCenterArray;
@property(nonatomic, strong) WiredView *wiredView;
@property(nonatomic, strong) UILabel *noticeLabel;
@end

@implementation GameView

#pragma mark - 初始化

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfRows = (NSInteger)floorf(frame.size.width / ITEM_SIZE);
        self.numberOfSections = (NSInteger)floorf(frame.size.height / ITEM_SIZE);
        [self outOrderArray];
        [self addItems];
        
        _noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 20)];
        _noticeLabel.alpha = 0.5;
        _noticeLabel.hidden = YES;
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.textColor = [UIColor redColor];
        [self addSubview:_noticeLabel];
        
        _wiredView = [[WiredView alloc]initWithFrame:self.bounds];
        _wiredView.hidden = YES;
        _wiredView.backgroundColor = [UIColor clearColor];
        [self addSubview:_wiredView];
    }
    return self;
}

- (void)addItems
{
    _existCenterArray = [[NSMutableArray alloc]init];
    NSInteger itemInfoTypeCounts = 8;
    NSInteger countPerType = (NSInteger)([_outOfOrderArray count] / itemInfoTypeCounts);
    NSInteger j = 1;
    NSInteger type = 0;
    for (NSInteger i = 0; i < [_outOfOrderArray count]; i++) {
        CGPoint origin = [self pointFromPosition:[[_outOfOrderArray objectAtIndex:i] integerValue]];
        
        NSInteger temp = j * countPerType - 1;
        if (j % 2 == 1 && countPerType % 2 == 1) {
            temp -= 1;
        }
        
        Item *item = [[Item alloc]initWithType:type];
        item.tag = i + 1;
        [item setSelectBlock:^(Item *item) {
            NSLog(@"item.frame : %@", NSStringFromCGRect(item.frame));
            [self didSeletedItem:item];
        }];
        CGRect frame = item.frame;
        frame.origin = origin;
        item.frame = frame;
        [self addSubview:item];
        [_existCenterArray addObject:[NSValue valueWithCGPoint:item.center]];
        
        if (i == temp) {
            j++;
            type++;
        }
    }
}

- (void)outOrderArray
{
    NSMutableArray *originArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < (_numberOfRows - 2) * (_numberOfSections - 2); i++) {
        [originArray addObject:[NSNumber numberWithInteger:i]];
    }
    NSInteger count = [originArray count];
    
    NSAssert(count % 2 == 0, @"格子总数不能为奇数,请调整界面的frame属性");
    
    if (!_outOfOrderArray) {
        _outOfOrderArray = [[NSMutableArray alloc]initWithCapacity:count];
    }else{
        [_outOfOrderArray removeAllObjects];
    }
    while (count > 0) {
        NSInteger position = arc4random() % count;
        [_outOfOrderArray addObject:[originArray objectAtIndex:position]];
        [originArray removeObjectAtIndex:position];
        count--;
    }
}

#pragma mark - 事件处理

- (void)didSeletedItem:(Item *)item
{
    if (!self.seletedItem) {
        self.seletedItem = item;
    }else{
        if (self.seletedItem.tag == item.tag) {
            //自己
            return;
        }else if (self.seletedItem.type != item.type){
            [self showNotice:@"类型不一样"];
            [self.seletedItem setSelected:NO];
            [item setSelected:NO];
            self.seletedItem = nil;
        }else{
            if ([self findRouteFrom:self.seletedItem.center to:item.center]) {
                [self.seletedItem removeFromSuperview];
                [item removeFromSuperview];
                self.seletedItem = nil;
            }else{
                [self.seletedItem setSelected:NO];
                [item setSelected:NO];
                self.seletedItem = nil;
            }
        }
    }
}

#pragma mark - 信息提示
- (void)showNotice:(NSString *)notice
{
    _noticeLabel.text = notice;
    _noticeLabel.hidden = NO;
    
    [self performSelector:@selector(dismissNoticeLabel) withObject:nil afterDelay:1];
}

- (void)dismissNoticeLabel
{
    _noticeLabel.hidden = YES;
}

- (BOOL)findRouteFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    if (startPoint.x == endPoint.x && startPoint.y == endPoint.y) {
        //自己
        [self showNotice:@"两次是同一个元素"];
        return NO;
    }else if (startPoint.x == endPoint.x && startPoint.y != endPoint.y){
        //在一条竖线上
        if ([self verticalStraightLineFrom:startPoint to:endPoint]) {
            return YES;
        }else if ([self verticalTwoBreakPointLineFrom:startPoint to:endPoint]){
            return YES;
        }else{
            return NO;
        }
    }else if (startPoint.x != endPoint.x && startPoint.y == endPoint.y){

        NSLog(@"xx");
        //在一条水平线上
        
        if ([self horizontalStraightLineFrom:startPoint to:endPoint]) {
            [self showNotice:@"水平直线"];
            return YES;
        }else if ([self horizontalTwoBreakPointLineFrom:startPoint to:endPoint]){
            [self showNotice:@"水平有两个拐角的连线"];
            return YES;
        }else{
            [self showNotice:@"水平没有连线的方法"];
            return NO;
        }
    }else{
        if ([self oneBreakPoint:startPoint to:endPoint]) {
            return YES;
        }else if ([self verticalTwoBreakPointIn:startPoint to:endPoint]){
            return YES;
        }else if ([self horizontalTwoBreakPointIn:startPoint to:endPoint]){
            return YES;
        }else if ([self verticalTwoBreakPointLineFrom:startPoint to:endPoint]){
            return YES;
        }else if ([self horizontalTwoBreakPointLineFrom:startPoint to:endPoint]){
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

- (BOOL) verticalTwoBreakPointIn:(CGPoint)startPoint to:(CGPoint)endPoint
{
    NSInteger order = (startPoint.y > endPoint.y) ? -1 : 1;
    CGFloat offsetY = startPoint.y + order * ITEM_SIZE;
    while (offsetY != endPoint.y) {
        CGPoint startPointOffset = CGPointMake(startPoint.x, offsetY);
        CGPoint endPointOffset = CGPointMake(endPoint.x, offsetY);
        if ([self checkFrom:startPoint to:endPoint byPoint1:startPointOffset point2:endPointOffset]) {
            return YES;
        }
        offsetY += order * ITEM_SIZE;
    }
    return NO;
}

- (BOOL) horizontalTwoBreakPointIn:(CGPoint)startPoint to:(CGPoint)endPoint
{
    NSInteger order = (startPoint.x > endPoint.x) ? -1 : 1;
    CGFloat offsetX = startPoint.x + order * ITEM_SIZE;
    while (offsetX != endPoint.x) {
        CGPoint startPointOffset = CGPointMake(offsetX, startPoint.y);
        CGPoint endPointOffset = CGPointMake(offsetX, endPoint.y);
        if ([self checkFrom:startPoint to:endPoint byPoint1:startPointOffset point2:endPointOffset]) {
            return YES;
        }
        offsetX += order * ITEM_SIZE;
    }
    return NO;
}

//水平直线
- (BOOL)horizontalStraightLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    NSInteger order = (startPoint.x > endPoint.x) ? -1 : 1;
    CGFloat start = startPoint.x;
    start += ITEM_SIZE * order;
    while (start != endPoint.x) {
        for (NSValue *value in self.existCenterArray) {
            CGPoint point = [value CGPointValue];
            if (point.x == start && point.y== startPoint.y) {
                return NO;
            }
        }
        start += ITEM_SIZE * order;
    }
    [self.existCenterArray removeObject:[NSValue valueWithCGPoint:startPoint]];
    [self.existCenterArray removeObject:[NSValue valueWithCGPoint:endPoint]];
    [self showWiredViewWithStartPoint:startPoint endPoint:endPoint breakPoints:nil];

    return YES;
}

//垂直直线
- (BOOL)verticalStraightLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    for (NSValue *value in [self getPointBetweenPoint:startPoint withPoint:endPoint]) {
        if (![self passableWithPoint:[value CGPointValue]]) {
            return NO;
        }
    }
    [self.existCenterArray removeObject:[NSValue valueWithCGPoint:startPoint]];
    [self.existCenterArray removeObject:[NSValue valueWithCGPoint:endPoint]];
    [self showWiredViewWithStartPoint:startPoint endPoint:endPoint breakPoints:nil];
    return YES;
}

//水平有2个拐角
- (BOOL)horizontalTwoBreakPointLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    BOOL canUp = YES;
    BOOL canDown = YES;
    
    NSInteger offsetY;
    NSInteger tag = 2;
    while (canUp || canDown) {
        if (canUp) {
            offsetY = - (tag / 2);
            CGFloat originY = (startPoint.y > endPoint.y) ? endPoint.y : startPoint.y;
            CGPoint startPointOffset = CGPointMake(startPoint.x, originY + offsetY * ITEM_SIZE);
            CGPoint endPointOffset = CGPointMake(endPoint.x, originY + offsetY * ITEM_SIZE);
            if (startPointOffset.y < 0) {
                canUp = NO;
            }else{
                if ([self checkFrom:startPoint to:endPoint byPoint1:startPointOffset point2:endPointOffset]) {
                    return YES;
                }
            }
        }
        tag++;
        
        if (canDown) {
            offsetY = (tag / 2);
            CGFloat originY = (startPoint.y > endPoint.y) ? startPoint.y : endPoint.y;
            CGPoint startPointOffset = CGPointMake(startPoint.x, originY + offsetY * ITEM_SIZE);
            CGPoint endPointOffset = CGPointMake(endPoint.x, originY + offsetY * ITEM_SIZE);
            if (startPointOffset.y > _numberOfSections * ITEM_SIZE) {
                canDown = NO;
            }else{
                if ([self checkFrom:startPoint to:endPoint byPoint1:startPointOffset point2:endPointOffset]) {
                    return YES;
                }
            }
        }
        tag++;
    }
    return NO;
}

//垂直有2个拐角
- (BOOL)verticalTwoBreakPointLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    BOOL canLeft = YES;
    BOOL canRight = YES;
    
    NSInteger offsetY;
    NSInteger tag = 2;
    while (canLeft || canRight) {
        if (canLeft) {
            offsetY = - (tag / 2);
            CGFloat originX = (startPoint.x > endPoint.x) ? endPoint.x : startPoint.x;
            CGPoint startPointOffset = CGPointMake(originX + offsetY * ITEM_SIZE, startPoint.y);
            CGPoint endPointOffset = CGPointMake(originX  + offsetY * ITEM_SIZE, endPoint.y);
            if (startPointOffset.x < 0) {
                canLeft = NO;
            }else{
                if ([self checkFrom:startPoint to:endPoint byPoint1:startPointOffset point2:endPointOffset]) {
                    return YES;
                }
            }
        }
        tag++;
        
        if (canRight) {
            offsetY = (tag / 2);
            CGFloat originX = (startPoint.x > endPoint.x) ? startPoint.x : endPoint.x;
            CGPoint startPointOffset = CGPointMake(originX  + offsetY * ITEM_SIZE, startPoint.y);
            CGPoint endPointOffset = CGPointMake(originX  + offsetY * ITEM_SIZE, endPoint.y);
            if (startPointOffset.x > _numberOfRows * ITEM_SIZE) {
                canRight = NO;
            }else{
                if ([self checkFrom:startPoint to:endPoint byPoint1:startPointOffset point2:endPointOffset]) {
                    return YES;
                }
            }
        }
        tag++;
    }
    return NO;
}

//一个拐角
- (BOOL)oneBreakPoint:(CGPoint)startPoint to:(CGPoint)endPoint
{
    if ([self checkFrom:startPoint to:endPoint by:CGPointMake(startPoint.x, endPoint.y)]) {
        return YES;
    }else if ([self checkFrom:startPoint to:endPoint by:CGPointMake(endPoint.x, startPoint.y)]){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)checkFrom:(CGPoint)startPoint to:(CGPoint)endPoint by:(CGPoint)point
{
    if (![self passableWithPoint:point]) {
        return NO;
    }
    
    for (NSValue *value in [self getPointBetweenPoint:startPoint withPoint:point]) {
        if (![self passableWithPoint:[value CGPointValue]]) {
            return NO;
        }
    }
    
    for (NSValue *value in [self getPointBetweenPoint:point withPoint:endPoint]) {
        if (![self passableWithPoint:[value CGPointValue]]) {
            return NO;
        }
    }
    [self.existCenterArray removeObject:[NSValue valueWithCGPoint:startPoint]];
    [self.existCenterArray removeObject:[NSValue valueWithCGPoint:endPoint]];
    [self showWiredViewWithStartPoint:startPoint endPoint:endPoint breakPoints:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:point], nil]];
    return YES;
}



//判断是否有2个拐点的连线
- (BOOL)checkFrom:(CGPoint)fromPoint to:(CGPoint)endPoint byPoint1:(CGPoint)fromPointOffset point2:(CGPoint)endPointOffset
{
    
    if (![self passableWithPoint:fromPointOffset] || ![self passableWithPoint:endPointOffset]) {
        return NO;
    }
    
    for (NSValue *value in [self getPointBetweenPoint:fromPoint withPoint:fromPointOffset]) {
        if (![self passableWithPoint:[value CGPointValue]]) {
            return NO;
        }
    }
    for (NSValue *value in [self getPointBetweenPoint:fromPointOffset withPoint:endPointOffset]) {
        if (![self passableWithPoint:[value CGPointValue]]) {
            return NO;
        }
    }
    for (NSValue *value in [self getPointBetweenPoint:endPointOffset withPoint:endPoint]) {
        if (![self passableWithPoint:[value CGPointValue]]) {
            return NO;
        }
    }
    [self.existCenterArray removeObject:[NSValue valueWithCGPoint:fromPoint]];
    [self.existCenterArray removeObject:[NSValue valueWithCGPoint:endPoint]];
    [self showWiredViewWithStartPoint:fromPoint endPoint:endPoint breakPoints:[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:fromPointOffset], [NSValue valueWithCGPoint:endPointOffset], nil]];
    return YES;
}

//判断是否可以通过当前点
- (BOOL)passableWithPoint:(CGPoint)point
{
    for (NSValue *value in self.existCenterArray) {
        CGPoint existPoint = [value CGPointValue];
        if (point.x == existPoint.x && point.y== existPoint.y) {
            NSLog(@"%@挡住了去路", NSStringFromCGPoint(existPoint));
            return NO;
        }
    }
    return YES;
}

//获取两点之间的连线路过的点
- (NSMutableArray *)getPointBetweenPoint:(CGPoint)startPoint withPoint:(CGPoint)endPoint
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    if ([self isInHorizontalStraightLine:startPoint withPoint:endPoint]) {
        NSInteger order = (startPoint.x > endPoint.x) ? -1 : 1;
        CGFloat start = startPoint.x + order * ITEM_SIZE;
        while (start != endPoint.x) {
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(start, endPoint.y)]];
            start += order * ITEM_SIZE;
        }
    }else if ([self isInVerticalStraightLine:startPoint withPoint:endPoint]){
        NSInteger order = (startPoint.y > endPoint.y) ? -1 : 1;
        CGFloat start = startPoint.y + order * ITEM_SIZE;
        while (start != endPoint.y) {
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(endPoint.x, start)]];
            start += order * ITEM_SIZE;
        }
    }else{
        NSAssert(NO, @"两点不在一条直线上");
    }
    return array;
}

//判断两点是否在水平的直线上
- (BOOL)isInHorizontalStraightLine:(CGPoint)startPoint withPoint:(CGPoint)endPoint
{
    return (startPoint.x != endPoint.x && startPoint.y == endPoint.y);
}

//判断两点是否在垂直的直线上
- (BOOL)isInVerticalStraightLine:(CGPoint)startPoint withPoint:(CGPoint)endPoint
{
    return (startPoint.x == endPoint.x && startPoint.y != endPoint.y);
}

- (void)showWiredViewWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint breakPoints:(NSMutableArray *)arrays
{
    [_wiredView setStartPoint:startPoint endPoint:endPoint breakPoints:arrays];
    _wiredView.hidden = NO;
    [self performSelector:@selector(dismissWiredView) withObject:nil afterDelay:.2];
}

- (void)dismissWiredView
{
    _wiredView.hidden = YES;
}

- (CGPoint)pointFromPosition:(NSInteger)position
{
    NSInteger section = position / (_numberOfRows - 2);
    NSInteger row = position % (_numberOfRows - 2);
    return CGPointMake(ITEM_SIZE * (row + 1), ITEM_SIZE * (section + 1));
}



@end
