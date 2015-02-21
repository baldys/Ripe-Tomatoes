//
//  NearbyTheatresViewController.h
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Movie.h"
#import "Theatre.h"
@interface NearbyTheatresViewController : UIViewController <MKMapViewDelegate>

@property(nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic,strong) Movie *selectedMovie;
@property (nonatomic,strong) Theatre *theatre;
@property (nonatomic, strong) NSString *theatresURLString;
//(NSDictionary*)getTheatresPlayingMovie:(NSString*)movieID(orname)


@end
