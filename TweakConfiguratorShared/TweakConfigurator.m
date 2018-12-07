#import <Foundation/Foundation.h>
#import "TweakConfigurator.h"

@implementation TweakConfigurator

+ (NSString *)getPreferencePathForTweakNamed:(NSString *)tweakName withSuffix:(NSString *)suffix {
    return [
		@"/var/mobile/Library/Preferences" stringByAppendingPathComponent:[TweakConfigurator getPreferenceFilenameForTweakNamed:tweakName withSuffix:suffix]
	];
}

+ (NSString *)getPreferenceFilenameForTweakNamed:(NSString *)tweakName withSuffix:(NSString *)suffix {
    return [
        [
            @"TweakConfig-" stringByAppendingString:[
                [tweakName stringByDeletingPathExtension] stringByAppendingString:(suffix ? suffix : @"")
            ]
        ] stringByAppendingPathExtension:@"plist"
    ];
}

+ (NSString *)getPreferencePathForTweakNamed:(NSString *)tweakName {
    return [TweakConfigurator getPreferencePathForTweakNamed:tweakName withSuffix:nil];
}

@end