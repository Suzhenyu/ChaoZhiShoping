//
//  ViewController.h
//  Talktalk
//
//  Created by apple on 15/8/25.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegController : UIViewController{
    UITapGestureRecognizer *singleRecognizer;
    IBOutlet UIView *loginBgView;
    IBOutlet UIImageView *_imgLoginIcon;
    IBOutlet UITextField *tfUsername;
    IBOutlet UITextField *tfPwd1;
    IBOutlet UITextField *tfPwd2;
}
@property (nonatomic,assign) int fromTabSelectedIndex;

-(IBAction)nextAction:(id)sender;
@end
