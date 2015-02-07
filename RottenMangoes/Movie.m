//
//  Movie.m
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (NSURL *)thumbnailURL
{
    NSLog(@"%@", [self.thumbnail class]);
    return [NSURL URLWithString:self.thumbnail];
}

/*
- (UIImage *)imageFromURLString:(NSString *)url
{
    
    NSURL *imgUrl = [NSURL URLWithString:url];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    UIImage *image = [UIImage imageWithData:imgData];
    return image;
}
*/


-(NSString *)formattedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // formate from json data: "release_date": "2014-12-22 "
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // parse into a date object
    NSDate *tempDate = [dateFormatter dateFromString:self.theatreReleaseDate];
    // make it into a shorter date format i.e. Thu, Dec 25, 2014
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    //return date as a string
    return [dateFormatter stringFromDate:tempDate];
}



@end
