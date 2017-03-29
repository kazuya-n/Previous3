//
//  BackgroundViewController.m
//  Previous3
//
//  Created by 野村和也 on 2014/07/30.
//  Copyright (c) 2014年 野村和也. All rights reserved.
//

#import "BackgroundViewController.h"
#import "MasterViewController.h"


@interface BackgroundViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UITextView *memoText;

@property (weak, nonatomic) IBOutlet UILabel *datingLabel;
@end

@implementation BackgroundViewController



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
    //画面にいろいろな情報を表示するメソッド
    //画面が読み込まれて表示される前に呼ばれる
    self.titleLabel.text=self.events.title;
    DateFormatString *aDateFormatter=[DateFormatString new];
    NSString*viewDate = [aDateFormatter dateFormat24:self.events.date];
    self.datingLabel.text=viewDate;
    self.memoText.text=self.events.memo;
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
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
