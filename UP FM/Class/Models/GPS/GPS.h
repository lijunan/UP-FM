//
//  GPS.h
//  UP FM
//
//  Created by liubin on 15/2/6.
//  Copyright (c) 2015年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol GPSDelegate <NSObject>

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end

@interface GPS : NSObject <CLLocationManagerDelegate> {
    CLLocationManager       *_locationManager;
    BOOL                    _isUpdate;
    __weak id <GPSDelegate> delegate;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL              isUpdate;
@property (nonatomic, weak) id <GPSDelegate> delegate;

+ (GPS *)sharedInstance;

@end
