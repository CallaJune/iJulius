//
//  MainViewController.h
//  iJulius
//
//  Created by Calla on 5/27/14.
//  Copyright (c) 2014 Calla. All rights reserved.
//

#import "FlipsideViewController.h"
#import <UIKit/UIKit.h>
#import "Caesar_CipherModel.h"
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>

@interface MainViewController : UIViewController <UITextFieldDelegate, MFMailComposeViewControllerDelegate, ADBannerViewDelegate, MFMessageComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailComposer;
    MFMessageComposeViewController *smsComposer;
}
@property (retain) Caesar_CipherModel *model;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *cipherLabel;
@property (retain) IBOutlet UITextField *originalText;
@property (retain) IBOutlet UITextField *codedText;

-(IBAction)sliderMoved;
-(IBAction)originalChanged;
-(IBAction)codedChanged;
-(IBAction)update;
- (IBAction)sendMail:(id)sender;
- (IBAction)sendSMS:(id)sender;
-(IBAction)textFieldReturn:(id)sender;
@end
