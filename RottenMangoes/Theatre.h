//
//  Theatre.h
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-08.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface Theatre : NSObject
{
    double _latitude;
    double _longitude;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;

@end

