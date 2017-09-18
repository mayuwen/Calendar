//
//  CollectionViewCell.h
//  Calendar
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

//公历
@property (weak, nonatomic) IBOutlet UILabel *title;
//阴历
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end
