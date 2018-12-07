#include "RootListController.h"
#if DEBUG
#define NSLog(args...) NSLog(@"[TweakConfigurator] [Prefs] "args)
#else
#define NSLog(...); /* */
#endif

// PXOMR        KRV                TWKCFG
// My username  Some random chars  Tweak Configurator

@implementation PXOMRKRVTWKCFGRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		// Hardcoded count because if something is modified, things can go wrong
		if (!_specifiers || [_specifiers count] != 5) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Error" target:self] retain];
		}
		else {
			_blacklistLinkCell = [_specifiers objectAtIndex:3];
			_blacklistSBSwitch = [_specifiers objectAtIndex:4];
		}
	}
	return _specifiers;
}

- (NSString *)getSelectedItem:(PSSpecifier *)specifier {
	NSLog(@"getSelectedItem:%@", specifier);
	return _selectedItem;
}

- (void)setSelectedItem:(NSString *)newValue forSpecifier:(PSSpecifier *)specifier {
	NSLog(@"setSelectedItem:%@", newValue);
	if (newValue && ![newValue isEqualToString:@""]) {
		[_blacklistLinkCell setProperty:@YES forKey:PSEnabledKey];
		[_blacklistLinkCell
			setProperty:[TweakConfigurator getPreferencePathForTweakNamed:newValue withSuffix:TWEAKCFG_BLACKLIST]
			forKey:@"ALSettingsPath"
		];
		[_blacklistSBSwitch setProperty:@YES forKey:PSEnabledKey];
		[_blacklistSBSwitch
			setProperty:[TweakConfigurator getPreferenceFilenameForTweakNamed:newValue withSuffix:TWEAKCFG_BLACKLIST]
			forKey:PSDefaultsKey
		];
	}
	else {
		[_blacklistLinkCell setProperty:@NO forKey:PSEnabledKey];
		[_blacklistSBSwitch setProperty:@NO forKey:PSEnabledKey];
		[_blacklistSBSwitch removePropertyForKey:PSDefaultsKey];
		[_blacklistSBSwitch setProperty:@NO forKey:PSDefaultValueKey];
	}
	_selectedItem = newValue;
	[self reload];
}

- (void)respring {
	popen("killall SpringBoard", "r");
}

- (NSArray *)tweakList:(PSSpecifier *)specifier {
	NSMutableArray *tweaks = [[NSMutableArray alloc] init];
	NSFileManager *fm = NSFileManager.defaultManager;
	NSArray<NSString*> *fileList = [fm contentsOfDirectoryAtPath:MS_DYLIB_FOLDER error:nil];
	if (fileList) for (NSString *file in fileList) {
		if (![file hasSuffix:@".dylib"] || [file hasPrefix:@" "]) continue;
		NSString *fullPlistPath = [MS_DYLIB_FOLDER stringByAppendingPathComponent:[[file stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"]];
		NSLog(@"%@: %@", file, fullPlistPath);
		if (![fm isReadableFileAtPath:fullPlistPath]) continue;
		[tweaks addObject:file];
	}
	NSLog(@"%@", tweaks);
	return [[tweaks copy] retain];
}

@end
