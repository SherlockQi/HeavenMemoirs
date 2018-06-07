//
//  LoadIngHUD.h
//  iOS_Product
//
//  Created by 朱飞飞 on 15/11/29.
//  Copyright © 2015年 朱飞飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadIngHUD : NSObject
+(instancetype) shareInstance ;
- (void)Show;
- (void)hidden;
@end
