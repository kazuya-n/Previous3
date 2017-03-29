//
//  DetailViewController.m
//  Previous3
//
//  Created by 野村和也 on 2014/06/15.
//  Copyright (c) 2014年 野村和也. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *event_list;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextView *memoView;
@property (strong, nonatomic) IBOutlet UIPickerView *eventPicker;
@end

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
	// Do any additional setup after loading the view.
    //テンプレ用の配列
    self.eventPicker.dataSource=self;
    self.eventPicker.delegate=self;
    event_list=@[@"開始",@"終了",@"食事",@"休憩",@"通過",@"到着",@"出発"];
    [self configureView];
}
- (IBAction)endTextEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)configureView
{
    if (self.events) {
        // 既存の項目を表示する
        self.textField.text = self.events.title;
        self.datePicker.date = self.events.date;
        self.memoView.text=self.events.memo;
    } else {
    self.events = [[Events alloc] init];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Picker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return event_list.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return event_list[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString*selectedEvent=[NSString stringWithFormat:@"%@:",event_list[row]];
    self.textField.text=selectedEvent;
}

//ツイート
- (IBAction)tweetButton {
    SLComposeViewController *controller=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    DateFormatString *aDateFormatter=[DateFormatString new];
    NSString*tweetDate = [aDateFormatter dateFormat24:self.datePicker.date];
    NSString*memo=self.events.memo;
    NSString*tweetMes=[NSString stringWithFormat:@"%@ に、私は「%@」しました。\nメモ: %@\n#記録",tweetDate,self.textField.text,memo];
    [controller setInitialText:tweetMes];
    [self presentViewController:controller
                         animated:YES
                       completion:NULL];
}



#pragma mark - セグエ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    if ([segue.identifier isEqualToString:@"save"]) {
        self.events.title = self.textField.text;
        self.events.date = self.datePicker.date;
    }
    if ([segue.identifier isEqualToString:@"memo"]){
        
        if(self.events.memo){
        MemoViewController *controller = (MemoViewController *)segue.destinationViewController;
        Events *anEvent=self.events;
        controller.events=anEvent;
        NSLog(@"memo");
        }
        
    }
}

- (IBAction)unwindToDetail:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"savememo"]) {
        
        MemoViewController *controller = (MemoViewController*)segue.sourceViewController;
        self.events.memo=controller.events.memo;
        self.memoView.text=self.events.memo;
        
    }

}
@end