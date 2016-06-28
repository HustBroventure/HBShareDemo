//
//  HBSocialShareView.h
//  HBSocialShareDemo
//
//  Created by wangfeng on 15/10/21.
//  Copyright (c) 2015年 HustBroventure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBShareManager.h"
//typedef NS_ENUM(NSUInteger, ShareType) {
//    WeChatFriend = 0,
//    WeChatCircle,
//    QQFriend,
//    QQZOne,
//};

@interface HBSocialShareView : UIView

@property (nonatomic, strong) void(^buttonClickBlock)(ShareType shareType);

+ (void)showInSuperView:(UIView*)view;

@end

