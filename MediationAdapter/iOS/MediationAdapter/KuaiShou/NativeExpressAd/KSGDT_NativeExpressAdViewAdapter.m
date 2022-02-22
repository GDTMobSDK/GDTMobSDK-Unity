//
//  KSGDT_NativeExpressAdViewAdapter.m
//  GDTMobApp
//
//  Created by rowanzhang on 2021/8/12.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_NativeExpressAdViewAdapter.h"

@interface KSGDT_NativeExpressAdViewAdapter () <KSFeedAdDelegate>

@property (nonatomic, strong) KSFeedAd *feedAd;
@property (nonatomic, assign) BOOL isExposured;

@end

@implementation KSGDT_NativeExpressAdViewAdapter
@synthesize controller = _controller;
@synthesize isReady = _isReady;
@synthesize isVideoAd = _isVideoAd;
@synthesize gdtExpressAdView = _gdtExpressAdView;

- (instancetype)initWithFeedAd:(KSFeedAd *)feedAd
{
    self = [super init];
    if (self) {
        self.feedAd = feedAd;
        self.feedAd.delegate = self;
    }
    return self;
}

#pragma mark - GDTNativeExpressAdViewAdapterProtocol

- (UIView *)adView {
    return self.feedAd.feedView;
}

- (NSInteger)eCPM {
    return self.feedAd.ecpm;
}

- (nonnull NSString *)eCPMLevel {
    return @"";
}

- (void)render {
    
}

- (BOOL)isVideoAd {
    return self.feedAd.materialType == KSAdMaterialTypeVideo;
}

- (BOOL)isReady {
    return YES;
}

- (CGFloat)videoDuration {
    return -1;
}

- (CGFloat)videoPlayTime {
    return -1;
}

- (BOOL)isAdValid {
    return YES;
}

//设置实际结算价
- (void)setBidECPM:(NSInteger)price {
    [self.feedAd setBidEcpm:price];
}

- (void)sendLossNotification:(NSInteger)price reason:(NSInteger)reason adnId:(NSString *)adnId {
    [self.feedAd reportAdExposureFailed:0 reportParam:nil];
}

#pragma mark - KSFeedAdDelegate

- (void)feedAdViewWillShow:(KSFeedAd *)feedAd {
    if (self.isExposured) {
        return;
    }
    self.isExposured = YES;
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterExposure:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterExposure:self];
    }
}

- (void)feedAdDidClick:(KSFeedAd *)feedAd {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterClicked:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterClicked:self];
    }
}

- (void)feedAdDislike:(KSFeedAd *)feedAd {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterClosed:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterClosed:self];
    }
}

- (void)feedAdDidShowOtherController:(KSFeedAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterDidPresentScreen:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterDidPresentScreen:self];
    }
}

- (void)feedAdDidCloseOtherController:(KSFeedAd *)nativeAd interactionType:(KSAdInteractionType)interactionType {
    if ([self.connector respondsToSelector:@selector(adapter_nativeExpressAdViewAdapterDidDissmissScreen:)]) {
        [self.connector adapter_nativeExpressAdViewAdapterDidDissmissScreen:self];
    }
}

@end
