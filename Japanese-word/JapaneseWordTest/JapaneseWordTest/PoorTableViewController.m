//
//  PoorTableViewController.m
//  JapaneseWordTest
//
//  Created by iOS123 on 2019/1/10.
//  Copyright © 2019年 iOS123. All rights reserved.
//

#import "PoorTableViewController.h"
#import "TableViewCell.h"
#import "InfoViewController.h"

@interface PoorTableViewController ()
@property NSMutableArray *wordList;
@property NSMutableArray *spellList;
@property NSMutableArray *idList;
@end

@implementation PoorTableViewController

//数据库连接
sqlite3 *_sqlite;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = 90;
    NSString *viewIdentifier = self.tableView.restorationIdentifier;
    //数据库路径及名称
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"db.sqlite1"];
    
    // 打开数据库连接，如果有就打开，没有就重新创建连接
    NSInteger state = sqlite3_open(fileName.UTF8String, &_sqlite);
    NSString *sql = [[NSString alloc] init];
    //查询sql语句
    if([viewIdentifier isEqualToString:@"all"]){
        sql = [NSString stringWithFormat:@"select * from jccard"];
    }
    else{
           sql = [NSString stringWithFormat:@"select * from jccard where bookmark = %@",viewIdentifier];
    }
 
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(_sqlite, sql.UTF8String, -1, &stmt, NULL);
    
    //初始化array
    self.wordList = [NSMutableArray array];
    self.spellList = [NSMutableArray array];
    self.idList = [NSMutableArray array];
    
    //若查询成功
    if (state == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获取词
            NSString *word = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            //获取拼写
            NSString *spell = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            //获取id
            NSString *wordId = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            [self.wordList addObject:word];
            [self.spellList addObject:spell];
            [self.idList addObject:wordId];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.spell.text = self.spellList[indexPath.row];
    cell.word.text = self.wordList[indexPath.row];
    cell.wordId = self.idList[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"infoSeguePoor"]){
        InfoViewController *ivc = (InfoViewController *)segue.destinationViewController;
        ivc.wordId = self.idList[self.tableView.indexPathForSelectedRow.row];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
