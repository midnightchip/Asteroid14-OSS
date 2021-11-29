#import "./include/Tweak.h"
#import <Asteroid14-Swift.h>
#import <Foundation/Foundation.h>

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application{
    %orig;
	[[NSNotificationCenter defaultCenter] addObserver:self 
                selector:@selector(handleNotification:) 
                name:@"com.midnightchips.asteroid-appstate-changed" object:nil];
    

}

%new
-(void)handleNotification:(NSNotification *) notification {
    if (isSpringBoardAtFront && MSHookIvar<BOOL>([%c(SBLockScreenManager) sharedInstance], "_isScreenOn")) {
        [[NSNotificationCenter defaultCenter] 
            postNotificationName:@"ResumeAnimation" 
            object:self];
    } else {
         [[NSNotificationCenter defaultCenter] 
            postNotificationName:@"PauseAnimation" 
            object:self];
    }
}

%end


