//
//  MovieCell.h
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCell : UICollectionViewCell

@property (readonly, weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)cellWithMovie:(Movie*)movie;

@end
