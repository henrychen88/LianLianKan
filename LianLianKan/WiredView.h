//
//  WiredView.h
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WiredView : UIView
@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) CGPoint endPoint;
@property(nonatomic, strong) NSMutableArray *breakPoints;

- (void)setStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint breakPoints:(NSMutableArray *)breakPoints;

@end
