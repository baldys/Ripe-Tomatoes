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

    // Do any additional setup after loading the view, typically from a nib.
    
    /// ugh spaghettti code
    NSString *myUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=kkat5xh5bfr8bmsbnredmx5b&page_limit=50";
    NSURL *moviesURL = [NSURL URLWithString:myUrl];
    NSLog(@"%@", moviesURL);
    NSData *jsonData = [NSData dataWithContentsOfURL:moviesURL];
    NSLog(@"%@",jsonData);
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
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
        //movie.id = [movieDictionary objectForKey:@"id"];
        movie.mpaaRating = [movieDictionary objectForKey:@"mpaa_rating"];
        movie.synopsis = [movieDictionary objectForKey:@"synopsis"];
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        [numberFormatter numberFromString:]
        
        // theatre release date
        movie.theatreReleaseDate = [[movieDictionary objectForKey:@"release_dates"] objectForKey:@"theatres"];
        
        // year
        movie.year = [[movieDictionary objectForKey:@"year"] intValue];
        // runtime (in minutes)
        movie.runtime = [[movieDictionary objectForKey:@"runtime"] intValue];
        NSLog(@"title: %@", movie.title);
        
        
        // retreive thumbnail image url
        NSDictionary *posters = [movieDictionary objectForKey:@"posters"];
        movie.thumbnail = [posters objectForKey:@"thumbnail"];
    
        [self.movies addObject:movie];
    }
    
    layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(150, 150);
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
    [cell cellWithMovie:movie];
    
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
    //MovieDetailViewController *detailVC =[self.storyboard instantiateViewControllerWithIdentifier:@"ActressDetailViewController"];
    
    //Movie *movie = self.movies[indexPath.row];
   
    // detailVC.imgfile= actress.imageFile;
    // detailVC.movie = movie;
    
    //[self.navigationController pushViewController:detailVC animated:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    
    NSLog(@"preparing for segue");
    MovieDetailViewController *detailVC = [segue destinationViewController];
    detailVC.movie = [[Movie alloc] init];
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems]objectAtIndex:0];
    Movie *movie = [[Movie alloc] init];
    movie = self.movies[indexPath.item];
    NSLog(@"movie.title %@",movie.title);
    detailVC.movie = self.movies[indexPath.item];

}


@end
