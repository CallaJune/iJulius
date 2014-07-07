//
//  MainViewController.m
//  iJulius
//
//  Created by Calla on 5/27/14.
//  Copyright (c) 2014 Calla. All rights reserved.
//

#import "MainViewController.h"
#import "Caesar_CipherModel.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize model, slider, cipherLabel, originalText, codedText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [[Caesar_CipherModel alloc] init];
    model.decodeMode = NO;
    slider.minimumValue = 1;
    slider.maximumValue = 25;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//Method called when slider is moved. Updates the cipher key value in the model, and the label in the view
-(IBAction)sliderMoved{
	model.cipherKey = (int)slider.value;
	self.cipherLabel.text = [NSString stringWithFormat:@"Cipher Key: %d", model.cipherKey];
    [self update];
}


//Called whenever the orginal message box is changed. Provides live decoding.
-(IBAction)originalChanged{
    model.decodeMode = NO;
    model.originalMessage = originalText.text;
    [self update];
}

//Called whenever the coded message box is changed. Provides live decoding.
-(IBAction)codedChanged{
	model.decodeMode = YES;
	model.codedMessage = codedText.text;
	[self update];
}
//Updates the view based on the model, and calls the encrypt/decrypt actions
-(IBAction)update{
	self.slider.value = model.cipherKey;
	
	if (model.decodeMode) {
		[model decrypt];
		self.originalText.text = model.originalMessage;
	}
    else {
		[model encrypt];
		self.codedText.text = model.codedMessage;
	}
}

//Makes the keyboard go away when enter is pressed
/*-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}*/
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)sendMail:(id)sender{
    NSString *email = model.codedMessage;
    email = [email stringByAppendingString:@"\nDecrypt this message with iJulius from the iOS app store! Download it at http://bit.ly/iJulius"];
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Message from iJulius!"];
    [mailComposer setMessageBody:email isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

-(IBAction)sendSMS:(id)sender{
    if ([MFMessageComposeViewController canSendText])
    {
        smsComposer = [[MFMessageComposeViewController alloc]init];
        smsComposer.messageComposeDelegate = self;
        [smsComposer setBody:@"Message from iJulius"];
        NSString *sms = model.codedMessage;
        sms = [sms stringByAppendingString:@"\nDecrypt with iJulius! Download it at http://bit.ly/iJulius"];
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.body = sms;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"This device is not configured to send text messages" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - message compose delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	switch (result)
	{
		case MessageComposeResultCancelled:
			NSLog(@"Result: SMS sending canceled");
			break;
		case MessageComposeResultSent:
			NSLog(@"Result: SMS sent");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Result: SMS sending failed");
			break;
		default:
			NSLog(@"Result: SMS not sent");
			break;
	}
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark iAd Delegate Methods
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0 ];
    [UIView commitAnimations];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
