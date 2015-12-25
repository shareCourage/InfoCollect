//
//  PHLabel.h
//  InfoCollect
//
//  Created by Kowloon on 15/12/25.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
}VerticalAlignment;

@interface PHLabel : UILabel
@property (nonatomic) VerticalAlignment verticalAlignment;
@end
