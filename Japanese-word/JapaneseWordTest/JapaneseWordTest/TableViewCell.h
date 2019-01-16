//
//  TableViewCell.h
//  JapaneseWordTest
//
//  Created by iOS123 on 2019/1/10.
//  Copyright © 2019年 iOS123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spell;
@property (weak, nonatomic) IBOutlet UILabel *word;
@property (weak, nonatomic) NSString *wordId;
@end

NS_ASSUME_NONNULL_END
