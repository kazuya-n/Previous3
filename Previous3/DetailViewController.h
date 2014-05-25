//
//  DetailViewController.h
//  Previous3
//
//  Created by 野村和也 on 2014/05/25.
//  Copyright (c) 2014年 野村和也. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
