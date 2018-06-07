//
//  LoadIngHUD.m
//  iOS_Product
//
//  Created by 朱飞飞 on 15/11/29.
//  Copyright © 2015年 朱飞飞. All rights reserved.
//
#import "AMTumblrHud.h"
#import "LoadIngHUD.h"
@interface LoadIngHUD()
@property (nonatomic,strong) AMTumblrHud *hud;
@end
@implementation LoadIngHUD
//屏幕宽高
#define  SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define  SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
static LoadIngHUD* _instance = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}
- (AMTumblrHud *)hud{
    if (_hud == nil) {
        _hud = [[AMTumblrHud alloc]initWithFrame:CGRectMake((CGFloat) ((SCREEN_WIDTH - 55) * 0.5),(CGFloat) ((SCREEN_HEIGHT - 20) * 0.5), 55, 20)];
        _hud.hudColor = [UIColor grayColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
    }
    return _hud;
}
- (void)Show{
    [self.hud showAnimated:YES];
}

- (void)hidden{
    [self.hud hide];
}
@end
