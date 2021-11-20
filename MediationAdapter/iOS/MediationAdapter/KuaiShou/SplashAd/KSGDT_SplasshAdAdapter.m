//
//  KSGDT_SplasshAdAdapter.m
//  GDTMobApp
//
//  Created by Nancy on 2021/1/2.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "KSGDT_SplasshAdAdapter.h"
#import "GDTSplashAdNetworkConnectorProtocol.h"
#import <KSAdSDK/KSAdSDK.h>
#import "MediationAdapterUtil.h"
#import "KSGDT_SplasshAdDelegateObject.h"

@interface KSGDT_SplasshAdAdapter ()
@property (nonatomic, weak) id <GDTSplashAdNetworkConnectorProtocol> connector;
@property (nonatomic, strong) KSSplashAdView *splashAdView;
@property (nonatomic, copy) NSString *posId;
@property (nonatomic, strong) KSGDT_SplasshAdDelegateObject *delegateObject;
@end


@implementation KSGDT_SplasshAdAdapter
@synthesize backgroundColor;
@synthesize backgroundImage;
@synthesize fetchDelay;
@synthesize skipButtonCenter;
@synthesize needZoomOut;
@synthesize splashZoomOutView;
@synthesize shouldLoadFullscreenAd;

#pragma mark - GDTSplashAdNetworkConnectorProtocol

+ (void)updateAppId:(NSString *)appId extStr:(NSString *)extStr {    
    if (KSAdSDKManager.appId.length == 0) {
        if ([appId length] > 0) {
            [KSAdSDKManager setAppId:appId];
        }
        else {
            NSDictionary *params = [MediationAdapterUtil getURLParams:extStr];
            [KSAdSDKManager setAppId:params[@"appid"]];
        }
    }
}

- (instancetype)initWithAdNetworkConnector:(id<GDTSplashAdNetworkConnectorProtocol>)connector
                                     posId:(NSString *)posId
{
    if (!connector) {
        return nil;
    }
    
    if (self = [super init]) {
        self.connector = connector;
        self.posId = posId;
        
    }
    return self;
}

- (void)loadAd {
    self.delegateObject = [[KSGDT_SplasshAdDelegateObject alloc] init];
    self.delegateObject.adapter = self;
    self.delegateObject.connector = self.connector;
    
    KSSplashAdView *splashAdView = [[KSSplashAdView alloc] initWithPosId:self.posId];
    splashAdView.timeoutInterval = self.fetchDelay;
    splashAdView.delegate = self.delegateObject;
    [splashAdView loadAdData];
    self.splashAdView = splashAdView;
}

- (void)showAdInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView skipView:(UIView *)skipView {
    self.splashAdView.rootViewController = window.rootViewController;
    [self.splashAdView showInView:window];
}

- (NSInteger)eCPM
{
    return -1;
}

- (BOOL)isAdValid {
    return self.delegateObject.splashAdContentLoaded;
}



@end
