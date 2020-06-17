//
//  ViewController.m
//  KeyboardFramer
//
//  Created by Dan Leehr on 6/16/20.
//  Copyright © 2020 Dan Leehr LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"Hello World";
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];
}


@end
