//
//  ITTPromptView.h
//  YiXin
//
//  Created by qiuyan on 15-2-2.
//  Copyright (c) 2015年 com.yixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoppingBaseView.h"

@interface ITTPromptView : PoppingBaseView
{
    IBOutlet UILabel *_message;
    IBOutlet UIImageView *messageimgView;
}

@property (nonatomic ,strong) IBOutlet UILabel *message;//提示文字

+ (ITTPromptView *)showMessage:(NSString *)message andFrameY:(int)_y;

@end
