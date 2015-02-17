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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    // Do any additional setup after loading the view, typically from a nib.
    
    // next page http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=kkat5xh5bfr8bmsbnredmx5b&page_limit=10&page=2
    
    //first page url (display first 10 movies)
    NSString *myUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=kkat5xh5bfr8bmsbnredmx5b&page_limit=10";
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

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.movies.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieCell";
    
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.item];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [cell cellWithMovie:movie];
        
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
