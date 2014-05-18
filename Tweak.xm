static BOOL tabFix = NO;

%hook ASTabBarController

-(void)setTransientViewController:(id)controller animated:(BOOL)animated{
	%log;
	%orig;
	/*NSMutableArray *tbViewControllers = [NSMutableArray arrayWithArray:[self viewControllers]];
	NSLog(@"tbV count before %ld",(long)[tbViewControllers count]);

	if(!removed)
	{
		NSLog(@"Removed item");
		[tbViewControllers removeObjectAtIndex:2];
		[self setViewControllers:tbViewControllers];
		removed = YES;
	}
	NSLog(@"tbV count after %ld",(long)[tbViewControllers count]);
	*/

	/*
		%log;
	%orig;
	NSMutableArray *tbViewControllers = [NSMutableArray arrayWithArray:[self viewControllers]];
	NSLog(@"tbV count before %ld",(long)[tbViewControllers count]);

	if([tbViewControllers count]==5)
	{
		NSLog(@"Removed item");
		[tbViewControllers removeObjectAtIndex:2];
		[self setViewControllers:tbViewControllers];
	}
	NSLog(@"tbV count after %ld",(long)[tbViewControllers count]);
*/

}

%end

//new code
%hook ASAppDelegate

-(id)init{
	%log;
	id r = %orig;
	NSLog(@"ASAppDelegate = %@",r);
	//UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
	//UIWindow* window = MSHookIvar<UIWindow * >(self,"_window");
	//NSLog(@"Window = %@",keyWindow);
	//UITabBarController *tbc = (UITabBarController *)window.rootViewController;
	//UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
	//UITabBarController * tbc =  (keyWindow.rootViewController).visibleViewController.tabBarController;
	//NSLog(@"Tab bar controller = %@",tbc);
	return r;
}

-(id)_defaultRootViewControllers{
	%log;
	id r= %orig;
	NSLog(@"_defaultRootViewControllers = %@",r);

	NSMutableArray *tbViewControllers = [NSMutableArray arrayWithArray:r];
	[tbViewControllers removeObjectAtIndex:2];
	return tbViewControllers;
}

-(BOOL)tabBarController:(id)controller shouldSelectViewController:(id)controller2{
	%log;
	BOOL r = %orig;
	NSLog(@"tbc = %@",controller);
	return r;
}

-(void)viewController:(id)controller didLoadContext:(id)context{
	%log;
	NSLog(@"viewcontroller = %@",controller);
	%orig;
}

-(void)_showTransientViewController:(id)controller{
	%log;
	%orig;
}

-(void)applicationWillResignActive:(id)application{
	%log;
	%orig;
}
-(void)applicationWillEnterForeground:(id)application{
	%log;
	%orig;

}
-(void)applicationDidBecomeActive:(id)application{
	%log;
	%orig;
}

%end

%hook SBApplication
//NSString* _bundleIdentifier;
-(BOOL)shouldLaunchPNGless{
	NSString* bundleIdentifier = MSHookIvar<NSString*>(self,"_bundleIdentifier");
	NSLog(@"BI = %@",bundleIdentifier);
	BOOL r = %orig;
	BOOL res = [bundleIdentifier isEqualToString:@"com.apple.AppStore"];
	if(res)
	{
		if(tabFix)
			return YES;
		else
			return NO;
	}else
		return r;
}

%end

static void loadPrefs() 
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.joshdoctors.nonearme.plist"];

    if(prefs)
    {
        tabFix = ([prefs objectForKey:@"tabFix"] ? [[prefs objectForKey:@"tabFix"] boolValue] : tabFix);
    }
    [prefs release];
}

%ctor 
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.joshdoctors.nonearme/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}