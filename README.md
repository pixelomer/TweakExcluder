# TweakConfigurator

## History

This is a poorly-made tweak which made it possible to enable/disable certain tweaks for certain apps. It is poorly made because instead of using a single preference file, it uses tons of preference files for each app. These files also don't use the correct naming convention. It also uses `NSDictionary` functions to load preference files rather than just using `NSUserDefaults` which is the correct class to use.

## Original Description

This is a tweak that lets you configure the injection process of tweaks. The settings for the tweak can be found in the Preferences app.  
**Warning:** Do not attempt to install this tweak on a device running anything lower than iOS 11, it will cause a respring loop!

### TODO

- [x] Ability to disable specific tweaks in specific apps
- [x] Preference bundle
- [x] Switch to disable tweaks in SpringBoard
- [x] Option to whitelist instead of blacklist
- [ ] Ability to inject tweaks into unsupported apps
- [ ] Support for iOS 6.0 and higher (currently \>iOS 11.0)
