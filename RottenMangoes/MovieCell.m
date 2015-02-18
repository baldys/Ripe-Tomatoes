//
//  MovieCell.m
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import "MovieCell.h"

@interface MovieCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MovieCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

-(void)cellWithMovie:(Movie *)movie
{
    if ([movie.thumbnail isKindOfClass:[NSString class]])
    {
        // get the thumbnail image for the movie cell
        NSData *imageData = [NSData dataWithContentsOfURL:movie.thumbnailURL];
        UIImage *image = [UIImage imageWithData:imageData];
        self.imageView.image = image;
    }
 
    else
    {
        NSLog(@"image not displayed");
    }
    // set the label as the movies' title
}



@end
