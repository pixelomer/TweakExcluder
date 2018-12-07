#define MS_ROOT @"/Library/MobileSubstrate"
#define MS_DYLIB_FOLDER @"/Library/MobileSubstrate/DynamicLibraries"
#define TWEAKCFG_BLACKLIST @"-Blacklist"

@interface TweakConfigurator : NSObject {}

+ (NSString *)getPreferencePathForTweakNamed:(NSString *)tweakName withSuffix:(NSString *)suffix;
+ (NSString *)getPreferencePathForTweakNamed:(NSString *)tweakName;
+ (NSString *)getPreferenceFilenameForTweakNamed:(NSString *)tweakName withSuffix:(NSString *)suffix;

@end