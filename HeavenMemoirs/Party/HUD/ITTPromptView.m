//
//  ITTPromptView.m
//  YiXin
//
//  Created by qiuyan on 15-2-2.
//  Copyright (c) 2015年 com.yixin. All rights reserved.
//
#import "UIView+ITTAdditions.h"
#import "ITTPromptView.h"

@implementation ITTPromptView

@synthesize message = _message;


+(ITTPromptView *)showMessage:(NSString *)message andFrameY:(int)_y
{
    ITTPromptView *view = [super viewFromNib];
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.8f;
    view.layer.shadowRadius = 4.f;

    [view show];
    view.frametop -= _y;
    view.message.text = message;
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self makeCornerRadius:5.0f];
    [self performSelector:@selector(cancel) withObject:nil afterDelay:1];
}
@end
