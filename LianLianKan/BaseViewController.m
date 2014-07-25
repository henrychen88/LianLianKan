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

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
//    Item *item = [[Item alloc]initWithType:ItemInfoTypeThree];
//    [self.view addSubview:item];
//    [item setFrame:CGRectMake(100, 100, 40, 40)];
    
    GameView *gameView = [[GameView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:gameView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
