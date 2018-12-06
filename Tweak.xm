#import <Foundation/Foundation.h>
#import "TweakConfigurator.h"
#if DEBUG
#define NSLog(args...) NSLog(@"[TweakConfigurator] "args)
#else
#define NSLog(...); /* */
#endif

static NSArray<NSString*> *frameworkBIDs;

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
			NSDictionary *blacklist = [NSDictionary dictionaryWithContentsOfFile:[
					@"/var/mobile/Library/Preferences" stringByAppendingPathComponent:[
						@"TweakConfig-" stringByAppendingString:[
							[
								[tweak stringByDeletingPathExtension] stringByAppendingString:@"-Blacklist"
							] stringByAppendingPathExtension:@"plist"
						]
					]
				]
			];
			if (blacklist) {
				for (NSString *key in blacklist) {
					id kenabled = [blacklist objectForKey:key];
					if (!kenabled || ![kenabled isKindOfClass:[NSNumber class]] || ![kenabled boolValue]) continue;
					if ([bid isEqualToString:key] || [frameworkBIDs containsObject:key]) return NULL;
				}
			}
		}
	}
	return %orig;
}

%ctor {
	NSMutableArray<NSString*> *mutableBIDs = [[NSMutableArray alloc] init];
	@autoreleasepool {
		NSArray<NSBundle*> *bundles = [NSBundle allFrameworks];
		for (NSBundle *bundle in bundles) {
			NSString *bid = [bundle bundleIdentifier];
			if (bid) [mutableBIDs addObject:bid];
		}
	}
	frameworkBIDs = [mutableBIDs copy];
}