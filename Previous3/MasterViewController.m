//
//  MasterViewController.m
//  Previous3
//
//  Created by 野村和也 on 2014/05/25.
//  Copyright (c) 2014年 野村和也. All rights reserved.
//

#import "MasterViewController.h"
#import "Events.h"
#import "EventViewController.h"
#import "BackgroundViewController.h"

//変数宣言
@interface MasterViewController () {
    NSMutableArray *events;
}
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [self prepareBackground];
    });
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
//セクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Events *anEvent = events[indexPath.row];
    cell.textLabel.text= anEvent.title;
    DateFormatString *aDateFormatter=[DateFormatString new];
    if (anEvent.memo!=NULL){
        NSString *subtitle=[NSString stringWithFormat:@"%@ メモ:%@",[aDateFormatter dateFormat24:anEvent.date],anEvent.memo];
        cell.detailTextLabel.text =subtitle;
    }else{
        cell.detailTextLabel.text=[aDateFormatter dateFormat24:anEvent.date];
    }
}
- (IBAction)writeButton:(UIBarButtonItem *)sender {
    [self writeDown];
}
- (IBAction)deleteButton:(id)sender {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"確認" message:@"削除してもよろしいですか？"
                              delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: // Button1が押されたとき
            [events removeAllObjects];
            [self.tableView reloadData];
            break;
            
            
        default: // キャンセルが押されたとき
            NSLog(@"Cancel");
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [events removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Events *anEvent = events[fromIndexPath.row];
    [events removeObjectAtIndex:fromIndexPath.row];
    [events insertObject:anEvent atIndex:toIndexPath.row];
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Events
//イベント追加
- (void)insertNewEvent:(Events*)event
{
    //初期化されてなかったら初期化
    if (!events) {
        events = [[NSMutableArray alloc] init];
    }
    //呼び出し元の文字列を配列に代入
    [events insertObject:event atIndex:0];
    //空のセルを追加
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
   }
- (void)replaceEventsAtIndex:(NSInteger)index withEvent:(Events *)event
{
    [events replaceObjectAtIndex:index withObject:event];
    [self.tableView reloadData];
}
//書き下し用のメソッド
-(void)writeDown{
    NSLog(@"writeDown is called.");
    //ファイルパス取得
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *filePath = [paths[0] stringByAppendingPathComponent:@"kiroku.csv"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Events配列の逆順の配列Reverseを作成
    NSArray *reverse=[[events reverseObjectEnumerator] allObjects];
    
    if (![fileManager fileExistsAtPath:filePath]) { // yes
        // 空のファイルを作成する
        BOOL result = [fileManager createFileAtPath:filePath
                                           contents:[NSData data] attributes:nil];
        if (!result) {
            NSLog(@"ファイルの作成に失敗");
            return;
        }
    }
    
    // ファイルハンドルを作成する
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!fileHandle) {
        NSLog(@"ファイルハンドルの作成に失敗");
        return;
    }
    //日付のデータを文字に変換する
    NSDateFormatter *dayFormatter=[[NSDateFormatter alloc]init];
    NSDateFormatter *timeFormatter=[[NSDateFormatter alloc]init];
    dayFormatter.dateFormat=@"yyyy/M/d";
    timeFormatter.dateFormat=@"H:m:";
    // ファイルに書き込むデータ1を作成
    for(int i=0; i<[reverse count]; i++){
        Events *anEvent=reverse[i];
        //書き込むテキストを生成
        NSString *addtext=[NSString stringWithFormat:@"%@,%@,%@,%@\n",[dayFormatter stringFromDate:anEvent.date],[timeFormatter stringFromDate:anEvent.date],anEvent.title,anEvent.memo];
        //(null)が含まれていたら消す
        addtext=[addtext stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        NSData *data = [addtext dataUsingEncoding:NSShiftJISStringEncoding];
        // ファイルに書き込む
        [fileHandle writeData:data];
    }
    //書き出し完了を知らせるためのアラートを表示
    UIAlertView *alert =
    [[UIAlertView alloc]
     initWithTitle:@"完了"
     message:@"記録の書き出しが完了しました。"
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];

}
#pragma mark - データの保存

- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *filePath = [paths[0] stringByAppendingPathComponent:@"save.dat"];
    return filePath;
}

- (void)load
{
    events = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
}

- (void)save
{
    [NSKeyedArchiver archiveRootObject:events toFile:[self filePath]];
}



#pragma mark - セグエ

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 遷移先に配列をぶち込む
    if ([segue.identifier isEqualToString:@"select"]) {
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        Events *anEvent = events[indexPath.row];
        EventViewController *controller = (EventViewController *)segue.destinationViewController;
        controller.events = anEvent;
    }

}

- (IBAction)unwindToMaster:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"save"]) {
        
        EventViewController *controller = (EventViewController *)segue.sourceViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        if (indexPath == nil) {
            [self insertNewEvent:controller.events]; // セルが選択されていない時はイベントを追加する
            
        } else {
            [self replaceEventsAtIndex:indexPath.row withEvent:controller.events]; // セルが選択されている時はタスクを編集する
        }
        
        

        
    }
    
}
//バックグラウンドビュー（アプリがついた時に出る画面）の表示
-(void)prepareBackground
{
    //記録が一つも書かれてなかったらやめる
    if ([events count] != 0) {
        BackgroundViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BGV"];
        ViewController.events=events[0];
        [self presentViewController:ViewController animated:YES completion:nil];
    }
}



@end
