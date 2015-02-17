//
//  LoginViewController.h
//  RottenMangoes
//
//  Created by Veronica Baldys on 2015-02-16.
//  Copyright (c) 2015 Veronica Baldys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)LogIn:(id)sender;

@end
