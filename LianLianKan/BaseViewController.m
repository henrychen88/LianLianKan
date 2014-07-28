//
//  BaseViewController.m
//  LianLianKan
//
//  Created by Henry on 14-7-25.
//  Copyright (c) 2014年 ichint. All rights reserved.
//

#import "BaseViewController.h"
#import "GameView.h"

@interface BaseViewController ()
{
    UIButton *resetButton, *pauseButton;
    GameView *gameView;
}
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
//    Item *item = [[Item alloc]initWithType:ItemInfoTypeThree];
//    [self.view addSubview:item];
//    [item setFrame:CGRectMake(100, 100, 40, 40)];
    
    gameView = [[GameView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:gameView];
    
    resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setFrame:CGRectMake(0, self.view.frame.size.height - 40, 60, 40)];
    [resetButton setTitle:@"重来" forState:UIControlStateNormal];
    [resetButton setBackgroundColor:[UIColor grayColor]];
    [resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
}

- (void)resetAction
{
    [gameView reset];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
