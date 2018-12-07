#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSwitchTableCell.h>
#import "../TweakConfiguratorShared/TweakConfigurator.h"

@interface PXOMRKRVTWKCFGRootListController : PSListController {
    NSString *_selectedItem;
    PSSpecifier *_blacklistLinkCell;
    PSSpecifier *_blacklistSBSwitch;
}

@end
