//
//  NearbyTheatresViewController.h
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NearbyTheatresViewController : UIViewController <MKMapViewDelegate>


@property(nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString *movieTitle;
@property (nonatomic, strong) NSString *address;



@end
