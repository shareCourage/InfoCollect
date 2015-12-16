//
//  ResultViewController.h
//  IDCardDemo
//
//  Created by wintone on 15/6/18.
//  Copyright (c) 2015年 wintone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController

@property (strong, nonatomic) NSString *resultString;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
