//
//  SignUpViewController.m
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-16.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@implementation SignUpViewController

- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailAddressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                  message:@"Make sure you enter a username, password, and email address!"
                 delegate:nil
        cancelButtonTitle:@"OK"
        otherButtonTitles:nil];
    [alertView show];
    }

    else
    {
    
        PFUser *newUser = [PFUser user];
    
        newUser.username = username;
    
        newUser.password = password;
    
        newUser.email = email;
    
    
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (error)
            {
            
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                    message:[error.userInfo objectForKey:@"error"]
                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

@end
