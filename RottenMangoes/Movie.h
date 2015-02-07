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


//@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *theatreReleaseDate;
@property (nonatomic, strong) NSString *mpaaRating;
@property NSInteger year;
@property NSInteger runtime;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *thumbnail;

@property (nonatomic, strong) NSDictionary *imageDictionary;
@property (nonatomic, strong) NSDictionary *ratings;
@property (nonatomic, strong) NSDictionary *reviews;

- (NSURL *)thumbnailURL;
//- (UIImage *)imageFromURLString:(NSString*)url;
- (NSString*)formattedDate;


@end
