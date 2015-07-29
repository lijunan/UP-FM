//
//  GPS.m
//  UP FM
//
//  Created by liubin on 15/2/6.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import "GPS.h"

@implementation GPS

@synthesize locationManager = _locationManager;
@synthesize isUpdate = _isUpdate;
@synthesize delegate;

+ (GPS *)sharedInstance
{
    static dispatch_once_t onceToken;
    static GPS *gps;
    dispatch_once(&onceToken, ^{
        gps = [[self alloc] init];
    });
    return gps;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _locationManager = [[CLLocationManager alloc] init];
    
        // 判斷是否 iOS 8
        if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization]; // 永久授权
            [_locationManager requestWhenInUseAuthorization]; //使用中授权
        }
        
        if([CLLocationManager locationServicesEnabled]){
        
            _locationManager.delegate = self;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        }else{
            
        }
    }
    return self;
}

#pragma mark - CLLocationManager delegate
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    // 与上次测量地点的间隔距离
    if(oldLocation != nil){
        CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
        if(distance > 200) {
            [self.delegate locationUpdate:newLocation];
        }
    }
}

// 如果GPS测量失败了，下面的函数被调用
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"GPS获取失败");
    [self.delegate locationError:error];
}


@end
