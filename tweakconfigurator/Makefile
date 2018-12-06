include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TweakConfigurator
TweakConfigurator_FILES = RootListController.m
TweakConfigurator_INSTALL_PATH = /Library/PreferenceBundles
TweakConfigurator_FRAMEWORKS = UIKit
TweakConfigurator_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TweakConfigurator.plist$(ECHO_END)
