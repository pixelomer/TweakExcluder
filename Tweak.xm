#import <Foundation/Foundation.h>
#import "TweakConfiguratorShared/TweakConfigurator.h"
#if DEBUG
#define NSLog(args...) NSLog(@"[TweakConfigurator] "args)
#else
#define NSLog(...); /* */
#endif

%hookf(void *, dlopen, const char *path, int mode) {
	if (path == NULL) return %orig;
	@autoreleasepool {
		NSString *nspath = @(path);
		NSString *bid = NSBundle.mainBundle.bundleIdentifier;
		NSString *tweak = [nspath lastPathComponent];
		if (path != NULL && bid &&
			([nspath hasPrefix:@"/usr/lib/tweaks"] || [nspath hasPrefix:@"/Library/MobileSubstrate/DynamicLibraries"]) &&
			[tweak hasSuffix:@".dylib"])
		{
			NSDictionary *blacklist = [NSDictionary dictionaryWithContentsOfFile:[TweakConfigurator getPreferencePathForTweakNamed:tweak withSuffix:TWEAKCFG_BLACKLIST]];
			if (blacklist) {
				id kwhitelist = [blacklist objectForKey:kTweakConfigWhitelist];
				bool usingWhitelist = (kwhitelist && [kwhitelist isKindOfClass:[NSNumber class]] && [kwhitelist boolValue]);
				id item = [blacklist objectForKey:bid];
				if (!usingWhitelist && (item && [item isKindOfClass:[NSNumber class]] && [item boolValue])) return NULL;
				else if (usingWhitelist && (!item || ([item isKindOfClass:[NSNumber class]] && ![item boolValue]))) return NULL;
			}
		}
	}
	return %orig;
}