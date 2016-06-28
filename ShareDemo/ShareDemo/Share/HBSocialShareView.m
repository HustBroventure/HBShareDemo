//
//  HBSocialShareView.m
//  HBSocialShareDemo
//
//  Created by wangfeng on 15/10/21.
//  Copyright (c) 2015年 HustBroventure. All rights reserved.
//

#import "HBSocialShareView.h"
#define BG_COLOR  [[UIColor blackColor] colorWithAlphaComponent:0.3];
#define CONTAINER_HEIGHT  (200.0f)

#define BUTTON_HEIGHT  (44.0f)

@interface HBSocialShareView()
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) UILabel* topInfoLabel;
@property (nonatomic, strong) UIButton* cancleButton;

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) UITapGestureRecognizer* tap;


@end
@implementation HBSocialShareView
{
    NSArray* _itemTitleArray;
    NSArray* _itemImageArray;
    CGFloat  _width;
    CGFloat  _height;
}
#pragma mark - public methords
- (instancetype)init
{
    if (self = [super init]) {
        [self initSubView];
        
    }
    return self;
}
+ (void)showInSuperView:(UIView*)view
{
    HBSocialShareView* shareView = [[HBSocialShareView alloc]init];
    [view.window addSubview:shareView];
    [shareView showSheet];
}

#pragma mark - private-tools methords
-(void)initSubView
{
        //一开始显示透明颜色
    self.backgroundColor = [UIColor clearColor];
    _width = [UIScreen mainScreen].bounds.size.width;
    _height = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, _width, _height);
    [self addGestureRecognizer:self.tap];
    [self.containerView addSubview:self.topInfoLabel];
    [self.containerView addSubview:self.scrollView];
    [self.containerView addSubview:self.cancleButton];
    [self addSubview:self.containerView];

}
-(void)showSheet
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = BG_COLOR;
        CGRect containerFrame = self.containerView.frame;
        containerFrame.origin.y = _height -  CONTAINER_HEIGHT;
        self.containerView.frame = containerFrame;
        
    } completion:^(BOOL finished) {
        
    }];
}
-(void)dismissSheet
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.backgroundColor =[UIColor clearColor];
        CGRect containerFrame = self.containerView.frame;
        containerFrame.origin.y = _height;
        self.containerView.frame = containerFrame;

        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(UIButton*)createItemButtonWithTitle:(NSString*)title andImageName:(NSString*)imageName
{
    UIButton* item = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString* imagePath = [NSString stringWithFormat:@"source.bundle/%@",imageName];
    UIImage* image = [UIImage imageNamed:imagePath];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    item.titleLabel.font = [UIFont systemFontOfSize:15];
    [item setImage:image forState:UIControlStateNormal];
    item.backgroundColor = [UIColor whiteColor];
    [item addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return item;
}
#pragma mark - property-setter-getter


#pragma mark - event methords
- (void)buttonClick:(UIButton*)sender
{
    ShareType type = sender.tag;
    HBShareModel* model = [HBShareModel new];
    model.shareTitle = @"测试标题";
    model.shareContent = @"测试内容";
    model.shareUrl = @"https://www.baidu.com";
    UIImage* image = [UIImage imageNamed:@"80x80"];
    model.shareThumbImageData = UIImagePNGRepresentation(image) ;
    
    [self dismissSheet];
    
   BOOL success =  [[HBShareManager sharedInstance] shareLinkWithShareType:type shareModel:model];
        //一般的错误就是应用未安装，这里简单处理就直接提示未安装应用。正常来说应该添加一个回调处理的
    if (!success) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该应用未安装" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
//    if (self.buttonClickBlock) {
//        self.buttonClickBlock(type);
//    }
    
}

#pragma mark - delegate methords
- (UIView *)containerView
{
    if (!_containerView) {
    
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, _height, _width,CONTAINER_HEIGHT)];
        _containerView.backgroundColor = [UIColor whiteColor];

    }
    return _containerView;
}
-(UIButton *)cancleButton
{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
//        [ _cancleButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
        [_cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleButton.frame = CGRectMake(0,CONTAINER_HEIGHT - BUTTON_HEIGHT, _width, BUTTON_HEIGHT);
        [_cancleButton addTarget:self action:@selector(dismissSheet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
- (UILabel *)topInfoLabel
{
    if (!_topInfoLabel) {
        _topInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,_width ,BUTTON_HEIGHT)];
        _topInfoLabel.textAlignment = NSTextAlignmentCenter;
        _topInfoLabel.text = @"分享";
    }
    return _topInfoLabel;
}
- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSheet)];
    }
    return _tap;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, BUTTON_HEIGHT, _width,CONTAINER_HEIGHT - BUTTON_HEIGHT * 2)];
        CGFloat padding = (_width - 320 )/5.0;
//        _scrollView.backgroundColor =  [UIColor colorWithWhite:0.8 alpha:0.9];
        UIButton* item1 = [self createItemButtonWithTitle:@"微信好友" andImageName:@"wechat_friend"];
        item1.frame =CGRectMake(padding, 0, 80, 100);
        [self verticalImageAndTitle:5 forButton:item1];
        [_scrollView addSubview:item1];
        
        UIButton* item2 = [self createItemButtonWithTitle:@"微信朋友圈" andImageName:@"wechat_circle"];
        item2.frame =CGRectMake(80+2*padding, 0, 80, 100);
        [self verticalImageAndTitle:5 forButton:item2];
        [_scrollView addSubview:item2];
        
        UIButton* item3 = [self createItemButtonWithTitle:@"QQ好友" andImageName:@"QQ"];
        item3.frame =CGRectMake(160+3*padding, 0, 80, 100);
        [self verticalImageAndTitle:5 forButton:item3];
        [_scrollView addSubview:item3];
        
        UIButton* item4 = [self createItemButtonWithTitle:@"QQ空间" andImageName:@"QQZone"];
        item4.frame =CGRectMake(240+4*padding, 0, 80, 100);
        [self verticalImageAndTitle:5 forButton:item4];
        [_scrollView addSubview:item4];
        UIButton* item5 = [self createItemButtonWithTitle:@"微博" andImageName:@"weibo"];
        item5.frame =CGRectMake(320+5*padding, 0, 80, 100);
        [self verticalImageAndTitle:5 forButton:item5];
        [_scrollView addSubview:item5];
        item1.tag = 0;
        item2.tag = 1;
        item3.tag = 2;
        item4.tag = 3;
        item5.tag = 4;
        _scrollView.contentSize = CGSizeMake(_width+2*padding+80, 0);
    }
    return _scrollView;
}
#pragma button tolls
- (void)verticalImageAndTitle:(CGFloat)spacing forButton:(UIButton*)button
{
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    CGSize textSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}
@end
