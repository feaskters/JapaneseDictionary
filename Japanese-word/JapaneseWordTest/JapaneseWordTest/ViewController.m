//
//  ViewController.m
//  JapaneseWordTest
//
//  Created by iOS123 on 2019/1/10.
//  Copyright © 2019年 iOS123. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "InfoViewController.h"

@interface ViewController (){
        sqlite3 *_sqlite;
}
@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) NSString *wordId;

@end

@implementation ViewController

//数据库名称
NSString *name = @"db.sqlite";


- (void)viewDidLoad {
    [super viewDidLoad];
    //数据库路径及名称
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"db.sqlite1"];
    
    // 复制本地数据到沙盒中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileName]) {
        // 获得数据库文件在工程中的路径——源路径。
        NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"db"ofType:@"sqlite"];
        NSError *error ;
        
        if ([fileManager copyItemAtPath:sourcesPath toPath:fileName error:&error]) {
            NSLog(@"数据库移动成功");
        } else {
            NSLog(@"数据库移动失败");
        }
 }
    
    // 打开数据库连接，如果有就打开，没有就重新创建连接
    NSInteger state = sqlite3_open(fileName.UTF8String, &_sqlite);
    
    //生成随机数
    int id =arc4random() % 8532;
    self.wordId = [NSString stringWithFormat:@"%d",id];
    //查询sql语句
    NSString *sql = [NSString stringWithFormat:@"select * from jccard where id = %d",id];
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(_sqlite, sql.UTF8String, -1, &stmt, NULL);
    
    //若查询成功
    if (state == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *word = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            self.word.text = word;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"InfoSeague"]){
        InfoViewController *ivc = (InfoViewController *)segue.destinationViewController;
        ivc.wordId = self.wordId;
    }
}

@end
