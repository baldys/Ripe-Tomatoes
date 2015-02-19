//
//  MovieDetailViewController.h
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *detailImageView;
@property (nonatomic, strong) Movie *movie;




//@property NSString *imgfile;
- (void) movieDetails:(Movie*)newMovie;
@end
