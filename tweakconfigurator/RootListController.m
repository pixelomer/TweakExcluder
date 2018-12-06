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
		_blacklistLinkCell = [_specifiers lastObject];
		[_blacklistLinkCell setProperty:@NO forKey:PSEnabledKey];
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
			setProperty:[
				@"/var/mobile/Library/Preferences" stringByAppendingPathComponent:[
					@"TweakConfig-" stringByAppendingString:[
						[
							[newValue stringByDeletingPathExtension] stringByAppendingString:@"-Blacklist"
						] stringByAppendingPathExtension:@"plist"
					]
				]
			]
			forKey:@"ALSettingsPath"
		];
		NSLog(@"%@", [_blacklistLinkCell propertyForKey:@"ALSettingsPath"]);
	}
	else [_blacklistLinkCell setProperty:@NO forKey:PSEnabledKey];
	_selectedItem = newValue;
	[self reload];
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
