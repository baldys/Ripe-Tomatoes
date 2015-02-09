//
//  NearbyTheatresViewController.m
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import "NearbyTheatresViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface NearbyTheatresViewController ()
<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

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
    }
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = true;
    self.mapView.delegate = self;
    
    // zooms in automatically to the location and the map shows an area within 0.02 latitudes/longtitudes of current location
    MKCoordinateRegion startingRegion;
    startingRegion.center = self.locationManager.location.coordinate; //risky to use before authorization
    startingRegion.span.latitudeDelta = 0.02;
    startingRegion.span.longitudeDelta = 0.02;
    
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
    NSLog(@"%@", [locations lastObject]);
    NSLog(@"%@", locations);
    CLLocation* location = [locations firstObject];
    NSDate* eventDate = location.timestamp;
    
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 60)
    {
        NSLog(@"latitude: %+.6f, longitude: %+.6f", location.coordinate.latitude, location.coordinate.longitude);
   
    }
    [self addressFromLatitudeAndLongitude:location];
    
    /*
     - (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary
     completionHandler:(CLGeocodeCompletionHandler)completionHandler
      (^CLGeocodeCompletionHandler)(NSArray *placemark, NSError *error)
    */
}

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
             NSLog(@"%@, %@, %@, %@, %@, %@", [placemark thoroughfare], [placemark subLocality],[placemark subAdministrativeArea], [placemark administrativeArea], [placemark country], [placemark postalCode]);
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
    pinView.pinColor = MKPinAnnotationColorGreen;
    //pinView.calloutOffset = CGPointMake(-7, 0);
    
    return pinView;
}
 
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Got error %@", [error localizedDescription]);
}

- (void) showMovieTheatres
{
    
    // example api call http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=49.2804249,-123.1069674&movie=Paddington
    
    //NSString *apiEndpoint =  @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json";
    NSString *urlString = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=49.2804249,-123.1069674&movie=Paddington";
    NSURLSession *session = [NSURLSession sharedSession ];
    
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        // do stuff
        
        NSLog(@"response received  %@", data);
        
        NSLog(@"response: %@", response);
        NSLog(@"ERROR: %@", error);
        /*
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!self.nearbyTheatres)
        {
            self.nearbyTheatres = [[NSMutableArray alloc] init];
        }
        
        self.nearbyTheatres = [NSMutableArray array];
        // NSArray theatresArray = [dataDictionary objectForKey:@"theatres"];
        //NSLog(@"dataDictionary %@", dataDictionary);
        // for (NSDictionary *theatreDataDictionary in theatresArray)
        //  Theatre *theatre = [[Theatre alloc]init];
        // theatre.name = theatreDataDictionary[@"name"];
        // theatre.address = theatreDataDictionary[@"address"];
        // theatre.location.latitude = theatreDataDictionary[@"lat"];
        // theatre.location.longitude = theatreDataDictionary[@"lng"];
        // [self.theatres addObject:theatre];
        */
                    
    }] resume];
    
    //NSString * apiString = [apiEndpoint stringByAppendingString:[NSString stringWithFormat:@"?address=%f,%%20%f&movie=%@",self.locationManager.location.coordinate.latitude, self.userLocation.coordinate.longitude, self.movieTitle ]];
    
    //NSLog(@"%@", apiString);
}


@end


