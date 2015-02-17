//
//  NearbyTheatresViewController.m
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import "NearbyTheatresViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Theatre.h"

@interface NearbyTheatresViewController ()
<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *theatres;
@property (strong, nonatomic) NSMutableArray *theatreLocations;


@end

@implementation NearbyTheatresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    NSLog(@"self.mapView.userLocation: %@ \n", self.mapView.userLocation);
    
    
    // zooms in automatically to the location and the map shows an area within 0.02 latitudes/longtitudes of current location
    MKCoordinateRegion startingRegion;
    startingRegion.center = self.locationManager.location.coordinate; //risky to use before authorization
    startingRegion.span.latitudeDelta = 0.04;
    startingRegion.span.longitudeDelta = 0.04;
    
    [self.mapView setRegion:startingRegion];
    
    MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];

    [self addressFromLatitudeAndLongitude:self.locationManager.location];
    [self showMovieTheatres];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"location %@", [locations lastObject]);
    NSLog(@"locations %@", locations);
    CLLocation* location = [locations lastObject];
    
    NSDate* eventDate = location.timestamp;
    
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 60)
    {
        NSLog(@"latitude: %+.6f, longitude: %+.6f", location.coordinate.latitude, location.coordinate.longitude);
   
    }
    if (locations.count > 100)
    {
        [self.locationManager stopUpdatingLocation];
    }
    [self addressFromLatitudeAndLongitude:location];
    
    /*
     - (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary
     completionHandler:(CLGeocodeCompletionHandler)completionHandler
      (^CLGeocodeCompletionHandler)(NSArray *placemark, NSError *error)
    */
}

// gives the address of my/the users current location
- (void) addressFromLatitudeAndLongitude:(CLLocation*)location
{
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^
     (NSArray *placemarks, NSError* error)
     {
         if (placemarks && placemarks.count > 0)
         {
            
             CLPlacemark *placemark = placemarks[0];
             NSLog(@"placemark location: %@", [placemark location]);
             NSLog(@"%@, %@, %@ %@, %@, %@, %@, %@",[placemark subThoroughfare], [placemark thoroughfare], [placemark subLocality],[placemark locality],[placemark subAdministrativeArea], [placemark administrativeArea], [placemark country], [placemark postalCode]);
         }
     }];
}


/*
- (void)geocodeLocation:(CLLocation*)location forAnnotation:(MapLocation*)annotation
{
    if (!self.geocoder)
        self.geocoder = [[CLGeocoder alloc] init];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             annotation.placemark = [placemarks objectAtIndex:0];
             
             // Add a More Info button to the annotation's view.
             MKPinAnnotationView* view = (MKPinAnnotationView*)[map viewForAnnotation:annotation];
             if (view && (view.rightCalloutAccessoryView == nil))
             {
                 view.canShowCallout = YES;
                 view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
             }
         }
     }];
}
*/

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)_annotation
{
    NSLog(@"$$$$$");
    
    if (_annotation == self.mapView.userLocation){
        return nil; //default to blue dot
    }
    
    static NSString* annotationIdentifier = @"cityHallAnnotation";
    
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView) {
        // if an existing pin view was not available, create one
        pinView = [[MKPinAnnotationView alloc]
                   initWithAnnotation:_annotation reuseIdentifier:annotationIdentifier];
    }
    
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorRed;
    //pinView.calloutOffset = CGPointMake(-7, 0);
    
    return pinView;
}
 
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Got error %@", [error localizedDescription]);
}

- (void) addLocation:(NSString*) title withLat:(float)lat andLng:(float)lng{
    
    MKPointAnnotation *marker=[[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D theatreLocation;
    theatreLocation.latitude = lat;
    theatreLocation.longitude = lng;
    marker.coordinate = theatreLocation;
    marker.title = title;
    if (self.theatreLocations == nil)
    {
        self.theatreLocations = [NSMutableArray array];
    }
    [self.theatreLocations addObject:marker];

}
// show the movie theatres playing the selected movie using URL sessiom
- (void) showMovieTheatres
{
    NSLog(@"self.mapView.userlocation.title: %@", self.mapView.userLocation.title);
    
    // example api call http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=49.2804249,-123.1069674&movie=Paddington
    
    //NSString *apiEndpoint =  @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json";
    
    NSString *apiEndpoint = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json";
    NSString *encodedMovieTitleString = [self.selectedMovie.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString= [apiEndpoint stringByAppendingString:[NSString stringWithFormat:@"?address=%+.6f,%+.6f&movie=%@",self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, encodedMovieTitleString]];
    NSLog(@"URL STRING: %@", urlString);
    NSLog(@"latitude: %+.6f, longitude: %+.6f \n", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    NSLog(@"self.mapVIew.userlocation %@ \n", self.mapView.userLocation);
    
    NSURLSession *session = [NSURLSession sharedSession ];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"%@", data);
        NSLog(@"%@", response);
        NSLog(@"%@", error);
        
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (!self.theatres)
        {
            self.theatres = [[NSMutableArray alloc] init];
        }
        
        self.theatres = [NSMutableArray array];
        
        NSArray *theatresArray = dataDictionary[@"theatres"];
        
        // theatre data dictionary - dictionary of theatre objects
        // contains keys id, name, address, lat, lng
    
        for (NSDictionary *theatreDataDictionary in theatresArray)
        {
            
            Theatre *theatre = [[Theatre alloc] init];
            NSLog(@"%@", theatreDataDictionary[@"name"]);
            theatre.name = theatreDataDictionary[@"name"];
            theatre.address = theatreDataDictionary[@"address"];
            theatre.lat = theatreDataDictionary[@"lat"];
            theatre.lng = theatreDataDictionary[@"lng"];
            NSLog(@"trying to parse: %@ ", theatreDataDictionary[@"lat"]);
            NSLog(@"trying to parse: %@ ", theatreDataDictionary[@"lng"]);
            
            NSLog(@"trying to parse: %@ ", theatre.lng);
            float latitude = [theatre.lat floatValue];
            float longitude = [theatre.lng floatValue];
            [self.theatres addObject:theatre];
            [self addLocation:theatre.name withLat:latitude andLng:longitude];
            
        }
        
        for (MKPointAnnotation* annotation in self.theatreLocations)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self.mapView addAnnotation:annotation];
            
            });
            
        }
        
        
    }] resume];
   
//    for (MKPointAnnotation* annotation in self.theatreLocations)
//    {
//        [self.mapView addAnnotation:annotation];
//    }
  
    for (Theatre *theatre in self.theatres)
    {
        NSLog(@"%@", theatre.address);
    }
    //NSString * apiString = [apiEndpoint stringByAppendingString:[NSString stringWithFormat:@"?address=%f,%%20%f&movie=%@",self.locationManager.location.coordinate.latitude, self.userLocation.coordinate.longitude, self.movieTitle ]];
    
    //NSLog(@"%@", apiString);
}


@end


