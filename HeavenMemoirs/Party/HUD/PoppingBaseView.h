//
//  PoppingBaseView.h
//  iTotemFrame
//
//  Created by Yan Guanyu on 5/29/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoppingBaseView : UIView

+ (id)viewFromNib;
+ (id)loadFromNib;
- (void)show;
- (void)cancel;
- (void)cancelWithAnimation:(BOOL)isAnimation;

//Subclass
- (void)didShow;
- (void)willCancel:(BOOL)isAutoCancel;
- (void)didCancel;

//Animation
+ (CAKeyframeAnimation*)scaleAnimation:(BOOL)show;


@end
