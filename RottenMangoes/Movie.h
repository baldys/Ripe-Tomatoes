//
//  Movie.h
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-06.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *theatreReleaseDate;
@property (nonatomic, strong) NSString *mpaaRating;
@property NSInteger year;
@property NSInteger runtime;
@property (nonatomic, strong) NSString *synopsis;

@property (nonatomic, strong) NSDictionary *imageDictionary;
@property (nonatomic, strong) NSString *thumbnail;

@property (nonatomic, strong) NSDictionary *ratings;
@property (nonatomic, strong) NSString *criticsRating;
@property NSInteger criticsScore;
@property (nonatomic, strong) NSString *audienceRating;
@property NSInteger audienceScore;

@property (nonatomic, strong) NSDictionary *reviews;


- (NSURL *)thumbnailURL;

- (NSString*)formattedDate;


@property (nonatomic, strong) NSArray *theatres;

@end
