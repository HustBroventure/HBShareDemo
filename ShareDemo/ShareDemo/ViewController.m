//
//  ViewController.m
//  ShareDemo
//
//  Created by wangfeng on 16/6/27.
//  Copyright © 2016年 HustBroventure. All rights reserved.
//

#import "ViewController.h"
#import "HBSocialShareView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickShare:(id)sender {
    
    [HBSocialShareView showInSuperView:self.view];

}

@end
