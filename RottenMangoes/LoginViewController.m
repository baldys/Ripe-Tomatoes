//
//  LoginViewController.m
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-16.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.H> 

@implementation LoginViewController

- (IBAction)LogIn:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                  message:@"Make sure you enter a username and password!"
                 delegate:nil
        cancelButtonTitle:@"OK"
        otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
        {
            if (error)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                          message:[error.userInfo
                     objectForKey:@"error"]
                         delegate:nil
                cancelButtonTitle:@"OK"
                otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                NSParameterAssert([NSThread isMainThread] == YES);
                [self performSegueWithIdentifier:@"showViewController" sender:self];
            }
        }];
    }

}
@end
