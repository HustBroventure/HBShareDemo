//
//  HBShareManager.h
//  HBSocialShare
//
//  Created by wangfeng on 16/6/27.
//  Copyright © 2016年 HustBroventure. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ShareType) {
    WeChatFriend = 0,
    WeChatCircle,
    QQFriend,
    QQZone,
    WeiBo
};

/**
 @discussion 在这里分享的内容只能是链接形式。也就是包含标题，内容，占位图片，和跳转的链接
 @see HBShareManager
 */
@interface HBShareModel : NSObject

    ///分享的标题，非空
@property(nonatomic,copy)NSString *shareTitle;
    ///分享的内容，可为空
@property(nonatomic,copy)NSString *shareContent;
    ///分享的占位图片的url
@property(nonatomic,copy)NSString *shareThumbImageUrl;
    ///分享的占位图片data数据
@property(nonatomic,copy)NSData *shareThumbImageData;
    ///分享的点击跳转的链接
@property(nonatomic,copy)NSString *shareUrl;

@end

/**
 @discussion 分享功能的单例类
 */
@interface HBShareManager : NSObject

/**
 单例不解释
 
 @return 实例
 */
+ (instancetype)sharedInstance;
/**
 注册各个平台的appkey，需要应用启动时就调用
 
 @param wechatkey							<#wechatkey description#>
 @param qqKey									<#qqKey description#>
 @param shareLinkWithShareType	<#shareLinkWithShareType description#>
 @param type										<#type description#>
 @param shareModel							<#shareModel description#>
 */
- (void)registerApiKeysWithWeChatKey:(NSString*)wechatkey QQKey:(NSString*)qqKey weibokey:(NSString*)weibokey;

/**
 分享方法
 
 @param type		分享的type
 @param shareModel	分享的内modle
 
 @return            YES分享成功，NO分享失败
 */
- (BOOL)shareLinkWithShareType:(ShareType)type shareModel:(HBShareModel *)shareModel;


@end

