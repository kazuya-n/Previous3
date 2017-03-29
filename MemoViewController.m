//
//  MemoViewController.m
//  Previous3
//
//  Created by 野村和也 on 2014/07/22.
//  Copyright (c) 2014年 野村和也. All rights reserved.
//

#import "MemoViewController.h"


@interface MemoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *MemoTextView;

@end

@implementation MemoViewController

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
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureView
{
    // 既存のメモを表示する
    if(self.events.memo){
            self.MemoTextView.text = self.events.memo;
    }else{
        self.events=[[Events alloc]init];
    }
    
}
#pragma mark - セグエ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"savememo"]) {
        self.events.memo=self.MemoTextView.text;
    }
}


@end
