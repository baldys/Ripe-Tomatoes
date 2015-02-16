//
//  MovieDetailViewController.m
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "NearbyTheatresViewController.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)configureView
{

    self.titleLabel.text = self.movie.title;
    NSData *imageData = [NSData dataWithContentsOfURL:self.movie.thumbnailURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.detailImageView.image = image;
    self.synopsisLabel.text = self.movie.synopsis;

}

-(void) movieDetails:(Movie*)newMovie
{
    self.movie = [[Movie alloc] init];
    self.movie = newMovie;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NearbyTheatresViewController *mapVC = [segue destinationViewController];
    mapVC.selectedMovie = [[Movie alloc] init ];
    mapVC.selectedMovie = self.movie;
}

@end
