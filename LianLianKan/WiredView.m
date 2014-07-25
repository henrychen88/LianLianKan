//
//  WiredView.m
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import "WiredView.h"

@implementation WiredView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint breakPoints:(NSMutableArray *)breakPoints
{
    _startPoint = startPoint;
    _endPoint = endPoint;
    _breakPoints = breakPoints;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 5);
    CGContextSetStrokeColorWithColor(ctx, [UIColor purpleColor].CGColor);
    CGContextMoveToPoint(ctx, _startPoint.x, _startPoint.y);
    for (NSInteger i = 0; i < [_breakPoints count]; i++) {
        CGPoint point = [[_breakPoints objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextAddLineToPoint(ctx, _endPoint.x, _endPoint.y);
    CGContextStrokePath(ctx);
}


@end
