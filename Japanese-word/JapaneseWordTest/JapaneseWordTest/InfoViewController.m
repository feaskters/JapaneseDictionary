//
//  InfoViewController.m
//  JapaneseWordTest
//
//  Created by iOS123 on 2019/1/10.
//  Copyright © 2019年 iOS123. All rights reserved.
//

#import "InfoViewController.h"
#import <sqlite3.h>
#import "ViewController.h"

@interface InfoViewController (){
    sqlite3 *_sqlite;
}

@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) IBOutlet UILabel *spell;
@property (weak, nonatomic) IBOutlet UILabel *meaning;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据库路径及名称PoorWordViewController
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"db.sqlite1"];
    // 打开数据库连接，如果有就打开，没有就重新创建连接
    NSInteger state = sqlite3_open(fileName.UTF8String, &_sqlite);
    //查询sql语句
    NSString *sql = [NSString stringWithFormat:@"select * from jccard where id = %@",self.wordId];
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(_sqlite, sql.UTF8String, -1, &stmt, NULL);
    //若查询成功
    if (state == SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //单词
            NSString *word = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            self.word.text = word;
            //拼写
            NSString *spell = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            self.spell.text = spell;
            //意思
            NSString *mean = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            self.meaning.text = mean;
        }
    }
}

- (IBAction)btnClick:(UIButton *)sender {
        char *error = NULL;
        //修改是否记住
        NSString *sql1 = [NSString stringWithFormat:@"update jccard set bookmark = %ld where id = %@", (long)sender.tag,self.wordId];
        //执行
        sqlite3_exec(_sqlite, sql1.UTF8String, NULL, NULL, &error);
         
        NSLog(@"success%ld",(long)sender.tag);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
