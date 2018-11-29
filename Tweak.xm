#import <Foundation/Foundation.h>

static NSArray<NSString*> *frameworkBIDs;

%hookf(void *, dlopen, const char *path, int mode) {
	@autoreleasepool {
		NSString *nspath = @(path);
		NSString *bid = NSBundle.mainBundle.bundleIdentifier;
		NSString *tweak = [nspath lastPathComponent];
		if (bid &&
			([nspath hasPrefix:@"/usr/lib/tweaks"] || [nspath hasPrefix:@"/Library/MobileSubstrate/DynamicLibraries"]) &&
			[tweak hasSuffix:@".dylib"])
		{
			NSDictionary *tweakConfig = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@%@%@", @"/Library/MobileSubstrate/UserConfigs/", [tweak substringToIndex:([tweak length] - [@".dylib" length])], @".plist"]];
			NSLog(@"%@: %@", tweak, tweakConfig);
			if (tweakConfig) {
				id blacklist = [tweakConfig objectForKey:@"AppBlacklist"];
				NSLog(@"Blacklist: %@", blacklist);
				if (blacklist && [blacklist isKindOfClass:[NSArray class]] && [(NSArray*)blacklist count] > 0) {
					if ([(NSArray*)blacklist containsObject:bid]) return NULL;
					for (NSString *bbid in (NSArray*)blacklist) if ([frameworkBIDs containsObject:bbid]) return NULL;
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