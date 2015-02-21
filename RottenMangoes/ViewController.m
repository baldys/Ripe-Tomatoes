//
//  ViewController.m
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-05.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//
#import "ViewController.h"
#import "MovieDetailViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import <Parse/Parse.h>


@interface ViewController ()
{
    UICollectionViewFlowLayout* layout;
    //NSInteger *indexOfSelectedItem;
}

@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) NSMutableArray *reviews;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    // Do any additional setup after loading the view, typically from a nib.
    
    // next page http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=kkat5xh5bfr8bmsbnredmx5b&page_limit=10&page=2
    
    //first page url (display first 50 movies)
    NSString *myUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=kkat5xh5bfr8bmsbnredmx5b&page_limit=50";
    
    
    
    NSURL *moviesURL = [NSURL URLWithString:myUrl];
    NSLog(@"%@", moviesURL);
    
    NSURLSession *session = [NSURLSession sharedSession ];
    [[session dataTaskWithURL:moviesURL
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          
          if (!self.movies)
          {
              self.movies = [[NSMutableArray alloc] init];
          }
          self.movies = [NSMutableArray array];
          
          NSArray *moviesArray = [dataDictionary objectForKey:@"movies"];
          
          NSLog(@"dataDictionary %@", dataDictionary);
          for (NSDictionary *movieDictionary in moviesArray)
          {
              
              Movie *movie = [[Movie alloc] init];
              movie.movieID = [movieDictionary objectForKey:@"id"];
              movie.title = [movieDictionary objectForKey:@"title"];
              
              movie.mpaaRating = [movieDictionary objectForKey:@"mpaa_rating"];
              movie.synopsis = [movieDictionary objectForKey:@"synopsis"];
              
              // theatre release date
              movie.theatreReleaseDate = [[movieDictionary objectForKey:@"release_dates"] objectForKey:@"theatres"];
              
              // year
              movie.year = [[movieDictionary objectForKey:@"year"] intValue];
              // runtime (in minutes)
              movie.runtime = [[movieDictionary objectForKey:@"runtime"] intValue];
              
              
              
              // retreive thumbnail image url
              NSDictionary *posters = [movieDictionary objectForKey:@"posters"];
              movie.thumbnail = [posters objectForKey:@"thumbnail"];
              movie.ratings = [movieDictionary objectForKey:@"ratings"];
              movie.criticsRating = [movie.ratings objectForKey:@"critics_rating"];
              movie.criticsScore = [[movie.ratings objectForKey:@"critics_score"]intValue];
              movie.audienceRating = [movie.ratings objectForKey:@"audience_rating"];
              movie.audienceScore = [[movie.ratings objectForKey:@"audience_score"] intValue];
              [self.movies addObject:movie];
          }
          
          dispatch_async(dispatch_get_main_queue(), ^{
              
              [self.collectionView reloadData];
              
          });
          
      }] resume];
     
   // NSData *jsonData = [NSData dataWithContentsOfURL:moviesURL];
 //   NSLog(@"%@",jsonData);
 //   NSError *error = nil;
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(300, 300);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 10.0f;
    layout.minimumLineSpacing = 10.0f;
    [self.collectionView setCollectionViewLayout:layout];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"button" style:UIBarButtonItemStylePlain target:self action:@selector(someMethod)];
    
}


- (void)loadReviewsFromURL:(NSURL*)reviewsUrl
{
    // reviews [ -> review {critic date freshness publication quote},{},{} ]
    ///
    static const NSString* kReviews = @"reviews";
    static const NSString* kCritic = @"critic";
    static const NSString* kDate = @"date";
    static const NSString* kCriticMovieRating = @"freshness";
    static const NSString* kPublication = @"publication";
    static const NSString* kQuote = @"quote";
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:reviewsUrl
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         
         self.reviews = [NSMutableArray array];
         
         NSArray *reviewsArray = [dataDictionary objectForKey:kReviews];
         NSArray *keys = @[kCritic, kDate, kCriticMovieRating, kPublication,kQuote];
         NSLog(@"dataDictionary %@", dataDictionary);
         for (NSDictionary *reviewDictionary in reviewsArray)
         {
             [reviewDictionary dictionaryWithValuesForKeys:keys];
             //NSLog(@"reviewDIct[0] %@", reviewDictionary[0]);
             [self.reviews addObject:reviewDictionary];
             
             
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self.collectionView reloadData];
         });
     }] resume ];

}



#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.movies.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MovieCell class]) forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.item];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([movie.thumbnail isKindOfClass:[NSString class]]) {
            NSData *imageData = [NSData dataWithContentsOfURL:movie.thumbnailURL];
            UIImage *image = [UIImage imageWithData:imageData];

            dispatch_async(dispatch_get_main_queue(), ^{
                MovieCell *cell = (MovieCell *)[collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            });

        }
    });
    return cell;
}
/*
 - (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 
 }
 */

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select item");
    Movie *movie = [[Movie alloc]init];
    movie = self.movies[indexPath.item];
   
    // get movie reviews for the corresponding movie ID to put in the url string
    NSURL *reviewsURL = [movie reviewsURLForMovie:movie.movieID];
    NSLog(@"reviewsURL: %@", reviewsURL);
    [self loadReviewsFromURL:reviewsURL];
    
    //MovieDetailViewController *detailVC =[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    //Movie *movie = self.movies[indexPath.row];
   
    // detailVC.imgfile= movie.imageFile;
    // detailVC.movie = movie;
    
    //[self.navigationController pushViewController:detailVC animated:true];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    MovieDetailViewController *detailVC = [segue destinationViewController];
    detailVC.movie = [[Movie alloc] init];
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems]objectAtIndex:0];
    Movie *movie = [[Movie alloc] init];
    movie = self.movies[indexPath.item];
    NSLog(@"movie.title %@",movie.title);
    detailVC.movie = self.movies[indexPath.item];

}


@end
