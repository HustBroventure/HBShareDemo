//
//  HBShareManager.m
//  HBSocialShare
//
//  Created by wangfeng on 16/6/27.
//  Copyright © 2016年 HustBroventure. All rights reserved.
//

#import "HBShareManager.h"
#import "WXApi.h"
#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
@implementation HBShareModel

@end

@interface HBShareManager()

@property (nonatomic, strong) TencentOAuth *tencentOAuth ;

@end
@implementation HBShareManager

+ (instancetype )sharedInstance{
    static HBShareManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [HBShareManager new];
        
    });
    return instance;
}
- (void)registerApiKeysWithWeChatKey:(NSString*)wechatkey QQKey:(NSString*)qqKey weibokey:(NSString*)weibokey
{
    if (weibokey.length > 0) {
        [WXApi registerApp:wechatkey];
    }
    if (qqKey.length > 0) {
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqKey andDelegate:nil];
    }
    if (weibokey.length >0) {
        [WeiboSDK registerApp:weibokey];
    }
    
}
- (BOOL)shareLinkWithShareType:(ShareType)type shareModel:(HBShareModel *)shareModel
{
    switch (type) {
        case WeChatFriend:
            return [self shareLinkToWeChatWithScene:WXSceneSession shareModel:shareModel];
            break;
        case WeChatCircle:
            return [self shareLinkToWeChatWithScene:WXSceneTimeline shareModel:shareModel];
            break;
        case QQZone:
            return [self shareLinkToQQWithScene:1 shareModel:shareModel];
            break;
        case QQFriend:
            return [self shareLinkToQQWithScene:0 shareModel:shareModel];
            break;
        case WeiBo:
            return [self shareLinkToWeiboWithShareModel:shareModel];
            break;
            
        default:
            break;
    }
    
    return NO;
}
- (void)handlerNotInstallAppWithTytpe:(ShareType)type
{
    NSLog(@"应用未安装");
}


#pragma mark - ShareActions


- (BOOL)shareLinkToWeChatWithScene:(enum WXScene)scene shareModel:(HBShareModel *)shareModel
{
    if ([WXApi isWXAppInstalled]) {
        WXMediaMessage *mediaMessage = [WXMediaMessage message];
        mediaMessage.title = shareModel.shareTitle.length > 0 ? shareModel.shareTitle : @"标题";
        mediaMessage.description = shareModel.shareContent.length > 0 ? shareModel.shareContent : @"";
        WXWebpageObject *webPage = [WXWebpageObject object];
        webPage.webpageUrl = shareModel.shareUrl.length > 0 ? shareModel.shareUrl : @"";
        mediaMessage.mediaObject = webPage;
        
        if (shareModel.shareThumbImageData) {
            [mediaMessage setThumbData:shareModel.shareThumbImageData];
        }else if ( shareModel.shareThumbImageUrl) {
                //此处有一个隐患，url获取data是一个同步请求
           UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareModel.shareThumbImageUrl]]];
            [mediaMessage setThumbImage:image];

        }
            //随意设置，便于统计作用
        mediaMessage.mediaTagName   = @"WECHAT_TAG_SHARE";
        SendMessageToWXReq *request = [SendMessageToWXReq new];
        request.bText = NO;
        request.message = mediaMessage;
        request.scene = scene;
        
        return [WXApi sendReq:request];
        
    }else{
        [self handlerNotInstallAppWithTytpe:WeChatFriend];
        return NO;
    }
}
- (BOOL)shareLinkToQQWithScene:(NSInteger)scene shareModel:(HBShareModel *)shareModel
{
    if ([TencentOAuth iphoneQQInstalled]) {
        QQApiNewsObject *newsObject = nil;
        NSString *title       = shareModel.shareTitle.length > 0 ? shareModel.shareTitle : @"标题";
        NSString *description = shareModel.shareContent.length > 0 ? shareModel.shareContent : @"";
        NSString * str_url = shareModel.shareUrl.length > 0 ? shareModel.shareUrl : @"";
        NSURL  *url = [NSURL URLWithString:str_url];
        NSData *imageData = shareModel.shareThumbImageData;
        if (imageData) {
             newsObject = [QQApiNewsObject objectWithURL:url title:title description:description  previewImageData:imageData];
        }else{
            NSString *imageUrl = shareModel.shareUrl.length > 0?shareModel.shareUrl:@"";
            newsObject = [QQApiNewsObject objectWithURL:url title:title description:description previewImageURL:[NSURL URLWithString:imageUrl]];
        }
        
        SendMessageToQQReq* request  = [SendMessageToQQReq reqWithContent:newsObject];
        QQApiSendResultCode resultCode = 0;
            //1 为QQZOne 0 为QQ
        if (scene) {
             resultCode = [QQApiInterface SendReqToQZone:request];
        }else{
             resultCode = [QQApiInterface sendReq:request];
        }
        if (0 == resultCode) {
            return YES;
        }
        return NO;
    }else{
        [self handlerNotInstallAppWithTytpe:QQFriend];
        return NO;
    }

}
- (BOOL)shareLinkToWeiboWithShareModel:(HBShareModel *)shareModel {
    if ([WeiboSDK isWeiboAppInstalled]) {
        
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = shareModel.shareUrl ;
        webpage.title = shareModel.shareTitle.length > 0 ? shareModel.shareTitle : @"标题";
        webpage.description =shareModel.shareContent.length > 0 ? shareModel.shareContent : @"";
        if (shareModel.shareThumbImageData) {
            webpage.thumbnailData = shareModel.shareThumbImageData;
        }else if (shareModel.shareThumbImageUrl) {
                //此处有一个隐患，url获取data是一个同步请求
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareModel.shareThumbImageUrl]];
             webpage.thumbnailData = data;
        }
        webpage.webpageUrl = shareModel.shareUrl;
        WBMessageObject *message = [WBMessageObject message];
        message.mediaObject = webpage;
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
        return [WeiboSDK sendRequest:request];
    }else {
        [self handlerNotInstallAppWithTytpe:WeiBo];
        return NO;
    }
    
    
}



@end
