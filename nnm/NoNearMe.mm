#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>

@interface NoNearMeListController: PSListController {
}
@end

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end

@implementation NoNearMeListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"NoNearMe" target:self] retain];
	}
	return _specifiers;

}

-(void)fix {

	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About The Fix" 
                message:@"When an application launches,it displays an image(or splash screen on startup). The reason for a splash screen is to give the user the feeling that the application is loading faster then it actually is. By default, the App Store application shows an image with five tabs on the bottom. Enabling the fix causes the application to launch without a splash screen but you may perceive the application as launching slower when it is in reality taking the same amount of time."
                delegate:nil 
                cancelButtonTitle:@"Okay" 
                otherButtonTitles:nil];
            [alert show];
            [alert release];

}


-(void)twitter {

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/Fewjative"]];

}

@end

// vim:ft=objc
